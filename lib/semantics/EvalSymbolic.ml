module M : Eval.M with type t = Expression.t = struct

  open EvalExpression
  open Expression

  type   t =   Expression.t
  type  st = t Store.t

  let rec is_symbolic (store : t Store.t) (e : t) : bool =
    let is_symbolic' = is_symbolic store in
    match e with
    | Val _           -> false
    | SymbVal _       -> true
    | SymbInt _       -> true
    | Var x           -> is_symbolic' (Store.get store x)
    | UnOp  (_, e)    -> is_symbolic' e
    | BinOp (_,e1,e2) -> is_symbolic' e1 || is_symbolic' e2

  let rec simplify_expression (store : st) (e : t) : t =
    let simplify_expr = simplify_expression store in
    match e with
    | Val _            -> e
    | SymbVal _        -> e
    | SymbInt _        -> e
    | Var x            -> Store.get store x
    | UnOp  (op, e)    -> UnOp (op, simplify_expr e)
    | BinOp (op,e1,e2) -> BinOp(op, simplify_expr e1, simplify_expr e2)

  let rec eval (store : st) (e : t) : t =

    (* We can't reduce the expression 'e' to a value if it contains symbolic variables, so we just replace each symbolic variable with its symbolic value *)
    if is_symbolic store e then simplify_expression store e

    (* If the expression does not contains symbolic variables, we can reduce it until it becomes a value *)
    else
    let get_val = Expression.get_value_from_expr in
    match e with
      | Val v              -> Val v
      | Var x              -> Store.get store x
      | UnOp  (op, e)      -> Val ( eval store e |> get_val |> eval_unop_expr op )
      | BinOp (op, e1, e2) -> Val ( eval_binop_expr op (eval store e1 |> get_val) (eval store e2 |> get_val) )
      | SymbVal _          -> failwith ("InternalError: EvalSymbolic.eval, tried to evaluate a symbolic value")
      | SymbInt _          -> failwith ("InternalError: EvalSymbolic.eval, tried to evaluate a symbolic value")

  let is_true (exprs : t list) : bool =
    Encoding.is_sat exprs

  let test_assert (exprs : t list) : bool * Model.t =
    if Encoding.is_sat exprs then
      true,Some (Encoding.get_model ())
    else
      false,None

  let negate (e : t) : t =
    Expression.negate e

  let to_string (e : t) : string =
    Expression.string_of_expression e

  let print (e : t) : unit =
    to_string e |> print_endline

  let make_symbol (name : string) =
    let symb_name   = Parameters.symbol_prefix ^ name in
    let symb_value  = SymbVal symb_name in
    Some symb_value

end
