type uop = Neg | Not | Abs | StringOfInt

type bop = Plus | Minus | Times | Div | Modulo | Pow | Gt | Lt | Gte | Lte | Equals | NEquals

type value = Number of int
        | Boolean   of bool

type expr = Var   of string
        | Val     of value    
        | UnOp    of uop * expr
        | BinOp   of bop * expr * expr

type stmt = Skip
        | Assign      of string * expr
        | Sequence    of stmt list
        | FunCall     of string * string * expr list
        | IfElse      of expr * stmt * stmt
        | While       of expr * stmt
        | Return      of expr
        | Assert      of expr
        | Assume      of expr
        | Clear
        | Print       of expr

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
  | _ -> failwith "InternalError: tried to retrieve the statements carried with \"Sequence\" value from non sequence constructor" 

let get_value (v : value option) : value =
  match v with
  | None   -> failwith "InternalError: tried to retrieve a program value from None" 
  | Some v -> v

let get_function (id : string) (p : program) : func =
  try Hashtbl.find p id
  with _ -> failwith ("NameError: name " ^ id ^ " is not defined")

let string_of_value (v : value) : string =
  match v with
  | Number n  -> "Number "  ^ (string_of_int n)
  | Boolean b -> "Boolean " ^ (string_of_bool b)

let print_value (v : value) : unit =
  string_of_value v |> print_endline

let is_true (v : value) : bool =
match v with
| Number n  -> if n!=0 then true else false
| Boolean b -> b

(* Operations' semantics functions *)

let neg (v : value) : value = match v with
  | (Number n) -> Number (-1*n)
  | _                -> invalid_arg "Exception in Oper.neg: this operation is only applicable to Number arguments"
let not (v : value) : value = match v with
  | (Boolean b) -> Boolean (not b)
  | _                -> invalid_arg "Exception in Oper.neg: this operation is only applicable to Boolean arguments"
let abs (v : value) : value = match v with
  | (Number n)  -> Number (abs(n))
  | _                -> invalid_arg "Exception in Oper.neg: this operation is only applicable to Number arguments"
let stoi (v : value) : value = match v with
  | _                -> invalid_arg "Exception in Oper.stoi: language does not support strings yet"

let plus (v1, v2 : value * value) : value = match v1, v2 with
  | (Number n1, Number n2) -> Number (n1 + n2)
  | _                -> invalid_arg "Exception in Oper.plus: this operation is only applicable to Number arguments"

let minus (v1, v2 : value * value) : value = match v1, v2 with
  | (Number n1, Number n2) -> Number (n1 - n2)
  | _                -> invalid_arg "Exception in Oper.minus: this operation is only applicable to Number arguments"

let times (v1, v2 : value * value) : value = match v1, v2 with
  | (Number n1, Number n2) -> Number (n1 * n2)
  | _                -> invalid_arg "Exception in Oper.times: this operation is only applicable to Number arguments"

let div (v1, v2 : value * value) : value = match v1, v2 with
  | (Number n1, Number n2) -> Number (n1 / n2)
  | _                -> invalid_arg "Exception in Oper.div: this operation is only applicable to Number arguments"

let modulo (v1, v2 : value * value) : value = match v1, v2 with
  | (Number n1, Number n2) -> Number (n1 mod n2)
  | _                -> invalid_arg "Exception in Oper.modulo: this operation is only applicable to Number arguments"

let pow (v1, v2 : value * value) : value = match v1, v2 with
  | (Number n1, Number n2) -> Number (n1*n2) (*TODO*)
  | _                -> invalid_arg "Exception in Oper.modulo: this operation is only applicable to Number arguments"

let equal (v1, v2 : value * value) : value = match v1, v2 with
  | (Number  n1, Number n2)  -> Boolean (n1=n2)
  | (Boolean b1, Boolean b2) -> Boolean (b1=b2)
  | _                -> invalid_arg "Exception in Oper.equal: this operation is only applicable to Number or Boolean arguments"

let nequal (v1, v2 : value * value) : value = match v1, v2 with
  | (Number  n1, Number n2)  -> Boolean (n1!=n2)
  | (Boolean b1, Boolean b2) -> Boolean (b1!=b2)
  | _                -> invalid_arg "Exception in Oper.equal: this operation is only applicable to Number or Boolean arguments"

let gt (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2) -> Boolean (n1>n2)
| _                  -> invalid_arg "Exception in Oper.gt: this operation is only applicable to Number arguments"

let lt (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2) -> Boolean (n1<n2)
| _                  -> invalid_arg "Exception in Oper.lt: this operation is only applicable to Number arguments"

let gte (v1, v2 : value * value) : value = match v1, v2 with
| (Number n1, Number n2)   -> Boolean (n1>=n2)
| _                  -> invalid_arg "Exception in Oper.gte: this operation is only applicable to Number arguments"

let lte (v1, v2 : value * value) : value = match v1, v2 with
| (Number  n1, Number  n2) -> Boolean (n1<=n2)
| _                  -> invalid_arg "Exception in Oper.lte: this operation is only applicable to Number arguments"