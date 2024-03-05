open Value
open Term

let ( let* ) o f = Option.bind o f
let solver_time = ref 0.0

let list_map f l =
  let exception E in
  try
    Some (List.map (fun o -> match f o with Some v -> v | None -> raise E) l)
  with E -> None

let ctx = Z3.mk_context []
let solver = Z3.Solver.mk_simple_solver ctx

let translate_value (v : Value.t) : Z3.Expr.expr =
  match v with
  | Integer x -> Z3.Arithmetic.Integer.mk_numeral_i ctx x
  | Boolean x -> Z3.Boolean.mk_val ctx x
  | Loc x -> Z3.Arithmetic.Integer.mk_numeral_i ctx x
  | Error -> assert false

let translate_uop (op : unop) (v : Z3.Expr.expr) : Z3.Expr.expr =
  match op with
  | Neg -> Z3.Arithmetic.mk_unary_minus ctx v
  | Not -> Z3.Boolean.mk_not ctx v
  | Abs -> assert false
  | StringOfInt -> assert false

let translate_binop (op : binop) (v1 : Z3.Expr.expr) (v2 : Z3.Expr.expr) :
    Z3.Expr.expr =
  match op with
  | Plus -> Z3.Arithmetic.mk_add ctx [ v1; v2 ]
  | Minus -> Z3.Arithmetic.mk_sub ctx [ v1; v2 ]
  | Times -> Z3.Arithmetic.mk_mul ctx [ v1; v2 ]
  | Div -> Z3.Arithmetic.mk_div ctx v1 v2
  | Pow -> Z3.Arithmetic.mk_power ctx v1 v2
  | Gt -> Z3.Arithmetic.mk_gt ctx v1 v2
  | Lt -> Z3.Arithmetic.mk_lt ctx v1 v2
  | Gte -> Z3.Arithmetic.mk_ge ctx v1 v2
  | Lte -> Z3.Arithmetic.mk_le ctx v1 v2
  | Equals -> Z3.Boolean.mk_eq ctx v1 v2
  | NEquals -> Z3.Boolean.mk_not ctx @@ Z3.Boolean.mk_eq ctx v1 v2
  | Or -> Z3.Boolean.mk_or ctx [ v1; v2 ]
  | And -> Z3.Boolean.mk_and ctx [ v1; v2 ]
  | Xor -> Z3.Boolean.mk_xor ctx v1 v2
  | _ ->
      Format.kasprintf failwith
        "TODO: Encoding.encode_binop, missing implementation of %a"
        Term.pp_binop op

let rec translate (e : Term.t) : Z3.Expr.expr =
  match e with
  | Val v -> translate_value v
  | Var v ->
      failwith
        ("InternalError: Encoding.encode_expr, tried to encode variable " ^ v)
  | Unop (op, e) ->
      let e' = translate e in
      translate_uop op e'
  | Binop (op, e1, e2) ->
      let e1' = translate e1 in
      let e2' = translate e2 in
      translate_binop op e1' e2'
  | B_symb s -> Z3.Boolean.mk_const_s ctx s
  | I_symb s -> Z3.Arithmetic.Integer.mk_const_s ctx s
  | Ite (e1, e2, e3) ->
      let e1' = translate e1 in
      let e2' = translate e2 in
      let e3' = translate e3 in
      Z3.Boolean.mk_ite ctx e1' e2' e3'

let is_sat (exprs : Term.t list) : bool =
  let exprs' = List.map translate exprs in
  match
    Utils.total_time_call "Solver" solver_time (fun () ->
        Z3.Solver.check solver exprs')
  with
  | Z3.Solver.SATISFIABLE -> true
  | Z3.Solver.UNSATISFIABLE -> false
  | Z3.Solver.UNKNOWN -> assert false

let get_interp (model : Z3.Model.model) (const : Z3.FuncDecl.func_decl) :
    (string * Value.t) option =
  let* interp = Z3.Model.get_const_interp model const in
  let* v =
    match Z3.Expr.get_sort interp |> Z3.Sort.get_sort_kind with
    | Z3enums.INT_SORT ->
        let x =
          int_of_string @@ Z3.Arithmetic.Integer.numeral_to_string interp
        in
        Some (Integer x)
    | Z3enums.BOOL_SORT -> (
        match Z3.Boolean.get_bool_value interp with
        | Z3enums.L_TRUE -> Some (Boolean true)
        | Z3enums.L_FALSE -> Some (Boolean false)
        | Z3enums.L_UNDEF -> assert false)
    | _ -> None
  in
  Some (Z3.Symbol.to_string @@ Z3.FuncDecl.get_name const, v)

let find_model ?(print_model = false) (es : Term.t list) :
    (string * Value.t) list option =
  assert (is_sat es);
  let* model = Z3.Solver.get_model solver in
  if print_model then Format.printf "%s@." (Z3.Model.to_string model);
  list_map (get_interp model) (Z3.Model.get_const_decls model)
