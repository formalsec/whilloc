open Value

module Enc = Encoding

let solver = Enc.Batch.create ()

let translate_value (v : Value.t) : Enc.Expression.t =
  match v with
  | Integer i -> Enc.Integer.mk_val i
  | Boolean b -> Enc.Boolean.mk_val b
  | Loc l ->  Enc.Integer.mk_val l
  | Error -> assert false 

let translate_binop (op : bop) (v1 : Enc.Expression.t) (v2 : Enc.Expression.t) : Enc.Expression.t =
  match op with
  | Plus 		-> Enc.Integer.mk_add v1 v2
  | Minus		-> Enc.Integer.mk_sub v1 v2
  | Times 	-> Enc.Integer.mk_mul v1 v2
  | Div    	-> 
  | Pow    	-> 
  | Gt 			-> 
  | Lt			-> 
  | Gte			-> 
  | Lte 		-> 
  | Equals 	-> 

  | Or 			-> Enc.Boolean.mk_or v1 v2
  | And 		-> 
  | Xor 		-> 
  | _ 			-> failwith ("TODO: Encoding.encode_binop, missing implementation of " ^ string_of_bop op)

let rec translate (e : Expression.t) : Enc.Expression.t =
  match e with
  | Val v -> translate_value v
  | Var v -> failwith ("InternalError: Encoding.encode_expr, tried to encode variable " ^ v)
  | UnOp (_, e) ->
      let e' = ttranslate e in
      assert false
  | BinOp (op, e1, e2) ->
      let e1' = translate e1 
      and e2' = translate e2 in
      translate_binop op e1' e2'
  | SymbVal _ -> assert false
  | SymbInt s -> Expression.mk_symbol `IntType s
  | ITE (e1, e2, e3) ->
      let e1' = translate e1 ...
      ...
      Boolean.mk_ite e1' e2' e3'

let is_sat (exprs : Expression.t list) : bool =
  let exprs' = List.map translate exprs in
  Enc.Batch.check_sat solver exprs'

let get_model () = assert false
