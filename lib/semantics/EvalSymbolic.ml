module M : Eval.M with type t = Expression.t = struct

  open EvalExpression
  open Expression
  
  type   t =   Expression.t
  type  st = t Store.t

  let is_symbolic_value (v : Value.t) : bool =
    match v with
    | SymbVal _ -> true
    | _         -> false
  
  let rec is_symbolic (store : st) (e : t) : bool =
    match e with
    | Val v           -> is_symbolic_value v
    | Var x           -> Store.get store x |> is_symbolic store 
    | UnOp  (_, e)    -> is_symbolic store e
    | BinOp (_,e1,e2) -> is_symbolic store e1 || is_symbolic store e2
  
  let rec simplify_expression (store : st) (e : t) : t =
    match e with
    | Val _            -> e
    | Var x            -> Store.get store x
    | UnOp  (op, e)    -> UnOp (op, simplify_expression store e)
    | BinOp (op,e1,e2) -> BinOp(op, simplify_expression store e1, simplify_expression store e2)
  
  let rec eval (store : st) (e : Expression.t) : t = 
  
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

  let is_true (exprs : t list) : bool =
    Encoding.is_sat exprs

  let negate (e : t) : t = 
    Expression.UnOp (Not, e) 

  let to_string t : string = Expression.string_of_expression t

  let print t : unit = to_string t |> print_endline

  let make_fresh_symb_generator (pref : string) : (unit -> string) =
    let count = ref 1 in
    fun () -> let x = !count in
      count := x+1; pref ^ (string_of_int x)

  let generate_fresh_var = make_fresh_symb_generator Parameters.symbol_prefix

  let make_symbol (name : string) =
    let symb_name   = generate_fresh_var() ^ "__" ^ name in
    let symb_value  = Value.SymbVal symb_name in 
    Some (Val symb_value)

end