type uop = Neg | Not | Abs | StringOfInt

type bop = Plus | Minus | Times | Div | Modulo | Pow | Or | And | Xor | ShiftL | ShiftR | Gt | Lt | Gte | Lte | Equals | NEquals

(*type rop = Gt | Lt | Ge | LE | Eq | Ne*)

type t = Val     of Value.t
       | Var     of string
       | UnOp    of uop * t
       | BinOp   of bop * t * t
(*       | RelOp   of rop * t * t*)
       | SymbBool of string
       | SymbInt of string
       | ITE of t * t * t

let make_true  : t = Val (Value.Boolean (true))
let make_false : t = Val (Value.Boolean (false))

let make_symb_bool (name : string) : t =
  SymbBool name

let make_symb_int (name : string) : t =
  SymbInt name

let make_uoperation (op : uop) (e : t) : t =
  UnOp (op, e)

let make_boperation (op : bop) (e1 : t) (e2 : t) : t =
  BinOp (op, e1, e2)

let negate (e : t) : t =
  UnOp (Not, e)

let get_value_from_expr (e : t) : Value.t =
  match e with
  | Val v -> v
  | _     -> failwith "InternalError: Expression.get_value_from_expr, tried to retrieve a value from a non value constructor"

let rec flatten (e : t) : t list =
  match e with
  | UnOp  (_, e)      -> flatten e
  | BinOp (_, e1, e2) -> (flatten e1) @ (flatten e2)
  | _ -> [e]

let rec get_symbols (e : t) : string list =
  match e with
  | SymbBool b -> [b]
  | SymbInt i -> [i]
  | Val _ -> []
  | Var _ -> []
  | UnOp  (_, e)      -> get_symbols e
  | BinOp (_, e1, e2) -> (get_symbols e1) @ (get_symbols e2)
  | ITE (e1, e2, e3) -> get_symbols e1 @ get_symbols e2 @ get_symbols e3

let string_of_uop (op : uop) : string =
  match op with
    | Neg -> "-"
    | Not -> "!"
    | Abs -> "abs"
    | StringOfInt -> "stoi"

let string_of_bop (op : bop) : string =
  match op with
    | Plus    -> "+"
    | Minus   -> "-"
    | Times   -> "*"
    | Div     -> "/"
    | Modulo  -> "%"
    | Pow     -> "^"
    | Gt      -> ">"
    | Lt      -> "<"
    | Gte     -> ">="
    | Lte     -> "<="
    | Equals  -> "=="
    | NEquals -> "!="
    | Or      -> "OR"  (* ∨ *)
    | And     -> "AND" (* ∧ *)
    | Xor     -> "⊕"
    | ShiftL  -> "<<"
    | ShiftR  -> ">>"

let rec string_of_expression (e : t) : string =
  "(" ^
  (match e with
  | SymbBool s -> "SymbBool " ^ s
  | SymbInt s -> "SymbInt " ^ s
  | Var x -> "Var " ^ x
  | Val v -> "Val " ^ Value.string_of_value v
  | UnOp  (op, v)      -> (string_of_uop op) ^ (string_of_expression v)
  | BinOp (op, v1, v2) -> (string_of_expression v1) ^ " " ^ (string_of_bop op) ^ " " ^ (string_of_expression v2) 
  | ITE (e1, e2, e3) ->
    string_of_expression e1 ^ " " ^ string_of_expression e2 ^ " "
    ^ string_of_expression e3)
  ^ ")"

let print_expression (e : t) : unit =
  (string_of_expression e ^ " ") |> print_string
