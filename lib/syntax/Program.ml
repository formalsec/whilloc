type stmt = Skip
          | Assign      of string * Expression.t
          | Sequence    of stmt list
          | FunCall     of string * string * Expression.t list
          | IfElse      of Expression.t * stmt * stmt
          | While       of Expression.t * stmt
          | Return      of Expression.t
          | Assert      of Expression.t
          | Assume      of Expression.t
          | Clear
          | Print       of Expression.t list
          | Symbol      of string * string
          | Symbol_int  of string * string
          | New         of string * Expression.t
          | Update      of string * Expression.t * Expression.t
          | LookUp      of string * string * Expression.t
          | Delete      of string

type func = {
  id   : string;
  args : string list;
  body : stmt;
}

type program = (string, func) Hashtbl.t

(* Helper functions *)

let get_function (id : string) (prog : program) : func =
  try Hashtbl.find prog id
  with _ -> failwith ("NameError: Program.get_function, name " ^ id ^ " is not defined")

let rec string_of_stmt (s : stmt) : string =
  match s with
  | Skip         -> "Skip"
  | Clear        -> "Clear\n"
  | Assign (x,e) -> "Assignment: " ^ x ^ "=" ^ (Expression.string_of_expression e)
  | Symbol (s,v) -> "Symbol declaration: name=" ^ s ^ ", value=§__" ^ v
  | Symbol_int (s,v) -> "Symbol declaration: name=" ^ s ^ ", value=§__" ^ v
  | Sequence s   -> "Sequence:\n  " ^ String.concat "  " (List.map string_of_stmt s)
  | Return e     -> "Return: " ^ Expression.string_of_expression e
  | Assert e     -> "Assert: " ^ Expression.string_of_expression e
  | Assume e     -> "Assume: " ^ Expression.string_of_expression e
  | Print  exprs -> "Print:  " ^ String.concat ", " (List.map (fun e -> Expression.string_of_expression e) exprs)
  | IfElse  (expr, s1, s2) -> "If (" ^ (Expression.string_of_expression expr) ^ ")\n  " ^ string_of_stmt s1 ^ "\nElse\n  " ^ string_of_stmt s2
  | FunCall (x,f,args)     -> "Function Call: " ^ x ^ "=" ^ f ^ "(" ^ String.concat ", " (List.map (fun e -> Expression.string_of_expression e) args)
  | While   (expr, s)      -> "While (" ^ Expression.string_of_expression expr ^ ")\n   " ^ string_of_stmt s
  | New    (arr, sz)   -> "New array: " ^ arr ^ " has size " ^ (Expression.string_of_expression sz)
  | Update (arr,e1,e2) -> "Update: " ^ arr ^ " at loc " ^ (Expression.string_of_expression e1) ^ " is assigned " ^ (Expression.string_of_expression e2)
  | LookUp (x,arr,e)   -> "LookUp: " ^ x ^ " is assigned the value at loc " ^ (Expression.string_of_expression e) ^ " from arr " ^ arr
  | Delete arr -> "Delete: " ^ arr

let string_of_function (f : func) : string =
  "Function id: "  ^ f.id                      ^ "\n" ^
  "Argumetns  : (" ^ String.concat ", " f.args ^ ")\n" ^
  "Body       : "  ^ string_of_stmt f.body     ^ "\n"

let print_statement (s : stmt) : unit =
  s |> string_of_stmt |> print_endline

let print_function (f : func) : unit =
  f |> string_of_function |> print_endline
