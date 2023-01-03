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

let rec eval_expression (st : Store.t) (e : expr) : value = 
  match e with
  
  | Var x ->
      let value = Store.get st x in
      (match value with
      | None    -> failwith ("NameError: name " ^ x ^ " is not defined")
      | Some v  -> v)
  
  | Val v -> v

  | UnOp (op, e)       -> eval_unop_expr  op (eval_expression st e)
  | BinOp (op, e1, e2) -> eval_binop_expr op (eval_expression st e1) (eval_expression st e2)

  | SymbVal x -> failwith ("InternalError: tried to evaluate a symbolic value \'" ^ x ^ "\' in a concrete execution context")
  

let step (prog : program) (state : State.t) : State.t * Outcome.t = 

  let s,cont,store,cs = state in
  (*let after_state = cont, store, cs in*)
  let atomic_step = Skip, cont, store, cs in (*maybe 'trivial_step' or 'trivial_state' or 'trivial_step' are more suitable names*)

  match s with
  
  | Skip | Clear ->
      (match cont with
      | []     ->        state     , Cont
      | h :: t -> (h, t, store, cs), Cont)
  
  | Sequence (s1::s2) -> (s1, s2@cont, store, cs), Cont

  | Assign (x,e) ->
      Store.set store x (eval_expression store e);
      atomic_step, Cont
  
  | FunCall (var,id,args) ->
      let eval_args   = List.map (fun e -> eval_expression store e) args in
      let function'   = Program.get_function id prog in
      let params      = function'.args in
      let var_vals    = try List.combine params eval_args
                        with _ -> failwith ("TypeError: argument arity mismatch when calling " ^ id) in
      let func_frame  = Store.create_store var_vals in
      let cs'         = (Callstack.Intermediate (store, cont, var) ) :: cs in
      (function'.body, [], func_frame, cs'), Cont

  | Return e ->
    let v     = eval_expression store e in
    let frame = Callstack.top cs in
    let cs'   = Callstack.pop cs in
      (match frame with
      | Callstack.Intermediate (store',rest,var)  -> (Store.set store' var v;
                                                     (Skip, rest, store', cs'), Cont)
      | Callstack.Toplevel  -> (Skip, cont, store, cs'), Return e)

  | IfElse (e, s1, s2) ->
      let guard = eval_expression store e in
      if is_true guard then
        (s1, cont, store, cs), Cont
      else
        (s2, cont, store, cs), Cont

  | While (e, body) as while_stmt ->
      let guard = eval_expression store e in
      if is_true guard then
        (body, while_stmt::cont, store, cs), Cont
      else
        (Skip, cont, store, cs), Cont

  | Assert e -> 
      let v = eval_expression store e in
      if is_true v then atomic_step, Cont
      else              atomic_step, Error

  | Assume e -> 
      let v = eval_expression store e in
      if is_true v then atomic_step, Cont
      else              atomic_step, AssumeF

  | Print exprs  -> 
      let eval_exprs = List.map (eval_expression store) exprs in
      let ()         = List.iter print_value eval_exprs in
      let ()         = print_endline "" in
      atomic_step, Cont

  | Symbol s    -> failwith ("InternalError: tried to declarate a symbolic variable \'" ^ s ^ "\' in a concrete execution context")

  | Sequence [] -> failwith "InternalError: tried to evaluate an empty Sequence"

let rec eval (prog : program) (state : State.t) : State.t * Outcome.t = 

  let state',out' = step prog state in
  let (stmt',cont',_,_) = state' in

  match stmt',cont',out' with
  | Skip, [], Cont     -> failwith "BadProgram: functions should always return a value"
  | _,    _ , Error    -> state',out'
  | _,    _ , AssumeF  -> state',out'
  | _,    _ , Return _ -> state',out'
  | _                  -> eval prog state'

let interpret (prog : program) (main_id : string) : Outcome.t =
  let main  = get_function main_id prog in
  let state = (Skip, [main.body], Store.create_empty_store 100, [Callstack.Toplevel]) in
  let _, o  = eval prog state in
  o