module M : Heap_intf.M with type vt = Encoding.Expr.t = struct
  type vt = Encoding.Expr.t
  type t = (int, vt array) Hashtbl.t

  module Eval = Eval_symbolic.M

  let init () : t = Hashtbl.create Parameters.size
  let pp (_fmt : Fmt.t) (_heap : t) : unit = failwith "Not Implemented"
  let to_string (_h : t) : string = failwith "Not Implemented"

  let malloc _h (_sz : vt) (_pc : vt Pc.t) : (t * vt * vt Pc.t) list =
    assert false

  let update _h (_arr : vt) (_index : vt) (_v : vt) (_pc : vt Pc.t) :
    (t * vt Pc.t) list =
    assert false

  let lookup _h (_arr : vt) (_index : vt) (_pc : vt Pc.t) :
    (t * vt * vt Pc.t) list =
    assert false

  let free _h (_arr : vt) (_pc : vt Pc.t) : (t * vt Pc.t) list = assert false

  let in_bounds (_heap : t) (_v : vt) (_i : vt) (_pc : vt Pc.t) : bool =
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
