open Encoding

module M : Heap_intf.M with type vt = Encoding.Expr.t = struct
  type vt = Encoding.Expr.t
  type addr = int
  type size = vt
  type op = vt * vt * vt Pc.t

  type t =
    { map : (addr, size * op list) Hashtbl.t
    ; mutable next : int
    }

  module Eval = Eval_symbolic.M

  let init () : t = { map = Hashtbl.create Parameters.size; next = 0 }

  let pp_block (fmt : Fmt.t) (block : size * op list) =
    let open Fmt in
    let pp_op fmt (i, v, _) = fprintf fmt "(%a %a)" Expr.pp i Expr.pp v in
    let sz, ops = block in
    fprintf fmt "(%a, [%a])" Expr.pp sz (pp_lst ~pp_sep:pp_comma pp_op) ops

  let pp (fmt : Fmt.t) (heap : t) : unit =
    let open Fmt in
    let pp_binding fmt (x, v) = fprintf fmt "%a -> %a" pp_int x pp_block v in
    fprintf fmt "%a" (pp_hashtbl ~pp_sep:pp_newline pp_binding) heap.map

  let to_string (heap : t) : string = Fmt.asprintf "%a" pp heap

  let is_within (sz : vt) (index : vt) (pc : vt Pc.t) : bool =
    let e1 = Expr.(relop Ty.Ty_int Ty.Lt index (make @@ Val (Int 0))) in
    let e2 = Expr.(relop Ty.Ty_int Ty.Ge index sz) in
    let e3 = Expr.(binop Ty.Ty_bool Ty.Or e1 e2) in

    not (Eval.is_true (e3 :: pc))

  let in_bounds (heap : t) (v : vt) (i : vt) (pc : vt Pc.t) : bool =
    match Expr.view v with
    | Val (Int l) -> (
      match Hashtbl.find_opt heap.map l with
      | Some (sz, _) -> (
        match Expr.view sz with
        | Val (Int _) -> is_within sz i pc
        | Symbol _ ->
          if Expr.ty sz = Ty_int then is_within sz i pc
          else
            failwith "InternalError: HeapOpList.in_bounds, size not an integer"
        | _ ->
          failwith "InternalError: HeapOpList.in_bounds, size not an integer" )
      | _ ->
        failwith
          "InternalError: HeapOpList.in_bounds, accessed OpList is not in the \
           heap" )
    | _ -> failwith "InternalError: HeapOpList.in_bounds, v must be location"

  let malloc (h : t) (sz : vt) (pc : vt Pc.t) : (t * vt * vt Pc.t) list =
    let next = h.next in
    Hashtbl.add h.map next (sz, []);
    h.next <- h.next + 1;
    [ (h, Expr.(make @@ Val (Int next)), pc) ]

  let update (h : t) (arr : vt) (index : vt) (v : vt) (pc : vt Pc.t) :
    (t * vt Pc.t) list =
    let lbl = match Expr.view arr with Val (Int i) -> i | _ -> assert false in
    let arr' = Hashtbl.find_opt h.map lbl in
    let f ((sz, oplist) : size * op list) : unit =
      Hashtbl.replace h.map lbl (sz, (index, v, pc) :: oplist)
    in
    Option.fold ~none:() ~some:f arr';
    [ (h, pc) ]

  let lookup h (arr : vt) (index : vt) (pc : vt Pc.t) : (t * vt * vt Pc.t) list
      =
    let lbl = match Expr.view arr with Val (Int i) -> i | _ -> assert false in
    let arr' = Hashtbl.find h.map lbl in
    let _, ops = arr' in
    let v =
      List.fold_left
        (fun ac (i, v, _) ->
          Expr.(Bool.ite Expr.(relop Ty.Ty_int Ty.Eq index i) v ac) )
        Expr.(make @@ Val (Int 0))
        (List.rev ops)
    in
    [ (h, v, pc) ]

  let free h (arr : vt) (pc : vt Pc.t) : (t * vt Pc.t) list =
    let lbl = match Expr.view arr with Val (Int i) -> i | _ -> assert false in
    Hashtbl.remove h.map lbl;
    [ (h, pc) ]

  let copy (heap : t) : t = { map = Hashtbl.copy heap.map; next = heap.next }
  let clone h = copy h
end
