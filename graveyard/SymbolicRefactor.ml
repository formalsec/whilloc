open Program
open Expression
open Outcome
open Search
open Encoding

let is_symbolic_value (v : value) : bool =
  match v with
  | SymbVal _ -> true
  | _         -> false

let rec is_symbolic_expression (st : SStore.t) (e : expr) : bool =
  match e with
  | Val v     -> is_symbolic_value v
  | Var x     -> SStore.get st x |> is_symbolic_expression st 
  | UnOp  (_, e)    -> is_symbolic_expression st e
  | BinOp (_,e1,e2) -> is_symbolic_expression st e1 || is_symbolic_expression st e2

let rec simplify_symb_expr (st : SStore.t) (e : expr) : expr =
  match e with
  | Val _     -> e
  | Var x     -> SStore.get st x
  | UnOp  (op, e)    -> UnOp (op, simplify_symb_expr st e)
  | BinOp (op,e1,e2) -> BinOp(op, simplify_symb_expr st e1, simplify_symb_expr st e2)

let eval_unop_expr (op : uop) (v : value) : Expression.expr =
  Val (
  match op with
  | Neg -> neg v
  | Not -> not_ v
  | Abs -> abs v
  | StringOfInt -> stoi v)

let eval_binop_expr (op : bop) (v1 : value) (v2 : value) : expr =
  let f =
  match op with
  | Plus    -> plus  
  | Minus   -> minus 
  | Times   -> times 
  | Div     -> div   
  | Modulo  -> modulo
  | Pow     -> pow   
  | Gt      -> gt    
  | Lt      -> lt    
  | Gte     -> gte   
  | Lte     -> lte   
  | Equals  -> equal 
  | NEquals -> nequal
  | Or      -> or_   
  | And     -> and_  
  | Xor     -> xor   
  | ShiftL  -> shl   
  | ShiftR  -> shr
  in Val ( f (v1, v2) )

let rec eval_expression (st : SStore.t) (e : Expression.expr) : Expression.expr = 

  (* We can't reduce the expression 'e' to a value if it contains symbolic variables, so we just replace each symbolic variable with its symbolic value *)
  if is_symbolic_expression st e then simplify_symb_expr st e
  
  (* If the expression does not contains symbolic variables, we can reduce it until it becomes a value *)
  else

  match e with
    | Val v -> Val v  
    | Var x -> SStore.get st x
    | UnOp  (op, e)      -> eval_expression st e |> get_value_from_expr |> eval_unop_expr op
    | BinOp (op, e1, e2) -> eval_binop_expr op (eval_expression st e1 |> get_value_from_expr) (eval_expression st e2 |> get_value_from_expr)

let step (prog : program) (state : SState.t) : Return.t list = 

  (* let s,cont,store,cs,pc = state in *)

  let cont = State.get_cont state in 

  match s with

  | Skip | Clear ->
    (match cont with
    | []                      -> [ state, Cont  ]
    | next_statement :: cont' -> [ (next_statement, cont', store, cs, pc), Cont  ])
  
  | Sequence (s1::s2) -> [ (s1, s2@cont, store, cs, pc), Cont ]

  | Assign (x,e) ->
      State.set state x (State.eval_expression state e);
      [ (Skip, cont, store, cs, pc), Cont ]
  
  | Symbol (x,s) ->
      let symb_val = make_symb_value s in
      State.set store x symb_val;
      [ (Skip, cont, store, cs, pc), Cont ]

  | Print exprs ->
      let eval_exprs = List.map (State.eval_expression store) exprs in
      let ()         = print_endline ">Program Print" in
      let ()         = List.iter print_expression eval_exprs; print_endline "" in
      [ (Skip, cont, store, cs, pc), Cont ]
  
  | FunCall (var,id,args) ->
      let eval_args   = List.map (fun e -> eval_expression store e) args in
      let function'   = Program.get_function id prog in
      let params      = function'.args in
      let var_vals    = try List.combine params eval_args
                        with _ -> failwith ("TypeError: Symbolic, argument arity mismatch when calling " ^ id) in
      let func_init   = SStore.create_store var_vals in
      let frame       = SCallstack.Intermediate (store, cont, var) in
      let cs'         = SCallstack.push frame cs in
      [ (function'.body, [], func_init, cs', pc), Cont ]

  | Return e ->
      let v     = eval_expression store e in
      let frame = SCallstack.top cs in
      let cs'   = SCallstack.pop cs in
        (match frame with
        | SCallstack.Intermediate (store',rest,var) ->  SStore.set store' var v;
                                                        [ (Skip, rest, store', cs', pc), Cont ]
        | SCallstack.Toplevel  -> [ (Skip, cont, store, cs', pc), Return v ])

  | IfElse (e, s1, s2) when is_symbolic_expression store e->
      let e'  = simplify_symb_expr store e in
      let e'' = negate_expression e'       in

      let then_guard = is_sat (e' ::pc) in
      let else_guard = is_sat (e''::pc) in
      
      let store' = if then_guard && else_guard then Hashtbl.copy store else store in

      let then_branch = if then_guard then [ (s1, cont, store , cs, e' ::pc ), Cont ] else [] in
      let else_branch = if else_guard then [ (s2, cont, store', cs, e''::pc ), Cont ] else [] in

      then_branch @ else_branch

  | IfElse (e, s1, s2) ->
      if ( eval_expression store e |> get_value_from_expr |> is_true ) then
        [ (s1, cont, store, cs, pc), Cont ]
      else
        [ (s2, cont, store, cs, pc), Cont ]

  | While (e,body) as while_stmt when is_symbolic_expression store e ->
      let e'  = simplify_symb_expr store e in
      let e'' = negate_expression e'       in

      let guard_t = is_sat (e' ::pc ) in
      let guard_f = is_sat (e''::pc ) in

      let store' = if guard_t && guard_f then Hashtbl.copy store else store in

      let body_branch = if guard_t then [ ( body, while_stmt::cont, store , cs, e' ::pc ), Cont ] else [] in
      let skip_branch = if guard_f then [ ( Skip, cont            , store', cs, e''::pc ), Cont ] else [] in

      body_branch @ skip_branch

  | While (e,body) as while_stmt ->
      let guard = eval_expression store e |> get_value_from_expr |> is_true in
      if guard then
        [ (body, while_stmt::cont, store, cs, pc), Cont ]
      else
        [ (Skip, cont, store, cs, pc), Cont ]

  (*
    Semantics of assert(e) is as follows: assert(e) means that we are asserting something that is true for all possible concretizations of symbolic values, thus, if the
    formula (pc ∧ ê) is satisfiable (i.e., there is at least one assignment that evaluates ê to false), assert(e) evaluates to 'Error', otherwise it evaluates to 'Continue'
    #(pc ∧ ê) SAT?
    Yes: Error
    No : Continue
  *)
  | Assert e when is_symbolic_expression store e ->
      let e'     = negate_expression ( simplify_symb_expr store e ) in
      let is_sat = is_sat (e'::pc) in
      if is_sat then [ (Skip, cont, store, cs,     pc), Error ]
      else           [ (Skip, cont, store, cs, e'::pc), Cont  ]

  | Assert e -> 
      let v = get_value_from_expr (eval_expression store e) in
      if is_true v then [ (Skip, cont, store, cs, pc), Cont  ]
      else              [ (Skip, cont, store, cs, pc), Error ]

  (*
    Semantics of assume(e): assume(e) means that we are assuming that at least one concretization of symbolic values makes the expression 'e' evaluate to true, thus,
    if the formula (pc ∧ e) is unsatisfiable (i.e., there is no model for the expression 'e'), assume(e) evaluates to 'AssumeF', otherwise it evaluates to 'Continue'
    #(pc ∧ e) SAT?
    Yes: Continue
    No : AssumeF
  *)
  | Assume e when is_symbolic_expression store e ->
    let e'     = simplify_symb_expr store e in
    print_endline (string_of_expression e');
    let is_sat = is_sat (e'::pc) in
    if is_sat then [ (Skip, cont, store, cs, e'::pc), Cont    ]
    else           [ (Skip, cont, store, cs,     pc), AssumeF ]

  | Assume e ->
      let v = get_value_from_expr (eval_expression store e) in
      if is_true v then [ (Skip, cont, store, cs, pc), Cont    ]
      else              [ (Skip, cont, store, cs, pc), AssumeF ]

  | Sequence [] -> failwith "InternalError: Symbolic, tried to evaluate an empty Sequence"

let rec search (gas : int) (prog : program) (states : SState.t list) (rets : Return.t list) : Return.t list = 

  if gas=0 || states=[] then rets else

  let state, states' = pick_head states in
  let branches       = step prog  state in

  (*print_endline (SState.string_of_sstate state);*)

  let branches_final, branches_cont = List.partition is_final branches in

  let next_states_cont,_  = List.split branches_cont in

  search (gas-1) prog (join_push next_states_cont states') ( branches_final @ rets )


let interpret (prog : program) (main_id : string) : Return.t list = 
  let main  = get_function main_id prog in
  let tank  = Parameters.tank in 
  let pathc = [Val (Boolean true)] in
  let state = (Skip, [main.body], SStore.create_empty_store 100, [SCallstack.Toplevel], pathc) in
  let r  = search tank prog [state] [] in
  r