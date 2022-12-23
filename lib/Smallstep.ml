open Program
open Expression

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


let step (prog : program) (st : Store.t) (cs : Callstack.t) (s : stmt) (out : State.t) : Program.stmt * State.t * Store.t * Callstack.t = 

  let k = State.get_continuation out in

  match s with
  
  | Skip ->
      (match k with
      | []     -> Skip, Cont [], st, cs
      | h :: t -> h   , Cont t , st, cs)
  
  | Sequence (s1::s2) -> s1, Cont (s2@k), st, cs

  | Assign (x,e) ->
    Store.set st x (eval_expression st e);
    Skip,out,st,cs
  
  | FunCall (var,id,args) ->
    let eval_args   = List.map (fun e -> eval_expression st e) args in
    let function'   = Program.get_function id prog in
    let params      = function'.args in
    let var_vals    = try List.combine params eval_args
                      with _ -> failwith ("TypeError: argument arity mismatch when calling " ^ id) in
    let func_frame  = Store.create_store var_vals in
    let cs'         = (Callstack.Intermediate (st, k, var) ) :: cs in
    function'.body, Cont [], func_frame, cs'

  | IfElse (e, s1, s2) ->
    let guard = eval_expression st e in
    if is_true guard then
      s1,out,st,cs
    else
      s2,out,st,cs

  | While (e, body) as while_stmt ->
      (IfElse (e, Sequence ( (sequence_content body)@[while_stmt] ), Skip)),out,st,cs

  | Print e  -> let _ = e |> eval_expression st |> print_value in Skip,out,st,cs

  | Return e ->
      let v     = eval_expression st e in
      let frame = Callstack.top cs in
      let cs'   = Callstack.pop cs in
        (match frame with
        | Callstack.Intermediate (st',rest,x) -> (Store.set st' x v;
                                                  Skip, Cont rest, st', cs')
        | Callstack.Toplevel -> Skip, Return v, st, cs)

  | Assert e -> 
      let v = eval_expression st e in
      if is_true v then Skip,out,st,cs
      else              Skip,Error,st,cs

  | Assume e -> 
      let v = eval_expression st e in
      if is_true v then Skip,out,st,cs
      else              Skip,AssumeF,st,cs

  | _    -> failwith "TODO command"

let rec eval (prog : program) (st : Store.t) (cs : Callstack.t) (s : stmt) (out : State.t) : State.t * Store.t * Callstack.t = 
  let stmt',out',st',cs' = step prog st cs s out in
  match stmt',out' with
  | Skip, Cont []  -> Cont [] ,st',cs'
  | _,    Error    -> Error   ,st',cs'
  | _,    AssumeF  -> AssumeF ,st',cs'
  | _,    Return v -> Return v,st',cs'
  | _              -> eval prog st' cs' stmt' out'

let interpret (prog : program) (main_id : string) : State.t =
  let main = get_function main_id prog in
  let st   = Store.create_empty_store 100 in
  let cs   = [Callstack.Toplevel] in
  let o, _, _ = eval prog st cs Skip (Cont (sequence_content main.body)) in
  o