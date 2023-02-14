module M (Eval : Eval.M) (Search : Search.M) : Interpreter.M with type t = Eval.t = struct

  open Program
  open Outcome

  type t = Eval.t

  (* Evaluates an expressions *)
  let eval    = Eval.eval

  (* Asserts wheter a given expression is true or not *)
  let is_true = Eval.is_true

  (* Negates an expression *)
  let negate  = Eval.negate

  (* Creates a fresh symbol *)
  let make_symbol = Eval.make_symbol

  (* Adds an expression to a path condition *)
  let add_condition = PathCondition.add_condition

  (* Selects which state to expand given a set of candidate states *)
  let pick = Search.pick

  (* Merges the set of candidate states with the new set of states returned by the 'step' function *)
  let join = Search.join

  (* Integer constant that bounds the number of steps performed by the interpreter *)
  let tank = Parameters.tank

  (* Helper functions, common to both concrete and symbolic contexts *)
  let create_initial_state program =
    let main  = Program.get_function Parameters.main_id program in
    let store = Store.create_empty_store Parameters.size in
    let cs    = Callstack.create_callstack in
    let pathc = PathCondition.create_pathcondition in
    (Skip, [main.body], store, cs, pathc)
  
  let is_final result =
    let state,out = result in
    let (stmt',cont',_,_,_) = state in
    if stmt'=Skip && cont'=[] && out=Cont then failwith "BadProgram: functions should always return a value"
    else
    match out with
    | Cont     -> false
    | AssumeF  -> true
    | Error    -> true
    | Return _ -> true
  
  (* -------------------------------------------------------------------------------- *)
  (* The interpreter itself. It consists of a 'step' function and a 'search' function *)
  (* -------------------------------------------------------------------------------- *)

  (* The 'step' function is a small-step semantics evaluator and uses the "continuations" trick, and thus it is tail recursive. Note: the evaluation of expressions is big-step *)
  let step (prog : program) (state : t State.t) : t Return.t list = 
  
    let s,cont,store,cs,pc = state in
  
    match s with
  
    | Skip | Clear ->
      (match cont with
      | [ ]                     -> [ state, Cont  ]
      | next_statement :: cont' -> [ (next_statement, cont', store, cs, pc), Cont  ])
    
    | Sequence (s1::s2) -> [ (s1, s2@cont, store, cs, pc), Cont ]
  
    | Assign (x,e) ->
        let e' = eval store e in
        Store.set store x e';
        [ (Skip, cont, store, cs, pc), Cont ]
    
    | Symbol (x,s) ->
        let symb_opt = make_symbol s in
        (match symb_opt with
        | None          -> failwith "ApplicationError: tried to create a symbolic value in a concrete execution context"
        | Some symb_val -> Store.set store x symb_val;
                           [ (Skip, cont, store, cs, pc), Cont ])
  
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

        then_branch @ else_branch
  
    | While (e,body) as while_stmt ->
        let e'  = eval store e  in
        let e'' = negate e' in

        let true_pc  = add_condition pc e'  in
        let false_pc = add_condition pc e'' in

        let guard_true  = is_true true_pc in
        let guard_false = is_true false_pc in
  
        let store' = if guard_true && guard_false then (Store.dup store) else store in
  
        let body_branch = if guard_true  then [ ( body, while_stmt::cont, store , cs, true_pc  ), Cont ] else [ ] in
        let skip_branch = if guard_false then [ ( Skip,             cont, store', cs, false_pc ), Cont ] else [ ] in
  
        body_branch @ skip_branch
  
    | Assert e ->
        let e       = eval store e in
        let pc'     = add_condition pc e in
        let test_pc = add_condition pc (negate e) in
        let is_true = is_true test_pc in
        if is_true then [ (Skip, cont, store, cs, pc ), Error ]
        else            [ (Skip, cont, store, cs, pc'), Cont  ]
  
    | Assume e ->
        let e       = eval store e in
        let pc'     = add_condition pc e in
        let is_true = is_true pc' in
        if is_true then [ (Skip, cont, store, cs, pc'), Cont    ] 
        else            [ (Skip, cont, store, cs, pc ), AssumeF ]
  
    | Sequence [ ] -> failwith "InternalError: Interpreter, reached the empty program"
  

  (* The 'search' function contains all the logic of the search of the state space, it kinda is like a scheduler of states *)
  let rec search (gas : int) (prog : program) (states : t State.t list) (returns : t Return.t list) : t Return.t list = 
  
    if gas=0 || states=[] then returns else
  
    let state, states' = pick states in  
    let branches       = step prog state in

    let branches_final, branches_cont = List.partition is_final branches in
    let states_cont   , _             = List.split branches_cont in
  
    search (gas-1) prog (join states_cont states') (returns @ branches_final)
  
  let interpret (prog : program) : t Return.t list = 
    search tank prog [create_initial_state prog] [ ]

end
