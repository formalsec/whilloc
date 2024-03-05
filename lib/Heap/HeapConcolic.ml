module M = struct
  type t = (int, (Value.t * Term.t) array) Hashtbl.t
  type vt = Value.t * Term.t (* indexes and sizes are always values *)

  let init () : t = Hashtbl.create Parameters.size

  let to_string (h : t) : string =
    ignore h;
    failwith "Not Implemented"

  let malloc h (sz : vt) (pc : vt PC.t) : (t * vt * vt PC.t) list =
    ignore sz;
    ignore pc;
    ignore h;
    []

  let update h (arr : vt) (index : vt) (v : vt) (pc : vt PC.t) :
      (t * vt PC.t) list =
    ignore arr;
    ignore v;
    ignore index;
    ignore h;
    ignore pc;
    []

  let lookup h (arr : vt) (index : vt) (pc : vt PC.t) : (t * vt * vt PC.t) list
      =
    ignore index;
    ignore arr;
    ignore pc;
    ignore h;
    []

  let free h (arr : vt) (pc : vt PC.t) : (t * vt PC.t) list =
    ignore arr;
    ignore pc;
    ignore h;
    []

  let in_bounds (heap : t) (v : vt) (i : vt) (pc : vt PC.t) : bool =
    ignore pc;
    ignore heap;
    ignore v;
    ignore i;
    failwith "not implemented"

  let clone _ = assert false
end

module M' : Heap_intf.M with type vt = Value.t * Term.t = M

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
