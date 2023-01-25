type uop = Neg | Not | Abs | StringOfInt

type bop = Plus | Minus | Times | Div | Modulo | Pow | Gt | Lt | Gte | Lte | Equals | NEquals | Or | And | Xor | ShiftL | ShiftR

type value = Integer of int
           | Boolean of bool
           | SymbVal of string

type expr = Val     of value
          | Var     of string 
          | UnOp    of uop * expr
          | BinOp   of bop * expr * expr

let negate_expression (e : expr) : expr = 
  UnOp (Not, e)

let get_value_from_expr (e : expr) : value =
  match e with
  | Val v -> v
  | _     -> failwith "InternalError: Expression.get_value_from_expr, tried to retrieve a value from a non value constructor" 

let is_true (v : value) : bool =
  match v with
  | Integer n -> if n!=0 then true else false
  | Boolean b -> b
  | SymbVal _ -> failwith "InternalError: Expression.is_true, Symbolic Values cannot be true or false at the level of the evaluation of expressions"

let neg (v : value) : value = match v with
| (Integer n) -> Integer (-1*n)
| _           -> invalid_arg "Exception in Oper.neg: this operation is only applicable to Integer arguments"
let not_ (v : value) : value = match v with
| (Boolean b) -> Boolean (not b)
| _           -> invalid_arg "Exception in Oper.neg: this operation is only applicable to Boolean arguments"
let abs (v : value) : value = match v with
| (Integer n)  -> Integer (abs(n))
| _            -> invalid_arg "Exception in Oper.neg: this operation is only applicable to Integer arguments"
let stoi (v : value) : value = match v with
| _                -> invalid_arg "Exception in Oper.stoi: language does not support strings yet"

let plus (v1, v2 : value * value) : value = match v1, v2 with
| (Integer n1, Integer n2) -> Integer (n1 + n2)
| _                        -> invalid_arg "Exception in Oper.plus: this operation is only applicable to Integer arguments"
let minus (v1, v2 : value * value) : value = match v1, v2 with
| (Integer n1, Integer n2) -> Integer (n1 - n2)
| _                        -> invalid_arg "Exception in Oper.minus: this operation is only applicable to Integer arguments"
let times (v1, v2 : value * value) : value = match v1, v2 with
| (Integer n1, Integer n2) -> Integer (n1 * n2)
| _                        -> invalid_arg "Exception in Oper.times: this operation is only applicable to Integer arguments"
let div (v1, v2 : value * value) : value = match v1, v2 with
| (Integer n1, Integer n2) -> Integer (n1 / n2)
| _                        -> invalid_arg "Exception in Oper.div: this operation is only applicable to Integer arguments"
let modulo (v1, v2 : value * value) : value = match v1, v2 with
| (Integer n1, Integer n2) -> Integer (n1 mod n2)
| _                        -> invalid_arg "Exception in Oper.modulo: this operation is only applicable to Integer arguments"
let pow (v1, v2 : value * value) : value = match v1, v2 with
| (Integer n1, Integer n2) -> Integer (n1*n2) (*TODO*)
| _                        -> invalid_arg "Exception in Oper.modulo: this operation is only applicable to Integer arguments"
let equal (v1, v2 : value * value) : value = match v1, v2 with
| (Integer  n1, Integer n2) -> Boolean (n1=n2)
| (Boolean b1, Boolean b2)  -> Boolean (b1=b2)
| _                         -> invalid_arg "Exception in Oper.equal: this operation is only applicable to Integer or Boolean arguments"
let nequal (v1, v2 : value * value) : value = match v1, v2 with
| (Integer  n1, Integer n2) -> Boolean (n1!=n2)
| (Boolean b1, Boolean b2)  -> Boolean (b1!=b2)
| _                         -> invalid_arg "Exception in Oper.equal: this operation is only applicable to Integer or Boolean arguments"
let gt (v1, v2 : value * value) : value = match v1, v2 with
| (Integer n1, Integer n2) -> Boolean (n1>n2)
| _                        -> invalid_arg "Exception in Oper.gt: this operation is only applicable to Integer arguments"
let lt (v1, v2 : value * value) : value = match v1, v2 with
| (Integer n1, Integer n2) -> Boolean (n1<n2)
| _                        -> invalid_arg "Exception in Oper.lt: this operation is only applicable to Integer arguments"
let gte (v1, v2 : value * value) : value = match v1, v2 with
| (Integer n1, Integer n2) -> Boolean (n1>=n2)
| _                        -> invalid_arg "Exception in Oper.gte: this operation is only applicable to Integer arguments"
let lte (v1, v2 : value * value) : value = match v1, v2 with
| (Integer  n1, Integer  n2) -> Boolean (n1<=n2)
| _                          -> invalid_arg "Exception in Oper.lte: this operation is only applicable to Integer arguments"
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
| (Integer  n1, Integer  n2) -> Integer (n1+n2) (*TODO*)
| _                          -> invalid_arg "Exception in Oper.shl: this operation is only applicable to Integer arguments"
let shr (v1, v2 : value * value) : value = match v1, v2 with
| (Integer  n1, Integer  n2) -> Integer (n1+n2) (*TODO*)
| _                          -> invalid_arg "Exception in Oper.shr: this operation is only applicable to Integer arguments"

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
    | Or      -> "OR"
    | And     -> "∧"
    | Xor     -> "⊕"
    | ShiftL  -> "<<"
    | ShiftR  -> ">>"

let string_of_value (v : value) : string =
  match v with
  | Integer n -> "Int "  ^ (string_of_int n)
  | Boolean b -> "Bool " ^ (string_of_bool b)
  | SymbVal x -> x

let rec string_of_expression (e : expr) : string =
  "(" ^
  match e with
  | Var x -> "Var " ^ x (*^ " = " ^ string_of_value( Expression.eval_expression store e ) if I move the 'expressions' logic to the Expression module... *)
  | Val v -> "Val " ^ string_of_value v ^ ")"
  | UnOp  (op, v)      -> (string_of_uop op) ^ (string_of_expression v) ^ ")"
  | BinOp (op, v1, v2) -> (string_of_expression v1) ^ " " ^ (string_of_bop op) ^ " " ^ (string_of_expression v2) ^ ")"

let print_value (v : value) : unit =
  (string_of_value v ^ " ") |> print_string

let print_expression (e : expr) : unit =
  (string_of_expression e ^ " ") |> print_string
