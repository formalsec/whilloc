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
        | Print       of Expression.expr

type symb = Symbol of string

type func = {
  id   : string;
  args : string list;
  body : stmt;
}

type program = (string, func) Hashtbl.t

(* Helper functions *)

let sequence_content (s : stmt) : stmt list =
  match s with
  | Sequence seq -> seq
  | _            -> failwith "InternalError: tried to retrieve a statements carried along with a \"Sequence\" constructor from a non sequence constructor" 

let get_function (id : string) (p : program) : func =
  try Hashtbl.find p id
  with _ -> failwith ("NameError: name " ^ id ^ " is not defined")

let rec string_of_stmt (s : stmt) : string =
  match s with
  | Skip -> "skip"
  | Assign (x,e) -> x ^ "=" ^ (Expression.string_of_expression e)
  | Sequence s -> String.concat ";\n" (List.map string_of_stmt s)
  | FunCall (x,f,args) -> x ^ "=" ^ f ^ "(" ^ String.concat ", " (List.map (fun e -> Expression.string_of_expression e) args) ^ ")"
  | IfElse (expr, s1, s2) -> "if (" ^ (Expression.string_of_expression expr) ^ ")\n  " ^ string_of_stmt s1 ^ "\nelse\n  " ^ string_of_stmt s2
  | While (expr, s) -> "while (" ^ Expression.string_of_expression expr ^ ")\n   " ^ string_of_stmt s 
  | Return e -> "return " ^ Expression.string_of_expression e
  | Assert e -> "assert(" ^ Expression.string_of_expression e ^ ")"
  | Assume e -> "assume(" ^ Expression.string_of_expression e ^ ")"
  | Clear    -> "clear"
  | Print  e -> "print(" ^ Expression.string_of_expression e ^ ")"