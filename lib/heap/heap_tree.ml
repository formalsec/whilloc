open Encoding

module M = struct
  type value = Encoding.Expr.t
  type range = value * value

  type tree_t =
    | Leaf of range * value
    | Node of range * tree_t list

  type t = (int, tree_t) Hashtbl.t * int

  let init () : t = (Hashtbl.create Parameters.size, 0)

  let rec pp_block (fmt : Fmt.t) (block : tree_t) : unit =
    let open Fmt in
    match block with
    | Leaf ((l, r), v) ->
      fprintf fmt {|{ "leaf": { "range": "[%a, %a]", "value": "%a"} }|}
        Expr.pp l Expr.pp r Expr.pp v
    | Node ((l, r), ch) ->
      fprintf fmt
        {|{ "node": { "range": "[%a, %a]", "children": [ %a ]} }|} Expr.pp
        l Expr.pp r
        (pp_lst ~pp_sep:pp_comma pp_block)
        ch

  let pp (fmt : Fmt.t) ((heap, _) : t) : unit =
    let open Fmt in
    let pp_binding fmt (_, v) = fprintf fmt "%a" pp_block v in
    fprintf fmt "%a" (pp_hashtbl ~pp_sep:pp_newline pp_binding) heap

  let tree_to_json (idx : int) (tree : tree_t) : unit =
    let f = open_out ("output/" ^ string_of_int idx ^ "_tree.json") in
    let tree_json = Fmt.asprintf "%a" pp_block tree in
    Printf.fprintf f "%s\n" tree_json;
    close_out f

  let to_string (h : t) : string =
    let h', _ = h in
    Hashtbl.iter tree_to_json h';
    "Json files created in output directory."

  let malloc (h : t) (sz : value) (pc : value Pc.t) : (t * value * value Pc.t) list =
    let h', curr = h in
    let tree =
      Leaf (Expr.(make @@ Val (Int 0), sz), Expr.(make @@ Val (Int 0)))
    in
    Hashtbl.replace h' curr tree;
    [ ((h', curr + 1), Expr.(make @@ Val (Int curr)), pc) ]

  let update h (arr : value) (index : value) (v : value) (pc : value Pc.t) :
    (t * value Pc.t) list =
    let h', next = h in
    let rec update_tree (tree : tree_t) (index : value) (v : value) (pc : value Pc.t) :
      (tree_t * value Pc.t) list option =
      match tree with
      | Leaf ((left, right), old_v) ->
        let ge_left = Expr.(relop Ty.Ty_int Ty.Ge index left) in
        let l_right = Expr.(relop Ty.Ty_int Ty.Lt index right) in
        let cond = Expr.(binop Ty.Ty_bool Ty.And ge_left l_right) in
        let pc' = cond :: pc in
        if Eval_symbolic.is_true pc' then
          let index_plus_1 =
            Expr.(binop Ty.Ty_int Ty.Add index (make @@ Val (Int 1)))
          in
          let leaves =
            [ Leaf ((left, index), old_v)
            ; Leaf ((index, index_plus_1), v)
            ; Leaf ((index_plus_1, right), old_v)
            ]
          in
          Some [ (Node ((left, right), leaves), pc') ]
        else None
      | Node ((left, right), trees) ->
        let ge_left = Expr.(relop Ty.Ty_int Ty.Ge index left) in
        let l_right = Expr.(relop Ty.Ty_int Ty.Lt index right) in
        let cond = Expr.(binop Ty.Ty_bool Ty.And ge_left l_right) in
        let pc' = cond :: pc in
        if Eval_symbolic.is_true pc' then
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
                    (Node ((left, right), [ nt1; t2; t3 ]), pc1) )
                  l1
              | None -> []
            in
            let l2 =
              match nt2 with
              | Some l2 ->
                List.map
                  (fun (nt2, pc2) ->
                    (Node ((left, right), [ t1; nt2; t3 ]), pc2) )
                  l2
              | None -> []
            in
            let l3 =
              match nt3 with
              | Some l3 ->
                List.map
                  (fun (nt3, pc3) ->
                    (Node ((left, right), [ t1; t2; nt3 ]), pc3) )
                  l3
              | None -> []
            in
            Some (l1 @ l2 @ l3)
          | _ -> failwith "unreachable"
        else None
    in
    let i =
      match Expr.view arr with
      | Val (Int i) -> i
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
          ((new_h, next), pc') )
        new_trees
    | None -> failwith "Out of bounds access"

  let must_within_range (r : range) (index : value) (pc : value Pc.t) : bool =
    let lower, upper = r in
    let e1 = Expr.(relop Ty.Ty_int Ty.Lt index lower) in
    let e2 = Expr.(relop Ty.Ty_int Ty.Ge index upper) in
    let e3 = Expr.(binop Ty.Ty_bool Ty.Or e1 e2) in

    not (Eval_symbolic.is_true (e3 :: pc))

  let may_within_range (r : range) (index : value) (pc : value Pc.t) : bool =
    let lower, upper = r in
    let e1 = Expr.(relop Ty.Ty_int Ty.Ge index lower) in
    let e2 = Expr.(relop Ty.Ty_int Ty.Lt index upper) in

    Eval_symbolic.is_true ([ e1; e2 ] @ pc)

  let rec search_tree (index : value) (pc : value Pc.t) (tree : tree_t) :
    (value * value) list =
    match tree with
    | Leaf (r, v) ->
      let lower, upper = r in
      let in_range = may_within_range r index pc in
      if in_range then
        [ ( v
          , Expr.(
              binop Ty.Ty_bool Ty.And
                (relop Ty.Ty_int Ty.Lt index upper)
                (relop Ty.Ty_int Ty.Ge index lower) ) )
        ]
      else []
    | Node (r, tree_list) ->
      let in_range = may_within_range r index pc in
      if in_range then List.concat (List.map (search_tree index pc) tree_list)
      else []

  let lookup h (arr : value) (index : value) (pc : value Pc.t) : (t * value * value Pc.t) list
      =
    let tbl, _ = h in

    match Expr.view arr with
    | Val (Int l) -> (
      match Hashtbl.find_opt tbl l with
      | Some tree ->
        let v =
          List.fold_left
            (fun ac (v, c) -> Expr.Bool.ite c v ac)
            Expr.(make @@ Val (Int 0))
            (search_tree index pc tree)
        in
        [ (h, v, pc) ]
      | _ ->
        failwith
          "InternalError: HeapTree.lookup, accessed tree is not in the heap" )
    | _ -> failwith "InternalError: HeapTree.lookup, arr must be location"

  let free h (arr : value) (pc : value Pc.t) : (t * value Pc.t) list =
    let h', _ = h in
    (* let ign = to_string h in
       ignore ign; *)
    ( match Expr.view arr with
    | Val (Int i) -> Hashtbl.remove h' i
    | _ -> failwith "Invalid allocation index" );
    [ (h, pc) ]

  let in_bounds (heap : t) (arr : value) (i : value) (pc : value Pc.t) : bool =
    let h', _ = heap in
    match Expr.view arr with
    | Val (Int l) -> (
      match Hashtbl.find_opt h' l with
      | Some tree -> (
        match tree with Leaf (r, _) | Node (r, _) -> must_within_range r i pc )
      | _ ->
        failwith
          "InternalError: HeapTree.in_bounds, accessed tree is not in the heap"
      )
    | _ -> failwith "InternalError: HeapTree.in_bounds, arr must be location"

  let copy ((heap, i) : t) : t = (Hashtbl.copy heap, i)
  let clone h = copy h
end

module M' : Heap_intf.M with type value = Encoding.Expr.t = M
include M
