module M = struct
  open Expr
  module E = Smtml.Expr
  module V = Smtml.Value
  module Ty = Smtml.Ty
  module Slv = Smtml.Solver
  module S = Smtml.Symbol

  type t = E.t
  type st = t Store.t

  let solver = Slv.Z3_batch.create ()

  let eval_unop = function
    | Expr.Not -> `Unary Ty.(Ty_bool, Not)
    | Expr.Neg -> `Unary Ty.(Ty_int, Neg)
    | Expr.Abs -> `Unary Ty.(Ty_int, Abs)
    | Expr.StringOfInt -> `Cvtop Ty.(Ty_str, String_from_int)

  let eval_binop = function
    | Expr.Plus -> `Binary Ty.(Ty_int, Add)
    | Expr.Minus -> `Binary Ty.(Ty_int, Sub)
    | Expr.Times -> `Binary Ty.(Ty_int, Mul)
    | Expr.Div -> `Binary Ty.(Ty_int, Div)
    | Expr.Modulo -> `Binary Ty.(Ty_int, Rem)
    | Expr.Pow -> `Binary Ty.(Ty_int, Pow)
    | Expr.ShiftL -> `Binary Ty.(Ty_int, Shl)
    | Expr.ShiftR -> `Binary Ty.(Ty_int, ShrA)
    | Expr.Or -> `Binary Ty.(Ty_bool, Or)
    | Expr.And -> `Binary Ty.(Ty_bool, And)
    | Expr.Xor -> `Binary Ty.(Ty_bool, Xor)
    | Expr.Gt -> `Relop Ty.(Ty_int, Gt)
    | Expr.Lt -> `Relop Ty.(Ty_int, Lt)
    | Expr.Gte -> `Relop Ty.(Ty_int, Ge)
    | Expr.Lte -> `Relop Ty.(Ty_int, Le)
    | Expr.Equals -> `Relop Ty.(Ty_bool, Eq)
    | Expr.NEquals -> `Relop Ty.(Ty_bool, Ne)

  let rec eval (store : st) (e : Expr.t) : t =
    match e with
    | Val (Integer n) -> E.value (V.Int n)
    | Val (Boolean true) -> E.value V.True
    | Val (Boolean false) -> E.value V.False
    | Val (Loc n) -> E.value (V.Int n)
    | Var x -> Store.get store x
    | Unop (op, e) -> (
      let e = eval store e in
      match eval_unop op with
      | `Unary (t, op) -> E.(unop t op e)
      | `Cvtop (t, c) -> E.(cvtop t c e) )
    | Binop (op, e1, e2) -> (
      let e1 = eval store e1 in
      let e2 = eval store e2 in
      match eval_binop op with
      | `Binary (t, op) -> E.(binop t op e1 e2)
      | `Relop (t, op) -> E.(relop t op e1 e2) )
    | B_symb _ ->
      failwith
        "InternalError: EvalSymbolic.eval, tried to evaluate a symbolic boolean"
    | I_symb _ ->
      failwith
        "InternalError: EvalSymbolic.eval, tried to evaluate a symbolic integer"
    | Ite (_, _, _) -> failwith "InternalError: concrete Ite not implemented"
    | _ -> assert false

  let is_true (exprs : t list) : bool =
    match Slv.Z3_batch.check solver exprs with
    | `Sat -> true
    | `Unsat -> false
    | `Unknown ->
      failwith "InternalError: EvalSymbolic.is_true, Z3 returned unknown"

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

  let negate (e : t) : t = E.(unop Ty.Ty_bool Ty.Not e)
  let pp (fmt : Fmt.t) (e : t) : unit = E.pp fmt e
  let to_string (e : t) : string = Fmt.asprintf "%a" pp e
  let print (e : t) : unit = to_string e |> print_endline

  let make_symbol (name : string) (tp : string) =
    let symb_name = Parameters.symbol_prefix ^ name in
    let symb_value =
      if String.equal "bool" tp then E.mk_symbol (S.make Ty.Ty_bool symb_name)
      else E.mk_symbol (S.make Ty.Ty_int symb_name)
    in
    Some symb_value
end

module M' : Eval_intf.M with type t = Smtml.Expr.t = M
include M
