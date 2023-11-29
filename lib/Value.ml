type t = Integer of int | Boolean of bool | Loc of int | Error

let pp fmt (v : t) =
  match v with
  | Integer n -> Format.fprintf fmt "Int %d" n
  | Boolean b -> Format.fprintf fmt "Bool %b" b
  | Loc l -> Format.fprintf fmt "Loc %d" l
  | Error -> Format.pp_print_string fmt "Error"

let to_string = Format.asprintf "%a" pp
