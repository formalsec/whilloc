module M : Eval.M with type t = Value.t = struct

  open EvalExpression

  type   t =   Value.t
  type  st = t Store.t

  let rec eval (store : st) (e : Expression.t) : t =
    match e with
    | Val v -> v
    | Var x -> Store.get store x
    | UnOp  (op, e)      -> eval_unop_expr  op (eval store e)
    | BinOp (op, e1, e2) -> eval_binop_expr op (eval store e1) (eval store e2)
    | SymbVal s -> failwith("InternalError: EvalConcrete.eval, tried to evaluate a symbolic expression" ^ s ^ "in a concrete execution context")
    | SymbInt s -> failwith("InternalError: EvalConcrete.eval, tried to evaluate a symbolic expression" ^ s ^ "in a concrete execution context")

  let is_true (v : t list) : bool =
    let v' = try List.hd v
    with _ -> failwith "InternalError: EvalConcrete.is_true, tried to evaluate an empty list of values" in
    match v' with
    | Boolean b -> b
    | Integer _ -> failwith ("InternalError: EvalConcrete.is_true, guard expressions must be of type boolean")
    | Loc     l -> failwith ("InternalError: EvalConcrete.is_true, location value " ^ (string_of_int l) ^ " cannot be evaluated to true or false in concrete evaluation contexts")

  let test_assert (exprs : t list) : bool * Model.t =
    is_true exprs,None

  let negate (v : t) : t =
    match v with
    | Boolean true  -> Boolean false
    | Boolean false -> Boolean true
    | _             -> failwith "InternalError: EvalConcrete.negate, tried to negate a non boolean value"

  let to_string (v : t) : string =
    Value.string_of_value v

  let print (v : t) : unit =
    to_string v |> print_endline

  let make_symbol (name : string) =
    let _ = name in
    None

end
