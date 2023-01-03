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
  | Skip -> "skip"
  | Assign (x,e) -> "Assignment:\n" ^ x ^ "=" ^ (Expression.string_of_expression e)
  | Sequence s -> "Sequence:\n" ^ String.concat ";\n" (List.map string_of_stmt s)
  | FunCall (x,f,args) -> "FunCall:\n" ^ x ^ "=" ^ f ^ "(" ^ String.concat ", " (List.map (fun e -> Expression.string_of_expression e) args) ^ ")"
  | IfElse (expr, s1, s2) -> "IfElse:\n" ^ "if (" ^ (Expression.string_of_expression expr) ^ ")\n  " ^ string_of_stmt s1 ^ "\nelse\n  " ^ string_of_stmt s2
  | While (expr, s) -> "While:\n" ^ "while (" ^ Expression.string_of_expression expr ^ ")\n   " ^ string_of_stmt s 
  | Return e  -> "Return:\n" ^ "return " ^ Expression.string_of_expression e
  | Assert e  -> "Assert:\n" ^ "assert(" ^ Expression.string_of_expression e ^ ")"
  | Assume e  -> "Assume:\n" ^ "assume(" ^ Expression.string_of_expression e ^ ")"
  | Clear     -> "Clear:\n"  ^ "clear"
  | Print  es -> "Print:\n"  ^ "print(" ^ String.concat ", " (List.map (fun e -> Expression.string_of_expression e) es) ^ ")"
  | Symbol s  -> "Symbol declaration: " ^ s ^ "\n"

let print_statement (s : stmt) : unit =
  s |> string_of_stmt |> print_endline
