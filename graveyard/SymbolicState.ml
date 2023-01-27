module SymbolicState : State = struct

  type t     = Program.stmt * (Program.stmt list) * SStore.t * SCallstack.t * PathCondition.t
  type value = Expression.expr
  type store = SStore.t

  let get_stmt state = let stmt,_,_,_,_ = state in stmt
  
  let get_continuation state = let _,cont,_,_,_ = state in cont

  let create_store varvals =
    let st = Hashtbl.create (List.length varvals) in
    List.iter (fun (x, v) -> Hashtbl.replace st x v) varvals;
    st
  
  let set store var e = Hashtbl.replace store var e
  
  let get store var =
    let value = Hashtbl.find_opt store var in
    (match value with
    | None    -> failwith ("NameError: SStore.get, name '" ^ var ^ "' is not defined") (*TODO use (NameError : exception) *)
    | Some v  -> v) (* here, 'v' will always be an expr.Val *)
  
  (* Helper functions for eval_expression *)

  let is_symbolic_value v : bool =
    match v with
    | SymbVal _ -> true
    | _         -> false
  
  let rec is_symbolic_expression store e =
    match e with
    | Val v     -> is_symbolic_value v
    | Var x     -> SStore.get st x |> is_symbolic_expression st 
    | UnOp  (_, e)    -> is_symbolic_expression st e
    | BinOp (_,e1,e2) -> is_symbolic_expression st e1 || is_symbolic_expression st e2
  
  let rec simplify_symb_expr store e =
    match e with
    | Val _     -> e
    | Var x     -> SStore.get store x
    | UnOp  (op, e)    -> UnOp (op, simplify_symb_expr store e)
    | BinOp (op,e1,e2) -> BinOp(op, simplify_symb_expr store e1, simplify_symb_expr store e2)

  let eval_unop_expr (op : uop) (v : value) : Expression.expr =
    Val (
    match op with
    | Neg -> neg v
    | Not -> not_ v
    | Abs -> abs v
    | StringOfInt -> stoi v)
  
  let eval_binop_expr (op : bop) (v1 : value) (v2 : value) : expr =
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
    in Val ( f (v1, v2) )

  let rec eval_expression store e = 

    (* We can't reduce the expression 'e' to a value if it contains symbolic variables, so we just replace each symbolic variable with its symbolic value *)
    if is_symbolic_expression st e then simplify_symb_expr st e
    
    (* If the expression does not contains symbolic variables, we can reduce it until it becomes a value *)
    else
    let open Expression in 
    match e with
      | Val v -> Val v  
      | Var x -> SStore.get st x
      | UnOp  (op, e)      -> eval_expression st e |> get_value_from_expr |> eval_unop_expr op
      | BinOp (op, e1, e2) -> eval_binop_expr op (eval_expression st e1 |> get_value_from_expr) (eval_expression st e2 |> get_value_from_expr)

  let string_of_t state =
    let stmt,cont,store,cs = state in
    Printf.sprintf "#Statement:\n   %s\n#Continuation:\n   %s\n#Store:\n   %s\n#Callstack:\n   %s\n"
                  (Program.string_of_stmt stmt) (String.concat "\n" (List.map Program.string_of_stmt cont)) (SStore.string_of_store store) ("callstackTODO") 

  let string_of_value v =
    let open Expression in 
    match v with
    | Integer n -> "Int "  ^ (string_of_int n)
    | Boolean b -> "Bool " ^ (string_of_bool b)
    | SymbVal x -> x
  
  let top cs =
    match cs with
    | [] -> failwith "InternalError: Tried to peek from an empty stack" (*TODO use (EmptyStack : exception) *)
    | top :: _ -> top

  let pop cs =
    match cs with
    | [] -> failwith "InternalError: Tried to pop from an empty stack" (*TODO use (EmptyStack : exception) *)
    | _ :: t -> t

  let push frame cs = frame::cs

end
