type t = Integer of int
       | Boolean of bool
       | SymbVal of string

let is_symbolic_value (v : t) : bool =
  match v with
  | SymbVal _ -> true
  | _         -> false

let string_of_value (v : t) : string =
  match v with
  | Integer n -> "Int "     ^ (string_of_int n)
  | Boolean b -> "Bool "    ^ (string_of_bool b)
  | SymbVal x -> "Symb " ^ x

let print_value (v : t) : unit =
  (string_of_value v ^ " ") |> print_string
