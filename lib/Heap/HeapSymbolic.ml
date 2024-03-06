module M : Heap_intf.M with type vt = Term.t = struct
  type t = (int, Term.t array) Hashtbl.t
  type vt = Term.t

  let init () : t = Hashtbl.create Parameters.size

  let pp (fmt : Fmt.t) (heap : t) : unit =
    ignore fmt;
    ignore heap;
    failwith "Not Implemented"

  let to_string (h : t) : string =
    ignore h;
    failwith "Not Implemented"

  let malloc _h (_sz : vt) (_pc : vt PC.t) : (t * vt * vt PC.t) list =
    assert false

  let update _h (_arr : vt) (_index : vt) (_v : vt) (_pc : vt PC.t) :
      (t * vt PC.t) list =
    assert false

  let lookup _h (_arr : vt) (_index : vt) (_pc : vt PC.t) :
      (t * vt * vt PC.t) list =
    assert false

  let free _h (_arr : vt) (_pc : vt PC.t) : (t * vt PC.t) list = assert false

  let in_bounds (_heap : t) (_v : vt) (_i : vt) (_pc : vt PC.t) : bool =
    assert false

  let clone _ = assert false
end

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
