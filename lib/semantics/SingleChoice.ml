open SState

module Make
  (Eval : Eval_intf.M)
  (Heap : Heap_intf.M with type vt = Eval.t)
    : Choice_intf.Choice with type v = Eval.t and type h = Heap.t = struct

  type state = (Eval.t,Heap.t) SState.t

  type v = Eval.t

  type h = Heap.t

  type 'a t = state -> ('a * state) 

  let return x = fun s -> (x, s) 

  let bind f k =
    (* f : 'a t *)
    (* k : 'a -> 'b t *)
    (* 'b t *)
    fun s ->
      let (a, s') = f s in (* ('a * state) *)
      (k a) s'

  let get =
    fun s -> (s,s) 

  let set s =
    fun _ -> ((), s) 

  let select v =
    fun (s : state) ->
      let pc = s.pc in
      let not_v = Eval.negate v in
      let pc_v = PathCondition.add_condition pc v in
      let pc_not_v = PathCondition.add_condition pc not_v in
      match (Eval.is_true pc_v), (Eval.is_true pc_not_v) with
      | false, false -> assert false
      | true, false -> (true, { s with pc = pc_v }) 
      | false, true -> (false, { s with pc = pc_not_v}) 
      | true, true -> assert false 

  let assertion (v : v) : bool t = 
    fun (s : state) ->
      let pc = s.pc in 
      let not_v = Eval.negate v in 
      let pc_not_v = PathCondition.add_condition pc not_v in
      if (Eval.may_be_true pc_not_v) 
        then (false, { s with pc = pc_not_v}) 
        else (true, s) 

  let lift (f : state -> ('a * state) list) : 'a t = 
    fun s -> 
      let rs = f s in 
      (match rs with 
      | [] -> assert false 
      |r :: _ -> r) 

  let run (s : state) (f : 'a t) : ('a * state) list = [ f s ]


end
