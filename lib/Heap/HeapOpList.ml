module M : Heap_intf.M with type vt = Term.t = struct
  type addr = int
  type size = Term.t
  type op = Term.t * Term.t * Term.t PC.t
  type t = { map : (addr, size * op list) Hashtbl.t; mutable next : int }
  type vt = Term.t

  let init () : t = { map = Hashtbl.create Parameters.size; next = 0 }

  let pp_block (fmt : Fmt.t) (block : size * op list) =
    let open Fmt in
    let pp_op fmt (i, v, _) = fprintf fmt "(%a %a)" Term.pp i Term.pp v in
    let sz, ops = block in
    fprintf fmt "(%a, [%a])" Term.pp sz (pp_lst ", " pp_op) ops

  let pp (fmt : Fmt.t) (heap : t) : unit =
    let open Fmt in
    let pp_binding fmt (x, v) = fprintf fmt "%a -> %a" pp_int x pp_block v in
    fprintf fmt "%a" (pp_hashtbl "\n" pp_binding) heap.map

  let to_string (heap : t) : string = Fmt.asprintf "%a" pp heap

  let is_within (sz : vt) (index : vt) (pc : vt PC.t) : bool =
    let e1 = Term.Binop (Lt, index, Val (Value.Integer 0)) in
    let e2 = Term.Binop (Gte, index, sz) in
    let e3 = Term.Binop (Or, e1, e2) in

    not (Translator.is_sat ([ e3 ] @ pc))

  let in_bounds (heap : t) (v : vt) (i : vt) (pc : vt PC.t) : bool =
    match v with
    | Val (Loc l) -> (
        match Hashtbl.find_opt heap.map l with
        | Some (sz, _) -> (
            match sz with
            | Val (Integer _) | I_symb _ -> is_within sz i pc
            | _ ->
                failwith
                  "InternalError: HeapOpList.in_bounds, size not an integer")
        | _ ->
            failwith
              "InternalError: HeapOpList.in_bounds, accessed OpList is not in \
               the heap")
    | _ -> failwith "InternalError: HeapOpList.in_bounds, v must be location"

  let malloc (h : t) (sz : vt) (pc : vt PC.t) : (t * vt * vt PC.t) list =
    let next = h.next in
    Hashtbl.add h.map next (sz, []);
    h.next <- h.next + 1;
    [ (h, Val (Loc next), pc) ]

  let update (h : t) (arr : vt) (index : vt) (v : vt) (pc : vt PC.t) :
      (t * vt PC.t) list =
    let lbl = match arr with Val (Loc i) -> i | _ -> assert false in
    let arr' = Hashtbl.find_opt h.map lbl in
    let f ((sz, oplist) : size * op list) : unit =
      Hashtbl.replace h.map lbl (sz, (index, v, pc) :: oplist)
    in
    Option.fold ~none:() ~some:f arr';
    [ (h, pc) ]

  let lookup h (arr : vt) (index : vt) (pc : vt PC.t) : (t * vt * vt PC.t) list
      =
    let lbl = match arr with Val (Loc i) -> i | _ -> assert false in
    let arr' = Hashtbl.find h.map lbl in
    let _, ops = arr' in
    let v =
      List.fold_left
        (fun ac (i, v, _) ->
          Term.Ite (Term.Binop (Term.Equals, index, i), v, ac))
        (Term.Val (Value.Integer 0)) (List.rev ops)
    in
    [ (h, v, pc) ]

  let free h (arr : vt) (pc : vt PC.t) : (t * vt PC.t) list =
    let lbl = match arr with Val (Loc i) -> i | _ -> assert false in
    Hashtbl.remove h.map lbl;
    [ (h, pc) ]

  let copy (heap : t) : t = { map = Hashtbl.copy heap.map; next = heap.next }
  let clone h = copy h
end
