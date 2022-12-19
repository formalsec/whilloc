open Program

let eval_unop_expr (op : uop) (v : value) : value =
  match op with
  | Neg -> neg v
  | Not -> not v
  | Abs -> abs v
  | StringOfInt -> stoi v

let eval_binop_expr (op : bop) (v1 : value) (v2 : value) : value =
  match op with
  | Plus   -> plus   (v1, v2)
  | Minus  -> minus  (v1, v2)
  | Times  -> times  (v1, v2)
  | Div    -> div    (v1, v2)
  | Modulo -> modulo (v1, v2)
  | Pow    -> pow    (v1, v2)
  | Gt     -> gt     (v1, v2)
  | Lt     -> lt     (v1, v2)
  | Gte    -> gte    (v1, v2)
  | Lte    -> lte    (v1, v2)
  | Equals -> equal  (v1, v2)
  | NEquals -> nequal (v1, v2)

let rec eval_expression (e : expr) : value = 
  match e with
  | Val v -> v
  | BinOp (op, Val v1, Val v2) -> eval_binop_expr op v1 v2
  | BinOp (op, e1, Val v2) ->  eval_binop_expr op (eval_expression e1) v2
  | BinOp (op, Val v1, e2) ->  eval_binop_expr op v1 (eval_expression e2)
  | _ -> failwith "TODO small step"

let step_statement (s : stmt) : State.t = 
  match s with
  | _ -> Normal

let rec eval (s : stmt) (prog : program) : State.t = 
  match s,prog with
  | While (e, s1),_ -> (*unfold the while loop by testing, iteration for iteration, if the guard evaluates to true*)
    let guard = eval_expression e in
    if is_true guard then
      let o = eval s1 prog in
      if o=Error then Error
      else eval s prog
    else
      Normal
  | _,_ -> State.Normal