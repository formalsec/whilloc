open Program
open Expression
open Outcome
open Search

let rec is_symbolic_expression (st : SStore.t) (e : expr) : bool =
  match e with
  | Val _     -> false
  | SymbVal _ -> true
  | Var x     -> SStore.get st x |> get_expr_from_opt |> is_symbolic_expression st 
  | UnOp  (_, e)    -> is_symbolic_expression st e
  | BinOp (_,e1,e2) -> is_symbolic_expression st e1 || is_symbolic_expression st e2

let rec simplify_symb_expr (st : SStore.t) (e : expr) : expr =
  match e with
  | Val _     -> e
  | SymbVal _ -> e
  | Var x     -> get_expr_from_opt ( SStore.get st x ) 
  | UnOp  (op, e)    -> UnOp (op, simplify_symb_expr st e)
  | BinOp (op,e1,e2) -> BinOp(op, simplify_symb_expr st e1, simplify_symb_expr st e2)

let eval_unop_expr (op : uop) (v : value) : Expression.expr =
  Val (
  match op with
  | Neg -> neg v
  | Not -> not_ v
  | Abs -> abs v
  | StringOfInt -> stoi v)

let eval_binop_expr (op : bop) (v1 : value) (v2 : value) : Expression.expr =
  Val (
  match op with
  | Plus    -> plus   (v1, v2)
  | Minus   -> minus  (v1, v2)
  | Times   -> times  (v1, v2)
  | Div     -> div    (v1, v2)
  | Modulo  -> modulo (v1, v2)
  | Pow     -> pow    (v1, v2)
  | Gt      -> gt     (v1, v2)
  | Lt      -> lt     (v1, v2)
  | Gte     -> gte    (v1, v2)
  | Lte     -> lte    (v1, v2)
  | Equals  -> equal  (v1, v2)
  | NEquals -> nequal (v1, v2)
  | Or      -> or_    (v1, v2)
  | And     -> and_   (v1, v2)
  | Xor     -> xor    (v1, v2)
  | ShiftL  -> shl    (v1, v2)
  | ShiftR  -> shr    (v1, v2))

let rec eval_expression (st : SStore.t) (e : Expression.expr) : Expression.expr = 

  (* We can't reduce the expression 'e' to a value if it contains symbolic variables, so we just replace each symbolic variable with its symbolic value *)
  if is_symbolic_expression st e then simplify_symb_expr st e
  
  (* If the expression does not contains symbolic variables, we can reduce it until it becomes a value *)
  else

  match e with
  
    | Var x ->
        let value = SStore.get st x in
        (match value with
        | None    -> failwith ("NameError: Symbolic, name " ^ x ^ " is not defined")
        | Some v  -> v) (*here, 'v' will always be an expr.Val *)

    | Val v -> Val v

    | UnOp  (op, e)      -> eval_expression st e |> get_value_from_expr |> eval_unop_expr op
    | BinOp (op, e1, e2) -> eval_binop_expr op (eval_expression st e1 |> get_value_from_expr) (eval_expression st e2 |> get_value_from_expr)

    | SymbVal x -> failwith ("InternalError: Symbolic, tried to reduce an expression consisting of a symbolic value \'" ^ x ^ "\'")


let step (prog : program) (state : SState.t) : Return.t list = 

  let s,cont,store,cs,pc = state in

  match s with

  | Skip | Clear ->
    (match cont with
    | []     -> [        state         , Cont  ]
    | h :: t -> [ (h, t, store, cs, pc), Cont  ])
  
  | Sequence (s1::s2) -> [ (s1, s2@cont, store, cs, pc), Cont ]

  | Assign (x,e) ->
      SStore.set store x (eval_expression store e);
      [ (Skip, cont, store, cs, pc), Cont ]
  
  | Symbol s ->
      let symb_val = make_symb_value s in
      SStore.set store s symb_val;
      [ (Skip, cont, store, cs, pc), Cont ]

  | Print exprs ->
      let eval_exprs = List.map (eval_expression store) exprs in
      let ()         = print_endline ">Program Print" in
      let ()         = List.iter print_expression eval_exprs; print_endline "" in
      [ (Skip, cont, store, cs, pc), Cont ]
  
  | FunCall (var,id,args) ->
      let eval_args   = List.map (fun e -> eval_expression store e) args in
      let function'   = Program.get_function id prog in
      let params      = function'.args in
      let var_vals    = try List.combine params eval_args
                        with _ -> failwith ("TypeError: Symbolic, argument arity mismatch when calling " ^ id) in
      let func_frame  = SStore.create_store var_vals in
      let cs'         = (SCallstack.Intermediate (store, cont, var) ) :: cs in
      [ (function'.body, [], func_frame, cs', pc), Cont ]

  | Return e ->
      let v     = eval_expression store e in
      let frame = SCallstack.top cs in
      let cs'   = SCallstack.pop cs in
        (match frame with
        | SCallstack.Intermediate (store',rest,var) ->  SStore.set store' var v;
                                                        [ (Skip, rest, store', cs', pc), Cont ]
        | SCallstack.Toplevel  -> [ (Skip, cont, store, cs', pc), Return v ])

  | IfElse (e, s1, s2) ->
      let e = eval_expression store e in
      (*
      let b1 = isSat ( Z3.query(pc ∧ e) ) in
      let b2 = isSat ( Z3.query(pc ∧ ê) ) in
      let store' = SStore.copy store      in
      let t1 = ( s1,cont,store',cs',(pc ∧ e) ), Cont in
      let t2 = ( s2,cont,store',cs',(pc ∧ ê) ), Cont in
      if b1 && b2 then
        [ t1; t2 ] 
      else
        if b1 then
          [ t1 ] 
        else
          if b2 then
            [ t2 ] 
          else
            ( Skip,cont,store,cs,pc ), Cont
      *)
      if is_true (get_value_from_expr e) then
        [ (s1, cont, store, cs, pc), Cont ]
      else
        [ (s2, cont, store, cs, pc), Cont ]

  | While (e,body) as while_stmt ->
      (*
      let b = isSat ( Z3.query(pc ∧ e) ) in
      if b then
        [ ( body,while_stmt@cont,store,cs,(pc ∧ e) ), Cont ]
      else
        [ ( Skip,cont,store,cs,pc ), Cont ]
      *)
      let unfold_loop = IfElse (e, Sequence ( (sequence_content body)@[while_stmt] ), Skip) in
      [ (unfold_loop, cont, store, cs, pc), Cont ]

  (* (pc ∧ e) SAT   means that there exists a concretization of symbolic values that makes the expression evaluate to true  *)
  (* (pc ∧ ê) SAT   means that there exists a concretization of symbolic values that makes the expression evaluate to false *)
  (* (pc ∧ e) UNSAT means that for any possible concretization of symbolic values the expression always evaluates to false *)
  (* (pc ∧ ê) UNSAT means that for any possible concretization of symbolic values the expression always evaluates to true  *)

  (*
    Semantic of assert(e) is as follows: assert(e) means that we are asserting something that is true for all possible concretizations of symbolic values, thus, if the
    formula (pc ∧ ê) is satisfiable (i.e., there is at least one assignment that evaluates ê to false), assert(e) evaluates to 'Error', otherwise it evaluates to 'Continue'
    #(pc ∧ ê) SAT?
    Yes: Error
    No : Continue
    IDK: ?
  *)
  | Assert e -> 
      let v = get_value_from_expr (eval_expression store e) in (*FIXME temporary line of code*)
      if is_true v then [ (Skip, cont, store, cs, pc), Cont  ]
      else              [ (Skip, cont, store, cs, pc), Error ]

  (*
    Semantic of assume(e): assume(e) means that we are assuming that at least one concretization of symbolic values makes the expression 'e' evaluate to true, thus,
    if the formula (pc ∧ e) is unsatisfiable (i.e., there is no model for the expression 'e'), assume(e) evaluates to 'AssumeF', otherwise it evaluates to 'Continue'
    #(pc ∧ e) UNSAT?
    Yes: AssumeF
    No : Continue
    IDK: ?
  *)
  | Assume e ->
      let v = get_value_from_expr (eval_expression store e) in (*FIXME temporary line of code*)
      if is_true v then [ (Skip, cont, store, cs, pc), Cont  ]
      else              [ (Skip, cont, store, cs, pc), AssumeF ]

  | Sequence [] -> failwith "InternalError: Symbolic, tried to evaluate an empty Sequence"

let rec search (gas : int) (prog : program) (states : SState.t list) (rets : Return.t list) : Return.t list = 

  if gas=0 || states=[] then rets else

  let state, states' = pick states in
  let branches       = step prog state in

  let branches_final, branches_cont = List.partition is_final branches in

  let next_states_cont,_  = List.split branches_cont in

  search (gas-1) prog (join next_states_cont states') ( branches_final @ rets )


let interpret (prog : program) (main_id : string) : Return.t list = 
  let main  = get_function main_id prog in
  let tank  = Configs.tank in 
  let pathc = [Val (Boolean true)] in
  let state = (Skip, [main.body], SStore.create_empty_store 100, [SCallstack.Toplevel], pathc) in
  let r  = search tank prog [state] [] in
  r