open Sstate

module Make (Eval : Eval_intf.M) (Heap : Heap_intf.M with type vt = Eval.t) :
  Choice_intf.Choice with type v = Eval.t and type h = Heap.t = struct
  type state = (Eval.t, Heap.t) Sstate.t
  type v = Eval.t
  type h = Heap.t
  type 'a t = state -> ('a * state) list

  let return x s = [ (x, s) ]

  let bind f k
    (* f : 'a t *)
    (* k : 'a -> 'b t *)
    (* 'b t *)
      s =
    let lst = f s in
    (* ('a * state) list *)
    let lst' = List.map (fun (a, s') -> (k a) s' (* ('b * state) list *)) lst in
    (* ('b * state) list list *)
    List.flatten lst'

  let get s = [ (s, s) ]
  let set s _ = [ ((), s) ]

  let select v (s : state) =
    let pc = s.pc in
    let not_v = Eval.negate v in
    let pc_v = Pc.add_condition pc v in
    let pc_not_v = Pc.add_condition pc not_v in
    match (Eval.is_true pc_v, Eval.is_true pc_not_v) with
    | false, false -> assert false
    | true, false -> [ (true, { s with pc = pc_v }) ]
    | false, true -> [ (false, { s with pc = pc_not_v }) ]
    | true, true ->
      [ (true, { (Sstate.dup s Heap.clone) with pc = pc_v })
      ; (false, { (Sstate.dup s Heap.clone) with pc = pc_not_v })
      ]

  let lift (f : state -> ('a * state) list) : 'a t = f
  let run (s : state) (f : 'a t) : ('a * state) list = f s
end
