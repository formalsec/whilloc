module ConcreteState : State = struct

  type t     = Program.stmt * (Program.stmt list) * Store.t * Callstack.t
  type value = Expression.value
  type store = Store.t

  let get_stmt state = let stmt,_,_,_ = state in stmt
  
  let get_continuation state = let _,cont,_,_ = state in cont

  let create_store varvals =
    let st = Hashtbl.create (List.length varvals) in
    List.iter (fun (x, v) -> Hashtbl.replace st x v) varvals;
    st

  let set st var v = Hashtbl.replace st var v

  let get st var = Hashtbl.find_opt st var
  
  let is_symbolic_expression store expr = false

  let rec eval_expression store e = 
    let open Expression in 
    match e with
    
    | Var x ->
        let value = Store.get store x in
        (match value with
        | None    -> failwith ("NameError: Bigstep, name \'" ^ x ^ "\' is not defined") (*TODO use (NameError : exception) *)
        | Some v  -> v)
    
    | Val v -> v
  
    | UnOp (op, e)       -> eval_unop_expr  op (eval_expression store e)
    | BinOp (op, e1, e2) -> eval_binop_expr op (eval_expression store e1) (eval_expression store e2)

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
