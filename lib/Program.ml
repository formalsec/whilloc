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

type func = { id : string; args : string list; body : stmt }
type program = (string, func) Hashtbl.t

(* Helper functions *)

let get_function (id : string) (prog : program) : func =
  try Hashtbl.find prog id
  with _ ->
    failwith ("NameError: Program.get_function, name " ^ id ^ " is not defined")

let rec string_of_stmt (s : stmt) : string =
  match s with
  | Skip -> "Skip\n"
  | Clear -> "Clear\n"
  | Assign (x, e) -> Format.asprintf "Assignment: %s = %a\n" x Term.pp e
  | Symbol_bool (s, v) ->
      Format.asprintf "Boolean Symbol declaration: name=%s, value=§__%s\n" s v
  | Symbol_int (s, v) ->
      "Integer Symbol declaration: name=" ^ s ^ ", value=§__" ^ v ^ "\n"
  | Symbol_int_c (s, v, e) ->
      Format.asprintf
        "Integer Symbol declaration: name=%s, value=§__%s, cond=%a" s v Term.pp
        e ^ "\n"
  | Sequence s ->
      "Sequence:\n  " ^ String.concat "  " (List.map string_of_stmt s)
  | Return e -> Format.asprintf "Return: %a" Term.pp e ^ "\n"
  | Assert e -> Format.asprintf "Assert: %a" Term.pp e ^ "\n"
  | Assume e -> Format.asprintf "Assume: %a" Term.pp e ^ "\n"
  | Print exprs ->
      "Print:  "
      ^ String.concat ", " (List.map (fun e -> Term.to_string e) exprs)
  | IfElse (expr, s1, s2) ->
      "If (" ^ Term.to_string expr ^ ")\n  " ^ string_of_stmt s1 ^ "\nElse\n  "
      ^ string_of_stmt s2
  | FunCall (x, f, args) ->
      "Function Call: " ^ x ^ "=" ^ f ^ "("
      ^ String.concat ", " (List.map (fun e -> Term.to_string e) args)
  | While (expr, s) ->
      "While (" ^ Term.to_string expr ^ ")\n   " ^ string_of_stmt s
  | New (arr, sz) -> "New array: " ^ arr ^ " has size " ^ Term.to_string sz ^ "\n"
  | Update (arr, e1, e2) ->
      "Update: " ^ arr ^ " at loc " ^ Term.to_string e1 ^ " is assigned "
      ^ Term.to_string e2 ^ "\n"
  | LookUp (x, arr, e) ->
      "LookUp: " ^ x ^ " is assigned the value at loc " ^ Term.to_string e
      ^ " from arr " ^ arr ^ "\n"
  | Delete arr -> "Delete: " ^ arr ^ "\n"

let string_of_function (f : func) : string =
  "Function id: " ^ f.id ^ "\n" ^ "Argumetns  : (" ^ String.concat ", " f.args
  ^ ")\n" ^ "Body       : " ^ string_of_stmt f.body ^ "\n"

let print_statement (s : stmt) : unit = s |> string_of_stmt |> print_endline
let print_function (f : func) : unit = f |> string_of_function |> print_endline
