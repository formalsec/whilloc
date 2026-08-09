module M = struct
  open Expr
  module E = Smtml.Expr
  module V = Smtml.Value
  module Ty = Smtml.Ty
  module S = Smtml.Symbol

  type t = E.t
  type st = t Store.t

  let solver = Solver.create ()

  let eval_unop op e =
    match op with
    | Expr.Not -> E.unop Ty_bool Not e
    | Neg -> E.unop Ty_int Neg e
    | Abs -> E.unop Ty_int Abs e
    | StringOfInt -> E.cvtop Ty_str ToString e

  let eval_binop op e1 e2 =
    match op with
    | Expr.Plus -> E.binop Ty.Ty_int Add e1 e2
    | Minus -> E.binop Ty.Ty_int Sub e1 e2
    | Times -> E.binop Ty.Ty_int Mul e1 e2
    | Div -> E.binop Ty.Ty_int Div e1 e2
    | Modulo -> E.binop Ty.Ty_int Rem e1 e2
    | Pow -> E.binop Ty.Ty_int Pow e1 e2
    | ShiftL -> E.binop Ty.Ty_int Shl e1 e2
    | ShiftR -> E.binop Ty.Ty_int ShrA e1 e2
    | Or -> E.binop Ty.Ty_bool Or e1 e2
    | And -> E.binop Ty.Ty_bool And e1 e2
    | Xor -> E.binop Ty.Ty_bool Xor e1 e2
    | Lt -> E.relop Ty.Ty_int Lt e1 e2
    | Gt -> E.relop Ty.Ty_int Le e2 e1
    | Lte -> E.relop Ty.Ty_int Le e1 e2
    | Gte -> E.relop Ty.Ty_int Le e2 e1
    | Equals -> E.relop Ty.Ty_bool Eq e1 e2
    | NEquals -> E.relop Ty.Ty_bool Ne e1 e2

  let rec eval (store : st) (e : Expr.t) : t =
    match e with
    | Val (Integer n) -> E.value (V.Int n)
    | Val (Boolean true) -> E.value V.True
    | Val (Boolean false) -> E.value V.False
    | Val (Loc n) -> E.value (V.Int n)
    | Var x -> Store.get store x
    | Unop (op, e) ->
      let e = eval store e in
      eval_unop op e
    | Binop (op, e1, e2) ->
      let e1 = eval store e1 in
      let e2 = eval store e2 in
      eval_binop op e1 e2
    | B_symb _ ->
      failwith
        "InternalError: EvalSymbolic.eval, tried to evaluate a symbolic boolean"
    | I_symb _ ->
      failwith
        "InternalError: EvalSymbolic.eval, tried to evaluate a symbolic integer"
    | Ite (_, _, _) -> failwith "InternalError: concrete Ite not implemented"
    | _ -> assert false

  let is_true (exprs : t list) : bool =
    match Solver.check solver exprs with
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
    match Solver.model solver with
    | Some m -> (true, Some (hashtbl_to_list m))
    | None -> (false, None)

  let negate (e : t) : t = E.(unop Ty_bool Not e)
  let pp (fmt : Fmt.t) (e : t) : unit = E.pp fmt e
  let to_string (e : t) : string = Fmt.asprintf "%a" pp e
  let print (e : t) : unit = to_string e |> print_endline

  let make_symbol (name : string) (tp : string) =
    let symb_name = Parameters.symbol_prefix ^ name in
    let symb_value =
      if String.equal "bool" tp then E.symbol (S.make Ty.Ty_bool symb_name)
      else E.symbol (S.make Ty.Ty_int symb_name)
    in
    Some symb_value
end

module M' : Eval_intf.M with type t = Smtml.Expr.t = M
include M
