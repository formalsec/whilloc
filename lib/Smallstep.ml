open Program
open Expression
open Outcome

let eval_unop_expr (op : uop) (v : value) : value =
  match op with
  | Neg -> neg v
  | Not -> not v
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

let rec eval_expression (st : Store.t) (e : expr) : value = 
  match e with
  
  | Var x ->
      let value = Store.get st x in
      if  value = None then failwith ("NameError: name " ^ x ^ " is not defined")
      else Expression.get_value value
  
  | Val v -> v

  | UnOp (op, e)       -> eval_unop_expr  op (eval_expression st e)
  | BinOp (op, e1, e2) -> eval_binop_expr op (eval_expression st e1) (eval_expression st e2)


let step (prog : program) (state : State.t) (s : stmt) (out : Outcome.t) : Program.stmt * State.t * Outcome.t = 

  let store,cont,cs = state in

  match s with
  
  | Skip ->
      (match cont with
      | []     -> Skip,  state        , Cont
      | h :: t -> h   , (store, t, cs), Cont)
  
  | Sequence (s1::s2) -> s1, (store, s2@cont, cs), Cont

  | Assign (x,e) ->
      Store.set store x (eval_expression store e);
      Skip,(store,cont,cs),Cont
  
  | FunCall (var,id,args) ->
      let eval_args   = List.map (fun e -> eval_expression store e) args in
      let function'   = Program.get_function id prog in
      let params      = function'.args in
      let var_vals    = try List.combine params eval_args
                        with _ -> failwith ("TypeError: argument arity mismatch when calling " ^ id) in
      let func_frame  = Store.create_store var_vals in
      let cs'         = (Callstack.Intermediate (store, cont, var) ) :: cs in
      function'.body, (func_frame, [], cs'), Cont

  | Return e ->
    let v     = eval_expression store e in
    let frame = Callstack.top cs in
    let cs'   = Callstack.pop cs in
      (match frame with
      | Callstack.Intermediate (store',rest,var) -> (Store.set store' var v;
                                                     Skip, (store',rest,cs'), Cont)
      | Callstack.Toplevel -> Skip, (store,cont,cs'), Return v)

  | IfElse (e, s1, s2) ->
      let guard = eval_expression store e in
      if is_true guard then
        s1,state,out
      else
        s2,state,out

  | While (e, body) as while_stmt ->
      (IfElse (e, Sequence ( (sequence_content body)@[while_stmt] ), Skip)),state,out

  | Assert e -> 
      let v = eval_expression store e in
      if is_true v then Skip,state,Cont
      else              Skip,state,Error

  | Assume e -> 
      let v = eval_expression store e in
      if is_true v then Skip,state,Cont
      else              Skip,state,AssumeF

  | Print e  -> let _ = e |> eval_expression store |> print_value in Skip,state,out

  | _    -> failwith ("InternalError: missing implementation of command " ^ (string_of_stmt s) )

let rec eval (prog : program) (state : State.t) (s : stmt) (out : Outcome.t) : Outcome.t * State.t  = 

  let stmt',state',out'  = step prog state s out in
  let (_,cont',_) = state' in

  match stmt',out',cont' with
  | Skip, Cont    , [] -> failwith "BadProgram: functions should always return a value"
  | _,    Error   , _  -> out',state'
  | _,    AssumeF , _  -> out',state'
  | _,    Return _, _  -> out',state'
  | _                  -> eval prog state' stmt' out'

let interpret (prog : program) (main_id : string) : Outcome.t =
  let main  = get_function main_id prog in
  let state = ( Store.create_empty_store 100, [main.body], [Callstack.Toplevel] ) in
  let o, _  = eval prog state Skip Cont in
  o