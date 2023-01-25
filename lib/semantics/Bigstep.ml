open Program
open Expression

let eval_unop_expr (op : uop) (v : value) : value =
  match op with
  | Neg -> neg v
  | Not -> not_ v
  | Abs -> abs v
  | StringOfInt -> stoi v

let eval_binop_expr (op : bop) (v1 : value) (v2 : value) : value =
  let f =
  match op with
  | Plus    -> plus  
  | Minus   -> minus 
  | Times   -> times 
  | Div     -> div   
  | Modulo  -> modulo
  | Pow     -> pow   
  | Gt      -> gt    
  | Lt      -> lt    
  | Gte     -> gte   
  | Lte     -> lte   
  | Equals  -> equal 
  | NEquals -> nequal
  | Or      -> or_   
  | And     -> and_  
  | Xor     -> xor   
  | ShiftL  -> shl   
  | ShiftR  -> shr
  in f (v1, v2)

let rec eval_expression (st : Store.t) (e : expr) : value = 
  match e with
  
  | Var x ->
      let value = Store.get st x in
      (match value with
      | None    -> failwith ("NameError: Bigstep, name \'" ^ x ^ "\' is not defined")
      | Some v  -> v)
  
  | Val v -> v

  | UnOp (op, e)       -> eval_unop_expr  op (eval_expression st e)
  | BinOp (op, e1, e2) -> eval_binop_expr op (eval_expression st e1) (eval_expression st e2)

let rec eval (prog : program) (store : Store.t) (s : stmt) : Store.t * Outcome.t =

  let eval' = eval prog in
  
  match s with

  | Skip | Clear -> store,Cont

  | Sequence [current_stmt] -> eval' store current_stmt

  | Sequence (current_stmt::rest) ->
      let store',out = eval' store current_stmt in
      (match out with
      | Cont    -> eval' store' (Sequence rest)
      | Error | AssumeF | Return _ -> store,out)

  | Assign (x,e) ->
      Store.set store x (eval_expression store e);
      store,Cont

  | FunCall (var,id,args) ->
      let eval_args   = List.map (fun e -> eval_expression store e) args in
      let function'   = Program.get_function id prog in
      let params      = function'.args in
      let var_vals    = try List.combine params eval_args
                        with _ -> failwith ("TypeError: Bigstep, argument arity mismatch when calling \'" ^ id ^ "\'") in
      let fresh_st    = Store.create_store var_vals in
      let _, out      = eval prog fresh_st function'.body  in
      (match out with
        | Cont            -> failwith ("BadProgram: Bigstep, function \"" ^ id ^ "\" did not return a value")
        | Error | AssumeF -> store,out
        | Return e        -> Store.set store var (eval_expression fresh_st e); store,Cont)

  | IfElse (e, s1, s2) ->
      let guard = eval_expression store e in
      if is_true guard then
        eval' store s1
      else
        eval' store s2

  | While (e, body) as while_stmt ->
      eval' store (IfElse (e, Sequence ( (sequence_content body)@[while_stmt] ), Skip))

  | Print exprs ->
      let eval_exprs = List.map (eval_expression store) exprs in
      let ()         = print_endline ">Program Print" in
      let ()         = List.iter print_value eval_exprs in
      let ()         = print_endline "" in
      store,Cont

  | Return e -> store,Return (Val (eval_expression store e))

  | Assert e -> 
      let v = eval_expression store e in
      if is_true v then store,Cont
      else              store,Error

  | Assume e -> 
      let v = eval_expression store e in
      if is_true v then store,Cont
      else              store,AssumeF
  
  | Symbol (x,s) -> failwith ("InternalError: Smallstep, tried to declare a symbolic variable '" ^ x ^ "' with value '" ^ s ^ "' in a concrete execution context")

  | Sequence []  -> failwith "InternalError: Bigstep, tried to evaluate an empty Sequence"


let interpret (prog : program) (main_id : string) : Outcome.t =
  let main  = get_function main_id prog in
  let store = Store.create_empty_store 100 in
  let _, o  = eval prog store main.body in
  match o with
  | Cont -> failwith "BadProgram: Bigstep, main function did not return a value"
  | _    -> o