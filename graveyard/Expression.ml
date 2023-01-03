type uop = Neg | Not | Abs | StringOfInt

type bop = Plus | Minus | Times | Div | Modulo | Pow | Gt | Lt | Gte | Lte | Equals | NEquals

type expr = Concrete of int
          | Symbolic of int

let string_of_uop (op : uop) : string =
  match op with
    | Neg -> "-"
    | Not -> "~"
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

(*let string_of_expression (e : expr) : string =
  match e with
  | ConcreteExpr c -> string_of_cexpression c
  | SymbolicExpr s -> string_of_sexpression s*)