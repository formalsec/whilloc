type uop = Neg | Not | Abs | StringOfInt

type bop = Plus | Minus | Times | Div | Modulo | Pow | Gt | Lt | Gte | Lte | Equals | NEquals | Or | And | Xor | ShiftL | ShiftR

type value = Number  of int
           | Boolean of bool

type expr = Var     of string
          | Val     of value    
          | UnOp    of uop * expr
          | BinOp   of bop * expr * expr
          | SymbVal of string

let make_symb_value (name : string) : expr = (*X̂x̂*)
  SymbVal ("X̂__"  ^ name)

let get_value_from_expr (e : expr) : value =
  match e with
  | Val v -> v
  | _     -> failwith "InternalError: Expression.get_value_from_expr, tried to retrieve a value from a non value constructor" 

let get_expr_from_opt (e : expr option) : expr =
  match e with
  | Some s -> s
  | None   ->  failwith "InternalError: Expression.get_expr_from_opt, tried to retrieve an expression from None"

let is_true (v : value) : bool =
  match v with
  | Number  n -> if n!=0 then true else false
  | Boolean b -> b

let neg (v : value) : value = match v with
| (Number n) -> Number (-1*n)
| _                -> invalid_arg "Exception in Oper.neg: this operation is only applicable to Number arguments"
let not_ (v : value) : value = match v with
| (Boolean b) -> Boolean (not b)
| _                -> invalid_arg "Exception in Oper.neg: this operation is only applicable to Boolean arguments"
let abs (v : value) : value = match v with
| (Number n)  -> Number (abs(n))
| _                -> invalid_arg "Exception in Oper.neg: this operation is only applicable to Number arguments"
let stoi (v : value) : value = match v with
| _                -> invalid_arg "Exception in Oper.stoi: language does not support strings yet"

let plus (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2) -> Number (n1 + n2)
| _                      -> invalid_arg "Exception in Oper.plus: this operation is only applicable to Number arguments"
let minus (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2) -> Number (n1 - n2)
| _                      -> invalid_arg "Exception in Oper.minus: this operation is only applicable to Number arguments"
let times (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2) -> Number (n1 * n2)
| _                      -> invalid_arg "Exception in Oper.times: this operation is only applicable to Number arguments"
let div (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2) -> Number (n1 / n2)
| _                      -> invalid_arg "Exception in Oper.div: this operation is only applicable to Number arguments"
let modulo (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2) -> Number (n1 mod n2)
| _                      -> invalid_arg "Exception in Oper.modulo: this operation is only applicable to Number arguments"
let pow (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2) -> Number (n1*n2) (*TODO*)
| _                      -> invalid_arg "Exception in Oper.modulo: this operation is only applicable to Number arguments"
let equal (v1, v2 : value * value) : value = match v1, v2 with
| (Number  n1, Number n2)  -> Boolean (n1=n2)
| (Boolean b1, Boolean b2) -> Boolean (b1=b2)
| _                        -> invalid_arg "Exception in Oper.equal: this operation is only applicable to Number or Boolean arguments"
let nequal (v1, v2 : value * value) : value = match v1, v2 with
| (Number  n1, Number n2)  -> Boolean (n1!=n2)
| (Boolean b1, Boolean b2) -> Boolean (b1!=b2)
| _                        -> invalid_arg "Exception in Oper.equal: this operation is only applicable to Number or Boolean arguments"
let gt (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2) -> Boolean (n1>n2)
| _                      -> invalid_arg "Exception in Oper.gt: this operation is only applicable to Number arguments"
let lt (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2) -> Boolean (n1<n2)
| _                      -> invalid_arg "Exception in Oper.lt: this operation is only applicable to Number arguments"
let gte (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2)   -> Boolean (n1>=n2)
| _                        -> invalid_arg "Exception in Oper.gte: this operation is only applicable to Number arguments"
let lte (v1, v2 : value * value) : value = match v1, v2 with
| (Number  n1, Number  n2) -> Boolean (n1<=n2)
| _                        -> invalid_arg "Exception in Oper.lte: this operation is only applicable to Number arguments"
let or_ (v1, v2 : value * value) : value = match v1, v2 with
| (Boolean b1, Boolean b2) -> Boolean (b1||b2)
| _                        -> invalid_arg "Exception in Oper.or: this operation is only applicable to Boolean arguments"
let and_ (v1, v2 : value * value) : value = match v1, v2 with
| (Boolean b1, Boolean b2) -> Boolean (b1&&b2)
| _                        -> invalid_arg "Exception in Oper.and: this operation is only applicable to Boolean arguments"
let xor (v1, v2 : value * value) : value = match v1, v2 with
| (Boolean b1, Boolean b2) -> Boolean ( (b1 || b2) && (not b1 || not b2) )
| _                        -> invalid_arg "Exception in Oper.xor: this operation is only applicable to Boolean arguments"
let shl (v1, v2 : value * value) : value = match v1, v2 with
| (Number  n1, Number  n2) -> Number (n1+n2) (*TODO*)
| _                        -> invalid_arg "Exception in Oper.shl: this operation is only applicable to Number arguments"
let shr (v1, v2 : value * value) : value = match v1, v2 with
| (Number  n1, Number  n2) -> Number (n1+n2) (*TODO*)
| _                        -> invalid_arg "Exception in Oper.shr: this operation is only applicable to Number arguments"

let string_of_uop (op : uop) : string =
  match op with
    | Neg -> "-"
    | Not -> "!"
    | Abs -> "abs"
    | StringOfInt -> "stoi"

let string_of_bop (op : bop) : string =
  match op with
    | Plus    -> "+"
    | Minus   -> "-"
    | Times   -> "*"
    | Div     -> "/"
    | Modulo  -> "%"
    | Pow     -> "^"
    | Gt      -> ">"
    | Lt      -> "<"
    | Gte     -> ">="
    | Lte     -> "<="
    | Equals  -> "=="
    | NEquals -> "!="
    | Or      -> "∨"
    | And     -> "∧"
    | Xor     -> "⊕"
    | ShiftL  -> "<<"
    | ShiftR  -> ">>"

let string_of_value (v : value) : string =
  match v with
  | Number  n -> "Number "  ^ (string_of_int n)
  | Boolean b -> "Boolean " ^ (string_of_bool b)

let rec string_of_expression (e : expr) : string =
  match e with
  | Var x -> "Variable " ^ x (*^ " = " ^ string_of_value( Expression.eval_expression store e ) if I move the 'expressions' logic to the Expression module... *)
  | Val v -> "Value (" ^ string_of_value v ^ ")"
  | UnOp  (op, v)      -> (string_of_uop op) ^ (string_of_expression v)
  | BinOp (op, v1, v2) -> (string_of_expression v1) ^ " " ^ (string_of_bop op) ^ " " ^ (string_of_expression v2)
  | SymbVal x -> "Symbol value (" ^ x ^ ")"
  
let print_value (v : value) : unit =
  (string_of_value v ^ " ") |> print_string

let print_expression (e : expr) : unit =
  (string_of_expression e ^ " ") |> print_string
