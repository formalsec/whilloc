type stmt = Skip
        | Assign      of string * Expression.expr
        | Sequence    of stmt list
        | FunCall     of string * string * Expression.expr list
        | IfElse      of Expression.expr * stmt * stmt
        | While       of Expression.expr * stmt
        | Return      of Expression.expr
        | Assert      of Expression.expr
        | Assume      of Expression.expr
        | Clear
        | Print       of Expression.expr list
        | Symbol      of string

type func = {
  id   : string;
  args : string list;
  body : stmt;
}

type program = (string, func) Hashtbl.t

(* Helper functions *)

let get_symb_id (s : stmt) : string = 
  match s with
  | Symbol x -> x
  | _        -> failwith "InternalError: tried to get the id from a supposedely symbolic variable" 

let sequence_content (s : stmt) : stmt list =
  match s with
  | Sequence seq -> seq
  | _            -> failwith "InternalError: tried to retrieve a statements carried along with a \"Sequence\" constructor from a non sequence constructor" 

let get_function (id : string) (p : program) : func =
  try Hashtbl.find p id
  with _ -> failwith ("NameError: name " ^ id ^ " is not defined")

let rec string_of_stmt (s : stmt) : string =
  match s with
  | Skip -> "Skip\n"
  | Assign (x,e) -> "Assignment: " ^ x ^ "=" ^ (Expression.string_of_expression e) ^ "\n"
  | Sequence s -> "Sequence:\n" ^ String.concat "" (List.map string_of_stmt s)
  | FunCall (x,f,args) -> "FunCall: " ^ x ^ "=" ^ f ^ "(" ^ String.concat ", " (List.map (fun e -> Expression.string_of_expression e) args) ^ ")\n"
  | IfElse (expr, s1, s2) -> "If (" ^ (Expression.string_of_expression expr) ^ ")\n  " ^ string_of_stmt s1 ^ "\nElse\n  " ^ string_of_stmt s2 ^ "\n"
  | While (expr, s) -> "While (" ^ Expression.string_of_expression expr ^ ")\n   " ^ string_of_stmt s ^ "\n"
  | Return e  -> "Return: " ^ "return " ^ Expression.string_of_expression e ^ "\n"
  | Assert e  -> "Assert: " ^ Expression.string_of_expression e ^ ")\n"
  | Assume e  -> "Assume: " ^ Expression.string_of_expression e ^ ")\n"
  | Clear     -> "Clear\n"
  | Print  es -> "Print: "  ^ String.concat ", " (List.map (fun e -> Expression.string_of_expression e) es) ^ ")\n"
  | Symbol s  -> "Symbol declaration: " ^ s ^ "\n"

let print_statement (s : stmt) : unit =
  s |> string_of_stmt |> print_endline
