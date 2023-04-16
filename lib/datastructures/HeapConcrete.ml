module M : Heap.M with type vt = Value.t = struct
  
  type   t = (int, Value.t array) Hashtbl.t
  type  vt = Value.t (* indexes and sizes are always values *)

  let init () : t = Hashtbl.create Parameters.size

  let malloc (h : t) (sz : vt) (pc : t PathCondition.t) : (t * vt * t PathCondition.t) list =
    ignore pc;
    ignore h;
    match sz with
    | Integer _ ->
        
      []
    | _ -> failwith ("InternalError: HeapConcrete.malloc, size must be an integer")
  
  let update (h : t) (arr : string) (index : vt) (v : vt) (pc : t PathCondition.t)  : (t * t PathCondition.t) list =
    ignore arr;
    ignore v;
    ignore index;
    ignore h;
    ignore pc;
    []

  let lookup (h : t) (arr : string) (index : vt) (pc : t PathCondition.t) : (t * vt * t PathCondition.t) list =
    ignore index;
    ignore arr;
    ignore pc;
    ignore h;
    []

  let free (h : t) (arr : string) (pc : t PathCondition.t) : (t * t PathCondition.t) list =
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