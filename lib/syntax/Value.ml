type t = Integer of int
       | Boolean of bool
       | SymbVal of string

let string_of_value (v : t) : string =
  match v with
  | Integer n -> "Int "     ^ (string_of_int n)
  | Boolean b -> "Bool "    ^ (string_of_bool b)
  | SymbVal x -> "Symb " ^ x

let print_value (v : t) : unit =
  (string_of_value v ^ " ") |> print_string
