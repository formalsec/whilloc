open Program

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
      else Program.get_value value
  
  | Val v -> v

  | UnOp (op, e)       -> eval_unop_expr  op (eval_expression st e)
  | BinOp (op, e1, e2) -> eval_binop_expr op (eval_expression st e1) (eval_expression st e2)

let rec eval (prog : program) (st : Store.t) (s : stmt) : Store.t * State.t = 
  let eval' = eval prog in
  match s with

  | Skip -> st,Normal

  | Sequence [current_stmt]    -> eval' st current_stmt

  | Sequence (current_stmt::rest) ->
      let st',out = eval' st current_stmt in
      (match out with
      | Normal    -> eval' st' (Sequence rest)
      | Return _  -> st',out
      | Error     -> st ,out
      | AssumeF   -> st ,out)

  | Assign (x,e) ->
      Store.set st x (eval_expression st e);
      st,Normal

  | FunCall (var,id,args) ->
      let eval_args   = List.map (fun e -> eval_expression st e) args in
      let function'   = Program.get_function id prog in
      let params      = function'.args in
      let var_vals    = try List.combine params eval_args
                        with _ -> failwith ("TypeError: argument arity mismatch when calling " ^ id) in
      let fresh_st    = Store.create var_vals in
      let _, out      = eval prog fresh_st function'.body  in
      (match out with
        | Normal | Error | AssumeF -> st,out
        | Return value -> Store.set st var value; st,Normal)

  | IfElse (e, s1, s2) ->
      let guard = eval_expression st e in
      if is_true guard then
        eval' st s1
      else
        eval' st s2

  | While (e, body) as while_stmt ->
      eval' st (IfElse (e, Sequence ( (sequence_content body)@[while_stmt] ), Skip))

  | Print e  -> let _ = e |> eval_expression st |> print_value in st,Normal

  | Return e -> st,Return (eval_expression st e)

  | Assert e -> 
      let v = eval_expression st e in
      if is_true v then st,Normal
      else              st,Error

  | Assume e -> 
      let v = eval_expression st e in
      if is_true v then st,Normal
      else              st,AssumeF

  | _ -> failwith "InternalError: evaluation of command not implemented yet"

let interpret (prog : program) (main_id : string) : State.t =
  let main = get_function main_id prog in
  let st = Store.create_store 100 in
  let _, o = eval prog st main.body in
  o
