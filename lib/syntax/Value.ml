type t = Integer of int
       | Boolean of bool
       | Loc     of int
       | Error

let string_of_value (v : t) : string =
  match v with
  | Integer n -> "Int "  ^ (string_of_int n)
  | Boolean b -> "Bool " ^ (string_of_bool b)
  | Loc     l -> "Loc "  ^ (string_of_int l)
  | Error     -> "Error"

let print_value (v : t) : unit =
  (string_of_value v ^ " ") |> print_string
