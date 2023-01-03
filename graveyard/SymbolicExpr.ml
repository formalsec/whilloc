open Expression

type expr = ConcreteValue of Expression.value
           | SymbolicValue of string
           | UnOp          of uop * expr
           | BinOp         of bop * expr * expr

let rec string_of_symb (v : expr) : string =
  match v with
    | ConcreteValue  x -> "ConcreteValue " ^ (string_of_value x)
    | SymbolicValue  s -> "SymbolicValue " ^ s
    | UnOp  (op, v)      -> (string_of_uop op)  ^ (string_of_symb v)
    | BinOp (op, v1, v2) -> (string_of_symb v1) ^ (string_of_bop op) ^ (string_of_symb v2)

let get_value (v : expr option) : expr =
  match v with
  | None   -> failwith "InternalError: tried to retrieve a symbolic value from None" 
  | Some v -> v

let make_fresh_symb_generator (pref : string) : (unit -> string) =
  let count = ref 0 in
  fun () -> let x = !count in
    count := x+1; pref ^ (string_of_int x)

let generate_fresh_symb = make_fresh_symb_generator "x̂_" (*X̂x̂*)

(*Symbolic expressions arithmetic*)

let simplify_expr (symb_val : expr) : expr =
  symb_val (*TODO*)