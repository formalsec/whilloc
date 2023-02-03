type uop = Neg | Not | Abs | StringOfInt

type bop = Plus | Minus | Times | Div | Modulo | Pow | Gt | Lt | Gte | Lte | Equals | NEquals | Or | And | Xor | ShiftL | ShiftR

type t = Val     of Value.t
       | Var     of string 
       | UnOp    of uop * t
       | BinOp   of bop * t * t

let negate_expression (e : t) : t = 
  UnOp (Not, e)

let get_value_from_expr (e : t) : Value.t =
  match e with
  | Val v -> v
  | _     -> failwith "InternalError: Expression.get_value_from_expr, tried to retrieve a value from a non value constructor" 

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
    | Or      -> "OR" (* ∨ *)
    | And     -> "∧"
    | Xor     -> "⊕"
    | ShiftL  -> "<<"
    | ShiftR  -> ">>"

let rec string_of_expression (e : t) : string =
  "(" ^
  match e with
  | Var x -> "Var " ^ x  (*^ " = " ^ string_of_value( Expression.eval_expression store e ) if I move the 'expressions' logic to the Expression module... *)
  | Val v -> "Val " ^ Value.string_of_value v
  | UnOp  (op, v)      -> (string_of_uop op) ^ (string_of_expression v)
  | BinOp (op, v1, v2) -> (string_of_expression v1) ^ " " ^ (string_of_bop op) ^ " " ^ (string_of_expression v2)
  ^ ")"

let print_expression (e : t) : unit =
  (string_of_expression e ^ " ") |> print_string
