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
            (* exception NameError of string * string (id, message to be shown). this is also used in Store.ml *)
let rec string_of_stmt (s : stmt) : string =
  match s with
  | Skip         -> "Skip"
  | Clear        -> "Clear\n"
  | Assign (x,e) -> "Assignment: " ^ x ^ "=" ^ (Expression.string_of_expression e)
  | Symbol (s,v) -> "Symbol declaration: name=" ^ s ^ ", value=§__" ^ v
  | Sequence s   -> "Sequence:\n  " ^ String.concat "  " (List.map string_of_stmt s)
  | Return e     -> "Return: " ^ Expression.string_of_expression e
  | Assert e     -> "Assert: " ^ Expression.string_of_expression e
  | Assume e     -> "Assume: " ^ Expression.string_of_expression e
  | Print  exprs -> "Print:  " ^ String.concat ", " (List.map (fun e -> Expression.string_of_expression e) exprs)
  | IfElse  (expr, s1, s2) -> "If (" ^ (Expression.string_of_expression expr) ^ ")\n  " ^ string_of_stmt s1 ^ "\nElse\n  " ^ string_of_stmt s2
  | FunCall (x,f,args)     -> "Function Call: " ^ x ^ "=" ^ f ^ "(" ^ String.concat ", " (List.map (fun e -> Expression.string_of_expression e) args)
  | While   (expr, s)      -> "While (" ^ Expression.string_of_expression expr ^ ")\n   " ^ string_of_stmt s

let print_statement (s : stmt) : unit =
  s |> string_of_stmt |> print_endline
