module M : Heap.M with type vt = Expression.t = struct
  
  type   t = (int, Expression.t array) Hashtbl.t
  type  vt = Expression.t

  let init () : t = Hashtbl.create Parameters.size

  let malloc h (sz : vt) (pc : t PathCondition.t) : (t * vt * t PathCondition.t) list =
    ignore sz;
    ignore pc;
    ignore h;
    []
  
  let update h (arr : string) (index : vt) (v : vt) (pc : t PathCondition.t)  : (t * t PathCondition.t) list =
    ignore arr;  
    ignore v;
    ignore index;
    ignore pc;
    ignore h;
    []

  let lookup h (arr : string) (index : vt) (pc : t PathCondition.t) : (t * vt * t PathCondition.t) list =
    ignore index;
    ignore arr;
    ignore h;
    ignore pc;
    []

  let free h (arr : string) (pc : t PathCondition.t) : (t * t PathCondition.t) list =
    ignore arr;
    ignore pc;
    ignore h;
    []

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