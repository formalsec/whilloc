type unop = Neg | Not | Abs | StringOfInt [@@deriving yojson]

type binop =
  | Plus
  | Minus
  | Times
  | Div
  | Modulo
  | Pow
  | Or
  | And
  | Xor
  | ShiftL
  | ShiftR
  | Gt
  | Lt
  | Gte
  | Lte
  | Equals
  | NEquals
[@@deriving yojson]
(* type rop = Gt | Lt | Ge | LE | Eq | Ne *)

type t =
  | Val of Value.t
  | Var of string
  | Unop of unop * t
  | Binop of binop * t * t
  (* | Relop   of rop * t * t *)
  | B_symb of string
  | I_symb of string
  | Ite of t * t * t
[@@deriving yojson]

let make_true : t = Val (Value.Boolean true)
let make_false : t = Val (Value.Boolean false)
let make_symb_bool (name : string) : t = B_symb name
let make_symb_int (name : string) : t = I_symb name
let make_uoperation (op : unop) (e : t) : t = Unop (op, e)
let make_boperation (op : binop) (e1 : t) (e2 : t) : t = Binop (op, e1, e2)
let negate (e : t) : t = Unop (Not, e)

let get_value_from_expr (e : t) : Value.t =
  match e with
  | Val v -> v
  | _ ->
      failwith
        "InternalError: Expression.get_value_from_expr, tried to retrieve a \
         value from a non value constructor"

let rec flatten (e : t) : t list =
  match e with
  | Unop (_, e) -> flatten e
  | Binop (_, e1, e2) -> flatten e1 @ flatten e2
  | _ -> [ e ]

let rec get_symbols (e : t) : string list =
  match e with
  | B_symb b -> [ b ]
  | I_symb i -> [ i ]
  | Val _ -> []
  | Var _ -> []
  | Unop (_, e) -> get_symbols e
  | Binop (_, e1, e2) -> get_symbols e1 @ get_symbols e2
  | Ite (e1, e2, e3) -> get_symbols e1 @ get_symbols e2 @ get_symbols e3

let pp_string = Fmt.pp_print_string
let fprintf = Fmt.fprintf

let pp_unop fmt (op : unop) =
  match op with
  | Neg -> pp_string fmt "-"
  | Not -> pp_string fmt "!"
  | Abs -> pp_string fmt "abs"
  | StringOfInt -> pp_string fmt "stoi"

let pp_binop fmt (op : binop) =
  match op with
  | Plus -> pp_string fmt "+"
  | Minus -> pp_string fmt "-"
  | Times -> pp_string fmt "*"
  | Div -> pp_string fmt "/"
  | Modulo -> pp_string fmt "%"
  | Pow -> pp_string fmt "^"
  | Gt -> pp_string fmt ">"
  | Lt -> pp_string fmt "<"
  | Gte -> pp_string fmt ">="
  | Lte -> pp_string fmt "<="
  | Equals -> pp_string fmt "=="
  | NEquals -> pp_string fmt "!="
  | Or -> pp_string fmt "OR" (* ∨ *)
  | And -> pp_string fmt "AND" (* ∧ *)
  | Xor -> pp_string fmt "⊕"
  | ShiftL -> pp_string fmt "<<"
  | ShiftR -> pp_string fmt ">>"

let rec pp fmt (e : t) =
  match e with
  | B_symb s -> fprintf fmt "(SymbBool %s)" s
  | I_symb s -> fprintf fmt "(SymbInt %s)" s
  | Var x -> fprintf fmt "(Var %s)" x
  | Val v -> fprintf fmt "(Val %a)" (Value.pp ~no_values:false) v
  | Unop (op, v) -> fprintf fmt "(%a %a)" pp_unop op pp v
  | Binop (op, v1, v2) -> fprintf fmt "(%a %a %a)" pp_binop op pp v1 pp v2
  | Ite (e1, e2, e3) -> fprintf fmt "(%a %a %a)" pp e1 pp e2 pp e3

let to_string (e : t) : string = Fmt.asprintf "%a" pp e
