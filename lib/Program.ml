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

let rec pp (fmt : Fmt.t) (s : stmt) : unit =
  let open Fmt in
  match s with
  | Skip -> fprintf fmt "Skip"
  | Clear -> fprintf fmt "Clear@."
  | Assign (x, e) -> fprintf fmt "Assignment: %s = %a" x Term.pp e
  | Symbol_bool (s, v) ->
      fprintf fmt "Boolean Symbol declaration: name=%s, value=§__%s" s v
  | Symbol_int (s, v) ->
      fprintf fmt "Integer Symbol declaration: name=%s, value=§__%s" s v
  | Symbol_int_c (s, v, e) ->
      fprintf fmt "Integer Symbol declaration: name=%s, value=§__%s, cond=%a" s
        v Term.pp e
  | Sequence s -> fprintf fmt "Sequence:@.  %a" (pp_lst "\n  " pp) s
  | Return e -> fprintf fmt "Return: %a" Term.pp e
  | Assert e -> fprintf fmt "Assert: %a" Term.pp e
  | Assume e -> fprintf fmt "Assume: %a" Term.pp e
  | Print exprs -> fprintf fmt "Print:  %a" (pp_lst ", " Term.pp) exprs
  | IfElse (expr, s1, s2) ->
      fprintf fmt "If (%a)@.  %a@.Else@.  %a" Term.pp expr pp s1 pp s2
  | FunCall (x, f, args) ->
      fprintf fmt "Function Call: %s=%s(%a)" x f (pp_lst ", " Term.pp) args
  | While (expr, s) -> fprintf fmt "While (%a)@\n   %a" Term.pp expr pp s
  | New (arr, sz) -> fprintf fmt "New array: %s has size %a" arr Term.pp sz
  | Update (arr, e1, e2) ->
      fprintf fmt "Update: %s at loc %a is assigned %a" arr Term.pp e1 Term.pp
        e2
  | LookUp (x, arr, e) ->
      fprintf fmt "LookUp: %s is assigned the value at loc %a from arr %s" x
        Term.pp e arr
  | Delete arr -> fprintf fmt "Delete: %s" arr

let string_of_stmt (s : stmt) : string = Format.asprintf "%a" pp s

let string_of_function (f : func) : string =
  "Function id: " ^ f.id ^ "\n" ^ "Argumetns  : (" ^ String.concat ", " f.args
  ^ ")\n" ^ "Body       : " ^ string_of_stmt f.body ^ "\n"

let print_statement (s : stmt) : unit = s |> string_of_stmt |> print_endline
let print_function (f : func) : unit = f |> string_of_function |> print_endline
