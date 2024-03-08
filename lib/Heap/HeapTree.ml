module M : Heap_intf.M with type vt = Term.t = struct
  type vt = Term.t [@@deriving yojson]
  type range = vt * vt [@@deriving yojson]

  type tree_t = Leaf of range * vt | Node of range * tree_t list
  [@@deriving yojson]

  type t = (int, tree_t) Hashtbl.t * int

  let init () : t = (Hashtbl.create Parameters.size, 0)

  let pp (_fmt : Fmt.t) (_heap : t) : unit =
    failwith "Not Implemented"

  let tree_to_json (idx : int) (tree : tree_t) : unit =
    let rec iter_tree (tree : tree_t) : string =
      match tree with
      | Leaf ((l, r), v) ->
          "{ \"leaf\": { \"range\": \"[" ^ Term.to_string l ^ ", "
          ^ Term.to_string r ^ "[\", \"value\": " ^ "\"" ^ Term.to_string v
          ^ "\"" ^ " } }"
      | Node ((l, r), ch) ->
          "{ \"node\": { \"range\": \"[" ^ Term.to_string l ^ ", "
          ^ Term.to_string r ^ "[\", \"children\": " ^ "[ "
          ^ String.concat ", " (List.map iter_tree ch)
          ^ " ]" ^ " } }"
    in
    let f = open_out ("output/" ^ string_of_int idx ^ "_tree.json") in
    let tree_json = iter_tree tree in
    Printf.fprintf f "%s\n" tree_json

  let to_string (h : t) : string =
    let h', _ = h in
    Hashtbl.iter tree_to_json h';
    "Json files created in output directory."

  let malloc (h : t) (sz : vt) (pc : vt PC.t) : (t * vt * vt PC.t) list =
    let h', curr = h in
    let tree = Leaf ((Term.Val (Integer 0), sz), Term.Val (Integer 0)) in
    Hashtbl.replace h' curr tree;
    [ ((h', curr + 1), Term.Val (Loc curr), pc) ]

  let update h (arr : vt) (index : vt) (v : vt) (pc : vt PC.t) :
      (t * vt PC.t) list =
    let h', next = h in
    let rec update_tree (tree : tree_t) (index : vt) (v : vt) (pc : vt PC.t) :
        (tree_t * vt PC.t) list option =
      match tree with
      | Leaf ((left, right), old_v) ->
          let ge_left = Term.Binop (Gte, index, left) in
          let l_right = Term.Binop (Lt, index, right) in
          let cond = Term.Binop (And, ge_left, l_right) in
          let pc' = cond :: pc in
          if Translator.is_sat pc' then
            let index_plus_1 = Term.Binop (Plus, index, Val (Integer 1)) in
            let leaves =
              [
                Leaf ((left, index), old_v);
                Leaf ((index, index_plus_1), v);
                Leaf ((index_plus_1, right), old_v);
              ]
            in
            Some [ (Node ((left, right), leaves), pc') ]
          else None
      | Node ((left, right), trees) ->
          let ge_left = Term.Binop (Gte, index, left) in
          let l_right = Term.Binop (Lt, index, right) in
          let cond = Term.Binop (And, ge_left, l_right) in
          let pc' = cond :: pc in
          if Translator.is_sat pc' then
            let l = List.map (fun t -> update_tree t index v pc') trees in
            let t1, t2, t3 =
              match trees with
              | t1 :: t2 :: [ t3 ] -> (t1, t2, t3)
              | _ -> failwith "unreachable"
            in
            match l with
            | nt1 :: nt2 :: [ nt3 ] ->
                let l1 =
                  match nt1 with
                  | Some l1 ->
                      List.map
                        (fun (nt1, pc1) ->
                          (Node ((left, right), [ nt1; t2; t3 ]), pc1))
                        l1
                  | None -> []
                in
                let l2 =
                  match nt2 with
                  | Some l2 ->
                      List.map
                        (fun (nt2, pc2) ->
                          (Node ((left, right), [ t1; nt2; t3 ]), pc2))
                        l2
                  | None -> []
                in
                let l3 =
                  match nt3 with
                  | Some l3 ->
                      List.map
                        (fun (nt3, pc3) ->
                          (Node ((left, right), [ t1; t2; nt3 ]), pc3))
                        l3
                  | None -> []
                in
                Some (l1 @ l2 @ l3)
            | _ -> failwith "unreachable"
          else None
    in
    let i =
      match arr with
      | Val (Loc i) -> i
      | _ -> failwith "Invalid allocation index"
    in
    let tree = Hashtbl.find h' i in
    let new_trees = update_tree tree index v pc in
    match new_trees with
    | Some new_trees ->
        List.map
          (fun (new_tree, pc') ->
            let new_h = Hashtbl.copy h' in
            Hashtbl.replace new_h i new_tree;
            ((new_h, next), pc'))
          new_trees
    | None -> failwith "Out of bounds access"

  let must_within_range (r : range) (index : vt) (pc : vt PC.t) : bool =
    let lower, upper = r in

    let e1 = Term.Binop (Lt, index, lower) in
    let e2 = Term.Binop (Gte, index, upper) in
    let e3 = Term.Binop (Or, e1, e2) in

    not (Translator.is_sat (e3 :: pc))

  let may_within_range (r : range) (index : vt) (pc : vt PC.t) : bool =
    let lower, upper = r in

    let e1 = Term.Binop (Gte, index, lower) in
    let e2 = Term.Binop (Lt, index, upper) in

    Translator.is_sat ([ e1; e2 ] @ pc)

  let rec search_tree (index : vt) (pc : vt PC.t) (tree : tree_t) :
      (vt * vt) list =
    match tree with
    | Leaf (r, v) ->
        let lower, upper = r in
        let in_range = may_within_range r index pc in
        if in_range then
          [
            ( v,
              Term.Binop
                ( And,
                  Term.Binop (Lt, index, upper),
                  Term.Binop (Gte, index, lower) ) );
          ]
        else []
    | Node (r, tree_list) ->
        let in_range = may_within_range r index pc in
        if in_range then List.concat (List.map (search_tree index pc) tree_list)
        else []

  let lookup h (arr : vt) (index : vt) (pc : vt PC.t) : (t * vt * vt PC.t) list
      =
    let tbl, _ = h in

    match arr with
    | Val (Loc l) -> (
        match Hashtbl.find_opt tbl l with
        | Some tree ->
            let v =
              List.fold_left
                (fun ac (v, c) -> Term.Ite (c, v, ac))
                (Term.Val (Value.Integer 0))
                (search_tree index pc tree)
            in
            [ (h, v, pc) ]
        | _ ->
            failwith
              "InternalError: HeapTree.lookup, accessed tree is not in the heap"
        )
    | _ -> failwith "InternalError: HeapTree.lookup, arr must be location"

  let free h (arr : vt) (pc : vt PC.t) : (t * vt PC.t) list =
    let h', _ = h in
    (* let ign = to_string h in
       ignore ign; *)
    (match arr with
    | Val (Loc i) -> Hashtbl.remove h' i
    | _ -> failwith "Invalid allocation index");
    [ (h, pc) ]

  let in_bounds (heap : t) (arr : vt) (i : vt) (pc : vt PC.t) : bool =
    (* Printf.printf "In_bounds .array: %s, i: %s\n PC: %s\n" (Term.to_string arr) (Term.string_of_expression i) (PC.to_string Term.string_of_expression pc); *)
    let h', _ = heap in
    match arr with
    | Val (Loc l) -> (
        match Hashtbl.find_opt h' l with
        | Some tree -> (
            match tree with
            | Leaf (r, _) | Node (r, _) -> must_within_range r i pc)
        | _ ->
            failwith
              "InternalError: HeapTree.in_bounds, accessed tree is not in the \
               heap")
    | _ -> failwith "InternalError: HeapTree.in_bounds, arr must be location"

  let copy ((heap, i) : t) : t = (Hashtbl.copy heap, i)
  let clone h = copy h
end
