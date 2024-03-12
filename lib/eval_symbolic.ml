module M : Eval_intf.M with type t = Encoding.Expr.t = struct
  open Term

  module E = Encoding.Expr
  module V = Encoding.Value
  module T = Encoding.Ty
  module Slv = Encoding.Solver
  module S = Encoding.Symbol

  type t = E.t
  type st = t Store.t

  let solver = Slv.Z3_batch.create ()

  let eval_unop (op : Term.unop) : T.unop =
    match op with
    | Term.Neg -> T.Neg
    | Term.Not -> T.Not
    | Term.Abs -> T.Abs
    | Term.StringOfInt -> failwith 
      "InternalError: EvalSymbolic.eval_unop, StringOfInt not implemented in Encoding"

  let eval_binop (op : Term.binop) =
    match op with
    | Term.Plus -> (Some T.Add, None)
    | Term.Minus -> (Some T.Sub, None)
    | Term.Times -> (Some T.Mul, None)
    | Term.Div -> (Some T.Div, None)
    | Term.Modulo -> (Some T.Rem, None)
    | Term.Pow -> (Some T.Pow, None)
    | Term.Or -> (Some T.Or, None)
    | Term.And -> (Some T.And, None)
    | Term.Xor -> (Some T.Xor, None)
    | Term.ShiftL -> (Some T.Shl, None)
    | Term.ShiftR -> (Some T.ShrA, None)
    | Term.Gt -> (None, Some T.Gt)
    | Term.Lt -> (None, Some T.Lt)
    | Term.Gte -> (None, Some T.Ge)
    | Term.Lte -> (None, Some T.Le)
    | Term.Equals -> (None, Some T.Eq)
    | Term.NEquals -> (None, Some T.Ne)

  let rec eval (store : st) (e : Term.t) : t =
    match e with
    | Val Integer n -> E.(make @@ Val (V.Int n))
    | Val Boolean true -> E.(make @@ Val (V.True))
    | Val Boolean false -> E.(make @@ Val (V.False))
    | Val Loc n -> E.(make @@ Val (V.Int n))
    | Var x -> Store.get store x
    | Unop (op, e) ->
        let op' = eval_unop op in
        let e' = eval store e in
        (match op' with
        | T.Not -> E.(unop T.Ty_bool op' e')
        | _ -> E.(unop T.Ty_int op' e'))
    | Binop (op, e1, e2) ->
        let op' = eval_binop op in
        let e1' = eval store e1 in
        let e2' = eval store e2 in
        (match op' with
        | Some b, None -> E.(binop T.Ty_int b e1' e2')
        | None, Some r -> E.(relop T.Ty_int r e1' e2')
        | _ -> assert false)
    | B_symb _ ->
        failwith
          "InternalError: EvalSymbolic.eval, tried to evaluate a symbolic \
           boolean"
    | I_symb _ ->
        failwith
          "InternalError: EvalSymbolic.eval, tried to evaluate a symbolic \
           integer"
    | Ite (_, _, _) -> failwith "InternalError: concrete Ite not implemented"
    | _ -> assert false

  let is_true (exprs : t list) : bool = 
    Slv.Z3_batch.check solver exprs

  let translate_value (v : V.t) : Value.t =
    match v with
    | V.Int n -> Value.Integer n
    | V.True -> Value.Boolean true
    | V.False -> Value.Boolean false
    | _ -> failwith "InternalError: EvalSymbolic.val_translator, value from Encoding not implemented"

  let hashtbl_to_list (tbl : (S.t, V.t) Hashtbl.t) : (string * Value.t) list option =
    Some (Hashtbl.fold (fun k v acc -> (S.to_string k, translate_value v) :: acc) tbl [])

  let test_assert (exprs : t list) : bool * Model.t =
    assert (is_true exprs);
    let enc_model = Slv.Z3_batch.model solver in
    match enc_model with
    | Some m -> 
      let model = hashtbl_to_list m in
      (Option.is_some model, model)
    | None ->  (false, None)

  let negate (e : t) : t = E.(unop T.Ty_bool T.Not e)
  let pp (fmt : Fmt.t) (e : t) : unit = E.pp fmt e
  let to_string (e : t) : string = Fmt.asprintf "%a" pp e
  let print (e : t) : unit = to_string e |> print_endline

  let make_symbol (name : string) (tp : string) =
    let symb_name = Parameters.symbol_prefix ^ name in
    let symb_value =
      if String.equal "bool" tp then E.mk_symbol (S.mk_symbol T.Ty_bool symb_name)
      else E.mk_symbol (S.mk_symbol T.Ty_int symb_name)
    in
    Some symb_value
end
