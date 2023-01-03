open Program
open Expression
open Outcome

let eval_unop_expr (op : uop) (v : value) : value =
  match op with
  | Neg -> neg v
  | Not -> not_ v
  | Abs -> abs v
  | StringOfInt -> stoi v

let eval_binop_expr (op : bop) (v1 : value) (v2 : value) : value =
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
  | ShiftR  -> shr    (v1, v2)

let rec eval_expression (st : SStore.t) (e : expr) : expr = 

  (* if the expression contains symbolic values we can't reduce it to a value, so it is returned as is.
     in the future, I will write a 'simplify' function that takes advantage of the operators of our language (commutativity, etc) *)
  if is_symbolic_expression e then e
  
  (*else, we can reduce the expression until it becomes a value*)
  else 

  match e with
  
    | Var x ->
        let value = SStore.get st x in
        (match value with
        | None    -> failwith ("NameError: name " ^ x ^ " is not defined")
        | Some v  -> v) (*v will always be of type expr.Val *)

    | Val v -> Val v

    | UnOp  (op, e)      -> Val (eval_expression st e |> get_value_from_expr |> eval_unop_expr  op)
    | BinOp (op, e1, e2) -> Val (eval_binop_expr op (eval_expression st e1 |> get_value_from_expr) (eval_expression st e2 |> get_value_from_expr) )

    | SymbVal x -> failwith ("InternalError: tried to evaluate an expression consisting of a symbolic value " ^ x)


let step (prog : program) (state : SState.t) (s : stmt) (out : Outcome.t) : Program.stmt * SState.t * Outcome.t = 

  let store,cont,cs,pc = state in

  match s with

  | Assign (x,e) ->
      SStore.set store x (eval_expression store e);
      Skip,(store,cont,cs,pc),Cont
  
  | Print e  -> let _ = e |> eval_expression store |> print_expression in Skip,state,out
  
  | Symbol s -> let symb_val = make_symb_value s in
                SStore.set store s (SymbVal symb_val);
                Skip,(store,cont,cs,pc),Cont

  | FunCall (var,id,args) ->
    let eval_args   = List.map (fun e -> eval_expression store e) args in
    let function'   = Program.get_function id prog in
    let params      = function'.args in
    let var_vals    = try List.combine params eval_args
                      with _ -> failwith ("TypeError: argument arity mismatch when calling " ^ id) in
    let func_frame  = SStore.create_store var_vals in
    let cs'         = (Callstack.Intermediate (Store.create_empty_store 10, cont, var) ) :: cs in (*TODO change callstack to handle SStore *)
    function'.body, (func_frame, [], cs', pc), Cont

  | _    -> failwith ("InternalError: missing implementation of command " ^ (string_of_stmt s) )

let rec eval (gas : int) (prog : program) (state : SState.t) (s : stmt) (out : Outcome.t) : Outcome.t * SState.t  = 

  if gas=0 then out,state
  
  else

  let stmt',state',out'  = step prog state s out in
  let (_,cont',_,_) = state' in

  match stmt',out',cont' with
  | Skip, Cont    , [] -> failwith "BadProgram: functions should always return a value"
  | _,    Error   , _  -> out',state'
  | _,    AssumeF , _  -> out',state'
  | _,    Return _, _  -> out',state'
  | _                  -> eval (gas-1) prog state' stmt' out'

let interpret (prog : program) (main_id : string) : Outcome.t =
  let main  = get_function main_id prog in
  let tank  = 1000 in 
  let pathc = [Val (Boolean true)] in
  let state = ( SStore.create_empty_store 100, [main.body], [Callstack.Toplevel], pathc) in
  let o, _  = eval tank prog state Skip Cont in
  o