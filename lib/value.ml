type t =
  | Integer of int
  | Boolean of bool
  | Loc of int
  | Error
[@@deriving yojson]

let pp ?(no_values = false) fmt (v : t) =
  let open Fmt in
  match v with
  | Integer n ->
    if no_values then fprintf fmt "Int _" else fprintf fmt "Int %d" n
  | Boolean b ->
    if no_values then fprintf fmt "Bool _ " else fprintf fmt "Bool %b" b
  | Loc l -> if no_values then fprintf fmt "Loc _ " else fprintf fmt "Loc %d" l
  | Error -> pp_print_string fmt "Error"

let to_string = Fmt.asprintf "%a" (pp ~no_values:false)
