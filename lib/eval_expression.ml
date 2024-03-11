open Value

let neg (v : t) : t =
  match v with
  | Integer n -> Integer (-1 * n)
  | _ ->
    invalid_arg
      "Exception in Oper.neg: this operation is only applicable to Integer \
       arguments"

let not_ (v : t) : t =
  match v with
  | Boolean b -> Boolean (not b)
  | _ ->
    invalid_arg
      "Exception in Oper.neg: this operation is only applicable to Boolean \
       arguments"

let abs (v : t) : t =
  match v with
  | Integer n -> Integer (abs n)
  | _ ->
    invalid_arg
      "Exception in Oper.neg: this operation is only applicable to Integer \
       arguments"

let stoi (v : t) : t =
  match v with
  | _ ->
    invalid_arg "Exception in Oper.stoi: language does not support strings yet"

let plus ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Integer (n1 + n2)
  | _ ->
    invalid_arg
      "Exception in Oper.plus: this operation is only applicable to Integer \
       arguments"

let minus ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Integer (n1 - n2)
  | _ ->
    invalid_arg
      "Exception in Oper.minus: this operation is only applicable to Integer \
       arguments"

let times ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Integer (n1 * n2)
  | _ ->
    invalid_arg
      "Exception in Oper.times: this operation is only applicable to Integer \
       arguments"

let div ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Integer (n1 / n2)
  | _ ->
    invalid_arg
      "Exception in Oper.div: this operation is only applicable to Integer \
       arguments"

let modulo ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Integer (n1 mod n2)
  | _ ->
    invalid_arg
      "Exception in Oper.modulo: this operation is only applicable to Integer \
       arguments"

let pow ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Integer (n1 * n2) (*TODO*)
  | _ ->
    invalid_arg
      "Exception in Oper.modulo: this operation is only applicable to Integer \
       arguments"

let equal ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Boolean (n1 = n2)
  | Boolean b1, Boolean b2 -> Boolean (b1 = b2)
  | _ ->
    invalid_arg
      "Exception in Oper.equal: this operation is only applicable to Integer \
       or Boolean arguments"

let nequal ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Boolean (n1 != n2)
  | Boolean b1, Boolean b2 -> Boolean (b1 != b2)
  | _ ->
    invalid_arg
      "Exception in Oper.equal: this operation is only applicable to Integer \
       or Boolean arguments"

let gt ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Boolean (n1 > n2)
  | _ ->
    invalid_arg
      "Exception in Oper.gt: this operation is only applicable to Integer \
       arguments"

let lt ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Boolean (n1 < n2)
  | _ ->
    invalid_arg
      "Exception in Oper.lt: this operation is only applicable to Integer \
       arguments"

let gte ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Boolean (n1 >= n2)
  | _ ->
    invalid_arg
      "Exception in Oper.gte: this operation is only applicable to Integer \
       arguments"

let lte ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Boolean (n1 <= n2)
  | _ ->
    invalid_arg
      "Exception in Oper.lte: this operation is only applicable to Integer \
       arguments"

let or_ ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Boolean b1, Boolean b2 -> Boolean (b1 || b2)
  | _ ->
    invalid_arg
      "Exception in Oper.or: this operation is only applicable to Boolean \
       arguments"

let and_ ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Boolean b1, Boolean b2 -> Boolean (b1 && b2)
  | _ ->
    invalid_arg
      "Exception in Oper.and: this operation is only applicable to Boolean \
       arguments"

let xor ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Boolean b1, Boolean b2 -> Boolean ((b1 || b2) && ((not b1) || not b2))
  | _ ->
    invalid_arg
      "Exception in Oper.xor: this operation is only applicable to Boolean \
       arguments"

let shl ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Integer (n1 + n2) (*TODO*)
  | _ ->
    invalid_arg
      "Exception in Oper.shl: this operation is only applicable to Integer \
       arguments"

let shr ((v1, v2) : t * t) : t =
  match (v1, v2) with
  | Integer n1, Integer n2 -> Integer (n1 + n2) (*TODO*)
  | _ ->
    invalid_arg
      "Exception in Oper.shr: this operation is only applicable to Integer \
       arguments"

let eval_unop_expr (op : Term.unop) (v : t) : t =
  match op with
  | Neg -> neg v
  | Not -> not_ v
  | Abs -> abs v
  | StringOfInt -> stoi v

let eval_ite (_ : Term.t) (_ : Term.t) (_ : Term.t) : t = assert false

let eval_binop_expr (op : Term.binop) (v1 : t) (v2 : t) : t =
  let f =
    match op with
    | Plus -> plus
    | Minus -> minus
    | Times -> times
    | Div -> div
    | Modulo -> modulo
    | Pow -> pow
    | Gt -> gt
    | Lt -> lt
    | Gte -> gte
    | Lte -> lte
    | Equals -> equal
    | NEquals -> nequal
    | Or -> or_
    | And -> and_
    | Xor -> xor
    | ShiftL -> shl
    | ShiftR -> shr
  in
  f (v1, v2)
