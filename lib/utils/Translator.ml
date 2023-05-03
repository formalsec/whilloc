open Value
open Expression

module Enc = Encoding

let solver = Enc.Batch.create ()

let translate_value (v : Value.t) : Enc.Expression.t =
  match v with
  | Integer i -> Enc.Integer.mk_val i
  | Boolean b -> Enc.Boolean.mk_val b
  | Loc l ->  Enc.Integer.mk_val l
  | Error -> assert false 


let translate_uop (op : uop) (v : Enc.Expression.t) : Enc.Expression.t =
  match op with
  | Neg -> Enc.Integer.mk_neg v
  | Not -> Enc.Boolean.mk_not v
  | _   -> failwith ("TODO: Encoding.encode_unop, missing implementation of " ^ string_of_uop op)

let translate_binop (op : bop) (v1 : Enc.Expression.t) (v2 : Enc.Expression.t) : Enc.Expression.t =
  match op with
  | Plus 		-> Enc.Integer.mk_add v1 v2
  | Minus		-> Enc.Integer.mk_sub v1 v2
  | Times 	-> Enc.Integer.mk_mul v1 v2
  | Div    	-> Enc.Integer.mk_div v1 v2
  | Pow    	-> Enc.Integer.mk_pow v1 v2
  | Gt 			-> Enc.Integer.mk_gt  v1 v2
  | Lt			-> Enc.Integer.mk_lt  v1 v2
  | Gte			-> Enc.Integer.mk_ge  v1 v2
  | Lte 		-> Enc.Integer.mk_le  v1 v2
  | Equals 	-> Enc.Integer.mk_eq  v1 v2

  | Or 			-> Enc.Boolean.mk_or  v1 v2
  | And 		-> Enc.Boolean.mk_and v1 v2
  | Xor 		-> Enc.Boolean.mk_xor v1 v2
  | _ 			-> failwith ("TODO: Encoding.encode_binop, missing implementation of " ^ string_of_bop op)

let rec translate (e : Expression.t) : Enc.Expression.t =
  match e with
  | Val v -> translate_value v
  | Var v -> failwith ("InternalError: Encoding.encode_expr, tried to encode variable " ^ v)
  | UnOp (op, e) ->
      let e' = translate e in
      translate_uop op e'
  | BinOp (op, e1, e2) ->
      let e1' = translate e1 
      and e2' = translate e2 in
      translate_binop op e1' e2'
  | SymbVal s -> Enc.Expression.mk_symbol `IntType s (* TODO: Booleans*)
  | SymbInt s -> Enc.Expression.mk_symbol `IntType s
  | ITE (e1, e2, e3) ->
      let e1' = translate e1
      and e2' = translate e2
      and e3' = translate e3 in
      Enc.Boolean.mk_ite e1' e2' e3'

let is_sat (exprs : Expression.t list) : bool =
  let exprs' = List.map translate exprs in
  Enc.Batch.check_sat solver exprs'

let get_model ?(print_model=false) () = ignore print_model; assert false