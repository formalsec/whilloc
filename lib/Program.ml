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
        | Symbol      of string * string

type func = {
  id   : string;
  args : string list;
  body : stmt;
}

type program = (string, func) Hashtbl.t

(* Helper functions *)

let make_fresh_symb_generator (pref : string) : (unit -> string) =
  let count = ref 1 in
  fun () -> let x = !count in
    count := x+1; pref ^ (string_of_int x)

let generate_fresh_var = make_fresh_symb_generator "§_"

let make_symb_value (name : string) : Expression.value = (*X̂x̂*)
  SymbVal ( generate_fresh_var() ^ "__" ^ name)

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
  | Return e     -> "Return: " ^ "return " ^ Expression.string_of_expression e ^ "\n"
  | Assert e     -> "Assert: " ^ Expression.string_of_expression e ^ ")\n"
  | Assume e     -> "Assume: " ^ Expression.string_of_expression e ^ ")\n"
  | Clear        -> "Clear\n"
  | Print  es    -> "Print: "  ^ String.concat ", " (List.map (fun e -> Expression.string_of_expression e) es) ^ ")\n"
  | Symbol (s,v) -> "Symbol declaration: " ^ s ^ "=" ^ v ^ "\n"

let print_statement (s : stmt) : unit =
  s |> string_of_stmt |> print_endline
