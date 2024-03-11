module M : Eval_intf.M with type t = Value.t = struct
  open Eval_expression

  type t = Value.t
  type st = t Store.t

  let rec eval (store : st) (e : Term.t) : t =
    match e with
    | Val v -> v
    | Var x -> Store.get store x
    | Unop (op, e) -> eval_unop_expr op (eval store e)
    | Binop (op, e1, e2) -> eval_binop_expr op (eval store e1) (eval store e2)
    | B_symb s ->
        failwith
          ("InternalError: Eval_concrete.eval, tried to evaluate a symbolic \
            expression" ^ s ^ "in a concrete execution context")
    | I_symb s ->
        failwith
          ("InternalError: Eval_concrete.eval, tried to evaluate a symbolic \
            expression" ^ s ^ "in a concrete execution context")
    | Ite (e1, e2, e3) -> eval_ite e1 e2 e3

  let is_true (v : t list) : bool =
    let v' =
      try List.hd v
      with _ ->
        failwith
          "InternalError: Eval_concrete.is_true, tried to evaluate an empty \
           list of values"
    in
    match v' with
    | Boolean b -> b
    | Integer _ ->
        failwith
          "InternalError: Eval_concrete.is_true, guard expressions must be of \
           type boolean"
    | Loc l ->
        failwith
          ("InternalError: Eval_concrete.is_true, location value "
         ^ string_of_int l
         ^ " cannot be evaluated to true or false in concrete evaluation \
            contexts")
    | Error -> failwith "ERROR ERROR"

  let test_assert (exprs : t list) : bool * Model.t = (is_true exprs, None)

  let negate (v : t) : t =
    match v with
    | Boolean true -> Boolean false
    | Boolean false -> Boolean true
    | _ ->
        failwith
          "InternalError: Eval_concrete.negate, tried to negate a non boolean \
           value"

  let pp (fmt : Fmt.t) (v : t) : unit = Value.pp fmt v
  let to_string (v : t) : string = Fmt.asprintf "%a" pp v
  let print (v : t) : unit = to_string v |> print_endline

  let make_symbol (name : string) (tp : string) =
    let _ = (name, tp) in
    None
end
