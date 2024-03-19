open Value

module M = struct
  type block = Value.t array
  type t = (int, block) Hashtbl.t * int
  type value = Value.t (* indexes and sizes are always values *)

  let init ?(next = 0) () : t = (Hashtbl.create Parameters.size, next)

  let pp_block fmt (block : block) =
    Fmt.fprintf fmt "%a"
      (Fmt.pp_lst ~pp_sep:Fmt.pp_comma Value.pp)
      (Array.to_list block)

  let pp (fmt : Fmt.t) ((heap, _) : t) : unit =
    let open Fmt in
    let pp_binding fmt (_, v) = fprintf fmt "%a" pp_block v in
    fprintf fmt "%a" (pp_hashtbl ~pp_sep:pp_newline pp_binding) heap

  let to_string (heap : t) : string = Fmt.asprintf "%a" pp heap

  let malloc (h : t) (sz : value) (pc : value Pc.t) :
    (t * value * value Pc.t) list =
    let tbl, next = h in
    match sz with
    | Integer i ->
      Hashtbl.replace tbl next (Array.make i (Integer 0));
      [ ((tbl, next + 1), Loc next, pc) ]
    | _ ->
      failwith "InternalError: HeapConcrete.malloc, size must be an integer"

  let update (h : t) (arr : value) (index : value) (v : value) (pc : value Pc.t)
    : (t * value Pc.t) list =
    let tbl, _ = h in
    match (arr, index) with
    | Loc l, Integer i -> (
      match Hashtbl.find_opt tbl l with
      | Some arr ->
        arr.(i) <- v;
        [ (h, pc) ]
      | _ -> failwith "InternalError: accessed array is not in the heap" )
    | _ ->
      failwith
        "InternalError: HeapConcrete.update, arr must be location and index \
         must be an integer"

  let lookup (h : t) (arr : value) (index : value) (pc : value Pc.t) :
    (t * value * value Pc.t) list =
    let tbl, _ = h in
    match (arr, index) with
    | Loc l, Integer i -> (
      match Hashtbl.find_opt tbl l with
      | Some arr ->
        if Array.length arr <= i then
          failwith "InternalError: accessing out-of-bounds index"
        else [ (h, arr.(i), pc) ]
      | _ -> failwith "InternalError: accessed array is not in the heap" )
    | _ ->
      failwith
        "InternalError: HeapConcrete.update, arr must be location and index \
         must be an integer"

  let free (h : t) (arr : value) (pc : value Pc.t) : (t * value Pc.t) list =
    let tbl, _ = h in
    match arr with
    | Loc l -> (
      match Hashtbl.find_opt tbl l with
      | Some _ ->
        Hashtbl.remove tbl l;
        [ (h, pc) ]
      | _ -> failwith "InternalError: illegal free" )
    | _ -> failwith "InternalError: HeapConcrete.update, arr must be location"

  let in_bounds (heap : t) (addr : value) (i : value) (_pc : value Pc.t) : bool
      =
    match addr with
    | Loc l -> (
      let tbl, _ = heap in
      match Hashtbl.find_opt tbl l with
      | Some arr -> Integer 0 < i && i < Integer (Array.length arr)
      | _ ->
        failwith
          "InternalError: HeapConcrete.in_bounds, accessed array is not in the \
           heap" )
    | _ ->
      failwith "InternalError: HeapConcrete.in_bounds, arr must be location"

  let get_block (_h : t) (_addr : value) : block option = assert false
  let set_block (_h : t) (_addr : value) (_block : block) : t = assert false
  let clone _ = assert false
end

module M' : Heap_intf.M with type value = Value.t = M
include M

(*
type t = (int, int arry) Hashtbl.t

x := new (5);
----
heap = { 1 -> { 0 -> 0, 1 -> 0, 2 -> 0, 3 -> 0, 4 -> 0} }
store = { x -> Loc 1 }
x[1] := 3;
----
heap = { 1 -> { 0 -> 0, 1 -> 3, 2 -> 0, 3 -> 0, 4 -> 0} }
store = { x -> Loc 1 }
---
y := x[0]
---
heap = { 1 -> { 0 -> 0, 1 -> 3, 2 -> 0, 3 -> 0, 4 -> 0} }
store = { x -> Loc 1, y -> Int 0 }
*)
