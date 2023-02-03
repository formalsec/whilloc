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

  let is_true (v : t list) : bool =
    let v' = try List.hd v
    with _ -> failwith "InternalError: EvalConcrete.is_true, tried to evaluate an empty list of values" in 
    match v' with
    | Integer n -> if n!=0 then true else false
    | Boolean b -> b
    | SymbVal _ -> failwith "InternalError: EvalConcrete.is_true, Symbolic Values cannot be evaluated to true or false at the level of concrete evaluations"

  let negate (v : t) : t = 
    match v with
    | Boolean true  -> Boolean false
    | Boolean false -> Boolean true
    | _             -> failwith "InternalError: EvalConcrete.negate, tried to negate a non boolean value"

  let to_string t = Value.string_of_value t
  let print t = to_string t |> print_endline

  let add_condition pc t = t::pc
    (*match pc with
    | h :: t -> t
    *)
  (* Symbols X̂x̂ *)
  let make_symbol (name : string) =
    let _ = name in
    failwith "ApplicationError: StateConcrete.make_symb_value, tried to create a symbolic value in a concrete execution context"

end