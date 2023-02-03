module M (Eval : Eval.M) (Search : Search.M) : (Interpreter.M with type t = Eval.t) = struct
  
  open Program
  open Outcome
  open Common
  
  type t = Eval.t

  (* Evaluation *)
  let eval    = Eval.eval
  let is_true = Eval.is_true
  let negate  = Eval.negate
  let add_condition = Eval.add_condition (* let add_cond = PathCondition.add_cond *)
  let make_symbol = Eval.make_symbol

  (* Search criteria *)
  let pick = Search.pick
  let join = Search.join
  let tank = Parameters.tank

  let step (prog : program) (state : t State.t) : t Return.t list = 
  
    let s,cont,store,cs,pc = state in
  
    match s with
  
    | Skip | Clear ->
      (match cont with
      | []                      -> [ state, Cont  ]
      | next_statement :: cont' -> [ (next_statement, cont', store, cs, pc), Cont  ])
    
    | Sequence (s1::s2) -> [ (s1, s2@cont, store, cs, pc), Cont ]
  
    | Assign (x,e) ->
        Store.set store x (eval store e);
        [ (Skip, cont, store, cs, pc), Cont ]
    
    | Symbol (x,s) ->
        let symb_val = make_symbol s in
        Store.set store x symb_val;
        [ (Skip, cont, store, cs, pc), Cont ]
  
    | Print exprs ->
        let exprs = List.map (eval store) exprs in
        let ()    = print_endline ">Program Print" in
        let ()    = List.iter Eval.print exprs; print_endline "" in
        [ (Skip, cont, store, cs, pc), Cont ]
    
    | FunCall (var,id,args) ->
        let eval_args   = List.map (fun e -> eval store e) args in
        let function'   = Program.get_function id prog in
        let params      = function'.args in
        let var_vals    = try List.combine params eval_args
                          with _ -> failwith ("TypeError: Argument arity mismatch when calling " ^ id) in
        let func_init   = Store.create_store var_vals in
        let frame       = Callstack.Intermediate (store, cont, var) in
        let cs'         = Callstack.push cs frame in
        [ (function'.body, [], func_init, cs', pc), Cont ]

    | Return e ->
        let v     = eval store e in
        let frame = Callstack.top cs in
        let cs'   = Callstack.pop cs in
          (match frame with
          | Callstack.Intermediate (store',rest,var) ->  let store'' = Store.dup store' in
                                                         Store.set store'' var v;
                                                         [ (Skip, rest, store'', cs', pc), Cont ]
          | Callstack.Toplevel  -> [ (Skip, cont, store, cs', pc), Return (Eval.to_string v) ])
  
    | IfElse (e, s1, s2) ->
        let e'  = eval store e   in
        let e'' = negate e' in
  
        let then_pc = add_condition pc e'  in
        let else_pc = add_condition pc e'' in

        let then_guard = is_true then_pc in
        let else_guard = is_true else_pc in
        
        let store' = if then_guard && else_guard then (Store.dup store) else store in
  
        let then_branch = if then_guard then [ (s1, cont, store , cs, then_pc), Cont ] else [ ] in
        let else_branch = if else_guard then [ (s2, cont, store', cs, else_pc), Cont ] else [ ] in
  
        (* if concrete_context then assert (then_guard XOR else_guard) *)
  
        then_branch @ else_branch
  
    | While (e,body) as while_stmt ->
        let e'  = eval store e  in
        let e'' = negate e' in

        let t_pc = add_condition pc e'  in
        let f_pc = add_condition pc e'' in

        let guard_t = is_true t_pc in
        let guard_f = is_true f_pc in
  
        let store' = if guard_t && guard_f then (Store.dup store) else store in
  
        let body_branch = if guard_t then [ ( body, while_stmt::cont, store , cs, t_pc ), Cont ] else [ ] in
        let skip_branch = if guard_f then [ ( Skip, cont            , store', cs, f_pc ), Cont ] else [ ] in
  
        (* if in_concrete_context then assert (guard_t XOR guard_f) *)
  
        body_branch @ skip_branch
  
    | Assert e ->
        let e'      = e |> eval store |> negate in
        let pc'     = add_condition pc e' in
        let is_true = is_true pc' in
        if is_true then [ (Skip, cont, store, cs, pc ), Error ]
        else            [ (Skip, cont, store, cs, pc'), Cont  ]
  
    | Assume e ->
        let e'      = eval store e in
        let pc'     = add_condition pc e' in
        let is_true = is_true pc' in
        if is_true then [ (Skip, cont, store, cs, pc'), Cont    ] 
        else            [ (Skip, cont, store, cs, pc ), AssumeF ]
  
    | Sequence [] -> failwith "InternalError: Interpreter, reached the empty program"
  

  let rec search (gas : int) (prog : program) (states : t State.t list) (returns : t Return.t list) : t Return.t list = 
  
    if gas=0 || states=[] then returns else
  
    let state, states' = pick states in  
    let branches       = step prog state in

    let branches_final, branches_cont = List.partition is_final branches in
    let states_cont   , _             = List.split branches_cont in
  
    search (gas-1) prog (join states_cont states') (returns @ branches_final)
  
  let interpret (prog : program) : t Return.t list = 
    search tank prog [create_initial_state prog] []

end
