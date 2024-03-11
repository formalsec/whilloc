type stmt =
  | Skip
  | Assign of string * Term.t
  | Sequence of stmt list
  | FunCall of string * string * Term.t list
  | IfElse of Term.t * stmt * stmt
  | While of Term.t * stmt
  | Return of Term.t
  | Assert of Term.t
  | Assume of Term.t
  | Clear
  | Print of Term.t list
  | Symbol_bool of string * string
  | Symbol_int of string * string
  | Symbol_int_c of string * string * Term.t
  | New of string * Term.t
  | Update of string * Term.t * Term.t
  | LookUp of string * string * Term.t
  | Delete of string
[@@deriving yojson]

type func = { id : string; args : string list; body : stmt }
type program = (string, func) Hashtbl.t

(* Helper functions *)

let get_function (id : string) (prog : program) : func =
  try Hashtbl.find prog id
  with _ ->
    failwith ("NameError: Program.get_function, name " ^ id ^ " is not defined")

let rec pp_stmt (fmt : Fmt.t) (s : stmt) : unit =
  let open Fmt in
  match s with
  | Skip -> fprintf fmt "Skip"
  | Clear -> fprintf fmt "Clear@\n"
  | Assign (x, e) -> fprintf fmt "Assignment: %s = %a" x Term.pp e
  | Symbol_bool (s, v) ->
      fprintf fmt "Boolean Symbol declaration: name=%s, value=§__%s" s v
  | Symbol_int (s, v) ->
      fprintf fmt "Integer Symbol declaration: name=%s, value=§__%s" s v
  | Symbol_int_c (s, v, e) ->
      fprintf fmt "Integer Symbol declaration: name=%s, value=§__%s, cond=%a" s
        v Term.pp e
  | Sequence s -> fprintf fmt "Sequence:@\n  %a" (pp_lst ~pp_sep:(fun fmt () -> fprintf fmt "@\n ") pp_stmt) s
  | Return e -> fprintf fmt "Return: %a" Term.pp e
  | Assert e -> fprintf fmt "Assert: %a" Term.pp e
  | Assume e -> fprintf fmt "Assume: %a" Term.pp e
  | Print exprs -> fprintf fmt "Print:  %a" (pp_lst ~pp_sep:pp_comma Term.pp) exprs
  | IfElse (expr, s1, s2) ->
      fprintf fmt "If (%a)@\n  %a@\nElse@\n  %a" Term.pp expr pp_stmt s1 pp_stmt s2
  | FunCall (x, f, args) ->
      fprintf fmt "Function Call: %s=%s(%a)" x f (pp_lst ~pp_sep:pp_comma Term.pp) args
  | While (expr, s) -> fprintf fmt "While (%a)@\n   %a" Term.pp expr pp_stmt s
  | New (arr, sz) -> fprintf fmt "New array: %s has size %a" arr Term.pp sz
  | Update (arr, e1, e2) ->
      fprintf fmt "Update: %s at loc %a is assigned %a" arr Term.pp e1 Term.pp
        e2
  | LookUp (x, arr, e) ->
      fprintf fmt "LookUp: %s is assigned the value at loc %a from arr %s" x
        Term.pp e arr
  | Delete arr -> fprintf fmt "Delete: %s" arr

let string_of_stmt (s : stmt) : string = Format.asprintf "%a" pp_stmt s

let pp_func (fmt : Fmt.t) (f : func) : unit =
  let open Fmt in
  fprintf fmt " Function id: %s@\nArguments  : (%a)@\nBody       : %a@\n" f.id
    (pp_lst ~pp_sep:pp_comma pp_str) f.args pp_stmt f.body

let string_of_function (f : func) : string = Format.asprintf "%a" pp_func f
let print_statement (s : stmt) : unit = s |> string_of_stmt |> print_endline
let print_function (f : func) : unit = f |> string_of_function |> print_endline
