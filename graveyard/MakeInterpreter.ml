module M (EvalExpression : Eval.M) : Interpreter.M = struct
  
  open Program
  open Expression
  open Value
  open Outcome
  open Search
  open Encoding
  open BinaryTree
  open EvalExpression
  
  type        t = EvalExpression.t
  type return_t = t Return.t
  type state_t  = t State.t
  type store_t  = t Store.t
  type cs_t     = t Callstack.t

  let eval = EvalExpression.eval

  let step (prog : program) (state : state_t) : return_t list = 
  
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
        let symb_val = make_symb_value s in
        Store.set store x symb_val;
        [ (Skip, cont, store, cs, pc), Cont ]
  
    | Print exprs ->
        let eval_exprs = List.map (eval store) exprs in
        let ()         = print_endline ">Program Print" in
        let ()         = List.iter print_expression eval_exprs; print_endline "" in
        [ (Skip, cont, store, cs, pc), Cont ]
    
    | FunCall (var,id,args) ->
        let eval_args   = List.map (fun e -> eval store e) args in
        let function'   = Program.get_function id prog in
        let params      = function'.args in
        let var_vals    = try List.combine params eval_args
                          with _ -> failwith ("TypeError: Symbolic, argument arity mismatch when calling " ^ id) in
        let func_init   = Store.create_store var_vals in
        let frame       = Callstack.Intermediate (store, cont, var) in
        let cs'         = Callstack.push frame cs in
        [ (function'.body, [], func_init, cs', pc), Cont ]
  
    | Return e ->
        let v     = eval_expression_symb store e in
        let frame = SCallstack.top cs in
        let cs'   = SCallstack.pop cs in
          (match frame with                               (* Hashtbl.copy is necessary when the body of the invoked function branches and returns different values *)
          | SCallstack.Intermediate (store',rest,var) ->  let store'' = Hashtbl.copy store' in
                                                          SStore.set store'' var v;
                                                          [ (Skip, rest, store'', cs', pc), Cont ]
          | SCallstack.Toplevel  -> [ (Skip, cont, store, cs', pc), Return v ])
  
    | IfElse (e, s1, s2) ->
        let e'  = simplify_symb_expr store e in
        let e'' = negate_expression e'       in
  
        let then_guard = is_sat (e' ::pc) in
        let else_guard = is_sat (e''::pc) in
        
        let store' = if then_guard && else_guard then Hashtbl.copy store else store in
  
        let then_branch = if then_guard then [ (s1, cont, store , cs, e' ::pc ), Cont ] else [ ] in
        let else_branch = if else_guard then [ (s2, cont, store', cs, e''::pc ), Cont ] else [ ] in
  
        (* if concrete_context then assert (then_guard XOR else_guard) *)
  
        then_branch @ else_branch
  
    | While (e,body) as while_stmt ->
        let e'  = simplify_symb_expr store e in
        let e'' = negate_expression e'       in
  
        let guard_t = is_sat (e' ::pc ) in
        let guard_f = is_sat (e''::pc ) in
  
        let store' = if guard_t && guard_f then (Hashtbl.copy store) else store in
  
        let body_branch = if guard_t then [ ( body, while_stmt::cont, store , cs, e' ::pc ), Cont ] else [ ] in
        let skip_branch = if guard_f then [ ( Skip, cont            , store', cs, e''::pc ), Cont ] else [ ] in
  
        (* if in_concrete_context then assert (guard_t XOR guard_f) *)
  
        body_branch @ skip_branch
  
    (*
      Semantics of assert(e) is as follows: assert(e) means that we are asserting something that is true for all possible concretizations of symbolic values, thus, if the
      formula (pc ∧ ê) is satisfiable (i.e., there is at least one assignment that evaluates ê to false), assert(e) evaluates to 'Error', otherwise it evaluates to 'Continue'
      #(pc ∧ ê) SAT?
      Yes: Error
      No : Continue
    *)
    | Assert e ->
        let e'     = negate_expression ( simplify_symb_expr store e ) in
        let is_sat = is_sat (e'::pc) in
        if is_sat then [ (Skip, cont, store, cs,     pc), Error ]
        else           [ (Skip, cont, store, cs, e'::pc), Cont  ]
  
    (*
      Semantics of assume(e): assume(e) means that we are assuming that at least one concretization of symbolic values makes the expression 'e' evaluate to true, thus,
      if the formula (pc ∧ e) is unsatisfiable (i.e., there is no model for the expression 'e'), assume(e) evaluates to 'AssumeF', otherwise it evaluates to 'Continue'
      #(pc ∧ e) SAT?
      Yes: Continue
      No : AssumeF
    *)
    | Assume e ->
        let e'     = simplify_symb_expr store e in
        let is_sat = is_sat (e'::pc) in
        if is_sat then [ (Skip, cont, store, cs, e'::pc), Cont    ]
        else           [ (Skip, cont, store, cs,     pc), AssumeF ]
  
    | Sequence [] -> failwith "InternalError: Symbolic, tried to evaluate an empty Sequence"
  

  let rec search (gas : int) (prog : program) (states : state_t list) (returns : return_t list) (tree : Program.stmt BinaryTree.t) : return_t list * Program.stmt BinaryTree.t = 
  
    if gas=0 || states=[] then returns,tree else
  
    let state, states' = pick_head states in
  
    print_endline ">Cur Stmt:";
    let a = SState.get_current_stmt state in
    Program.print_statement a;
    print_endline "";
  
    let branches       = step prog  state in
  
    let tree' = add_left tree (SState.get_current_stmt state) in
  
    let branches_final, branches_cont = List.partition is_final branches in
    let states_cont   , _             = List.split branches_cont in
  
    search (gas-1) prog (join_enqueue states_cont states') (returns @ branches_final) tree'
  
  
  let interpret (prog : program) (main_id : string) : return_t list = 
    let main  = get_function main_id prog in
    let tank  = Parameters.tank in
    
    let store = Store.create_empty_store Parameters.size in
    let cs    = [Callstack.Toplevel] in
    let pathc = [Val (Boolean true)] in
    let state = (Skip, [main.body], store, cs, pathc) in
    (*this should all be replaced by: let state = create_initial_state *)
    
    let r,_ = search tank prog [state] [] Nil in
    (*print_tree Program.string_of_stmt t;
    print_endline (to_graphviz Program.string_of_stmt t);*)
    r

end

(*
module I = MakeInterpreter.M (EvalSymbolic)
module I = MakeInterpreter (EvalConcrete)
I.interpreter (...)

module I = MakeInterpreter.M (EvalSymbolic) (DFS)

*)