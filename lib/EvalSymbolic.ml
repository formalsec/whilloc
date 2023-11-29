module M : Eval_intf.M with type t = Term.t = struct
  open EvalExpression
  open Term

  type t = Term.t
  type st = t Store.t

  let rec is_symbolic (store : t Store.t) (e : t) : bool =
    let is_symbolic' = is_symbolic store in
    match e with
    | Val _ -> false
    | B_symb _ -> true
    | I_symb _ -> true
    | Var x -> is_symbolic' (Store.get store x)
    | Unop (_, e) -> is_symbolic' e
    | Binop (_, e1, e2) -> is_symbolic' e1 || is_symbolic' e2
    | Ite (_, _, _) -> true

  let rec simplify_expression (store : st) (e : t) : t =
    let simplify_expr = simplify_expression store in
    match e with
    | Val _ -> e
    | B_symb _ -> e
    | I_symb _ -> e
    | Var x -> Store.get store x
    | Unop (op, e) -> Unop (op, simplify_expr e)
    | Binop (op, e1, e2) -> Binop (op, simplify_expr e1, simplify_expr e2)
    | Ite (e1, e2, e3) ->
        Ite (simplify_expr e1, simplify_expr e2, simplify_expr e3)

  let rec eval (store : st) (e : t) : t =
    (* We can't reduce the expression 'e' to a value if it contains symbolic variables, so we just replace each symbolic variable with its symbolic value *)
    if is_symbolic store e then simplify_expression store e
      (* If the expression does not contains symbolic variables, we can reduce it until it becomes a value *)
    else
      let get_val = Term.get_value_from_expr in
      match e with
      | Val v -> Val v
      | Var x -> Store.get store x
      | Unop (op, e) -> Val (eval store e |> get_val |> eval_unop_expr op)
      | Binop (op, e1, e2) ->
          Val
            (eval_binop_expr op
               (eval store e1 |> get_val)
               (eval store e2 |> get_val))
      | B_symb _ ->
          failwith
            "InternalError: EvalSymbolic.eval, tried to evaluate a symbolic \
             boolean"
      | I_symb _ ->
          failwith
            "InternalError: EvalSymbolic.eval, tried to evaluate a symbolic \
             integer"
      | Ite (_, _, _) -> failwith "InternalError: concrete Ite not implemented"

  let is_true (exprs : t list) : bool = Translator.is_sat exprs

  let test_assert (exprs : t list) : bool * Model.t =
    let model = Translator.find_model exprs in
    (Option.is_some model, model)

  let negate (e : t) : t = Term.negate e
  let to_string (e : t) : string = Term.to_string e
  let print (e : t) : unit = to_string e |> print_endline

  let make_symbol (name : string) (tp : string) =
    let symb_name = Parameters.symbol_prefix ^ name in
    let symb_value =
      if String.equal "bool" tp then Term.make_symb_bool symb_name
      else Term.make_symb_int symb_name
    in
    Some symb_value
end
