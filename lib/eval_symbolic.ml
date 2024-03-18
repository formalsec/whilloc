module M = struct
  open Expr
  module E = Encoding.Expr
  module V = Encoding.Value
  module T = Encoding.Ty
  module Slv = Encoding.Solver
  module S = Encoding.Symbol

  type t = E.t
  type st = t Store.t

  let solver = Slv.Z3_batch.create ()

  let eval_unop (op : Expr.unop) =
    match op with
    | Expr.Neg -> (Some T.Neg, None)
    | Expr.Not -> (Some T.Not, None)
    | Expr.Abs -> (Some T.Abs, None)
    | Expr.StringOfInt -> (None, Some T.String_from_int)

  let eval_binop (op : Expr.binop) =
    match op with
    | Expr.Plus -> (Some T.Add, None)
    | Expr.Minus -> (Some T.Sub, None)
    | Expr.Times -> (Some T.Mul, None)
    | Expr.Div -> (Some T.Div, None)
    | Expr.Modulo -> (Some T.Rem, None)
    | Expr.Pow -> (Some T.Pow, None)
    | Expr.Or -> (Some T.Or, None)
    | Expr.And -> (Some T.And, None)
    | Expr.Xor -> (Some T.Xor, None)
    | Expr.ShiftL -> (Some T.Shl, None)
    | Expr.ShiftR -> (Some T.ShrA, None)
    | Expr.Gt -> (None, Some T.Gt)
    | Expr.Lt -> (None, Some T.Lt)
    | Expr.Gte -> (None, Some T.Ge)
    | Expr.Lte -> (None, Some T.Le)
    | Expr.Equals -> (None, Some T.Eq)
    | Expr.NEquals -> (None, Some T.Ne)

  let rec eval (store : st) (e : Expr.t) : t =
    match e with
    | Val (Integer n) -> E.(make @@ Val (V.Int n))
    | Val (Boolean true) -> E.(make @@ Val V.True)
    | Val (Boolean false) -> E.(make @@ Val V.False)
    | Val (Loc n) -> E.(make @@ Val (V.Int n))
    | Var x -> Store.get store x
    | Unop (op, e) -> (
      let op' = eval_unop op in
      let e' = eval store e in
      match op' with
      | Some T.Not, None -> E.(unop T.Ty_bool T.Not e')
      | Some u, None -> E.(unop T.Ty_int u e')
      | None, Some c -> E.(cvtop T.Ty_int c e')
      | _ -> assert false )
    | Binop (op, e1, e2) -> (
      let op' = eval_binop op in
      let e1' = eval store e1 in
      let e2' = eval store e2 in
      match op' with
      | Some T.Or, None -> E.(binop T.Ty_bool T.Or e1' e2')
      | Some T.And, None -> E.(binop T.Ty_bool T.And e1' e2')
      | Some T.Xor, None -> E.(binop T.Ty_bool T.Xor e1' e2')
      | Some b, None -> E.(binop T.Ty_int b e1' e2')
      | None, Some r -> E.(relop T.Ty_int r e1' e2')
      | _ -> assert false )
    | B_symb _ ->
      failwith
        "InternalError: EvalSymbolic.eval, tried to evaluate a symbolic boolean"
    | I_symb _ ->
      failwith
        "InternalError: EvalSymbolic.eval, tried to evaluate a symbolic integer"
    | Ite (_, _, _) -> failwith "InternalError: concrete Ite not implemented"
    | _ -> assert false

  let is_true (exprs : t list) : bool = Slv.Z3_batch.check solver exprs

  let translate_value (v : V.t) : Value.t =
    match v with
    | V.Int n -> Value.Integer n
    | V.True -> Value.Boolean true
    | V.False -> Value.Boolean false
    | _ ->
      failwith
        "InternalError: EvalSymbolic.val_translator, value from Encoding not \
         implemented"

  let hashtbl_to_list (tbl : (S.t, V.t) Hashtbl.t) : (string * Value.t) list =
    Hashtbl.fold
      (fun k v acc -> (S.to_string k, translate_value v) :: acc)
      tbl []

  let test_assert (exprs : t list) : bool * Model.t =
    assert (is_true exprs);
    match Slv.Z3_batch.model solver with
    | Some m -> (true, Some (hashtbl_to_list m))
    | None -> (false, None)

  let negate (e : t) : t = E.(unop T.Ty_bool T.Not e)
  let pp (fmt : Fmt.t) (e : t) : unit = E.pp fmt e
  let to_string (e : t) : string = Fmt.asprintf "%a" pp e
  let print (e : t) : unit = to_string e |> print_endline

  let make_symbol (name : string) (tp : string) =
    let symb_name = Parameters.symbol_prefix ^ name in
    let symb_value =
      if String.equal "bool" tp then
        E.mk_symbol (S.mk_symbol T.Ty_bool symb_name)
      else E.mk_symbol (S.mk_symbol T.Ty_int symb_name)
    in
    Some symb_value
end

module M' : Eval_intf.M with type t = Encoding.Expr.t = M
include M
