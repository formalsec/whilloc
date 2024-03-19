open Encoding

module M = struct
  type value = Encoding.Expr.t
  type addr = int
  type size = value
  type op = value * value * value Pc.t
  type block = size * op list

  type t =
    { map : (addr, block) Hashtbl.t
    ; mutable next : int
    }

  exception BlockNotInHeap

  module Eval = Eval_symbolic

  let init ?(next = 0) () : t = { map = Hashtbl.create Parameters.size; next }

  let pp_block (fmt : Fmt.t) (block : block) =
    let open Fmt in
    let pp_op fmt (i, v, _) = fprintf fmt "(%a %a)" Expr.pp i Expr.pp v in
    let sz, ops = block in
    fprintf fmt "(%a, [%a])" Expr.pp sz (pp_lst ~pp_sep:pp_comma pp_op) ops

  let pp (fmt : Fmt.t) (heap : t) : unit =
    let open Fmt in
    let pp_binding fmt (x, v) = fprintf fmt "%a -> %a" pp_int x pp_block v in
    fprintf fmt "%a" (pp_hashtbl ~pp_sep:pp_newline pp_binding) heap.map

  let to_string (heap : t) : string = Fmt.asprintf "%a" pp heap

  let is_within (sz : value) (index : value) (pc : value Pc.t) : bool =
    let e1 = Expr.(relop Ty.Ty_int Ty.Lt index (make @@ Val (Int 0))) in
    let e2 = Expr.(relop Ty.Ty_int Ty.Ge index sz) in
    let e3 = Expr.(binop Ty.Ty_bool Ty.Or e1 e2) in

    not (Eval_symbolic.is_true (e3 :: pc))

  let in_bounds (heap : t) (v : value) (i : value) (pc : value Pc.t) : bool =
    match Expr.view v with
    | Val (Int l) -> (
      match Hashtbl.find_opt heap.map l with
      | Some (sz, _) -> (
        match Expr.view sz with
        | Val (Int _) -> is_within sz i pc
        | Symbol s when Symbol.type_of s = Ty_int -> is_within sz i pc
        | _ ->
          failwith "InternalError: HeapOpList.in_bounds, size not an integer" )
      | _ -> raise BlockNotInHeap )
    | _ -> failwith "InternalError: HeapOpList.in_bounds, v must be location"

  let malloc (h : t) (sz : value) (pc : value Pc.t) :
    (t * value * value Pc.t) list =
    let next = h.next in
    Hashtbl.add h.map next (sz, []);
    h.next <- h.next + 1;
    [ (h, Expr.(make @@ Val (Int next)), pc) ]

  let update (h : t) (arr : value) (index : value) (v : value) (pc : value Pc.t)
    : (t * value Pc.t) list =
    let lbl = match Expr.view arr with Val (Int i) -> i | _ -> assert false in
    let arr' = Hashtbl.find_opt h.map lbl in
    let f ((sz, oplist) : size * op list) : unit =
      Hashtbl.replace h.map lbl (sz, (index, v, pc) :: oplist)
    in
    Option.fold ~none:() ~some:f arr';
    [ (h, pc) ]

  let lookup h (arr : value) (index : value) (pc : value Pc.t) :
    (t * value * value Pc.t) list =
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

  let free (h : t) (arr : value) (pc : value Pc.t) : (t * value Pc.t) list =
    let addr' =
      match Expr.view arr with Val (Int i) -> i | _ -> assert false
    in
    Hashtbl.replace h.map addr' (Expr.(make @@ Val (Int 0)), []);
    [ (h, pc) ]

  let get_block (h : t) (addr : value) : block option =
    let addr' =
      match Expr.view addr with Val (Int i) -> i | _ -> assert false
    in
    match Hashtbl.find_opt h.map addr' with
    | Some (size, ops) ->
      if size = Expr.(make @@ Val (Int 0)) then None else Some (size, ops)
    | None -> None

  let set_block (h : t) (addr : value) (block : block) : t =
    let addr' =
      match Expr.view addr with Val (Int i) -> i | _ -> assert false
    in
    Hashtbl.replace h.map addr' block;
    h

  let copy (heap : t) : t = { map = Hashtbl.copy heap.map; next = heap.next }
  let clone h = copy h
end

module M' : Heap_intf.M with type value = Encoding.Expr.t = M
include M
