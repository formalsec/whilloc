open Program
open Expression

let eval_unop_expr (op : uop) (v : value) : value =
  match op with
  | Neg -> neg v
  | Not -> not v
  | Abs -> abs v
  | StringOfInt -> stoi v

let eval_binop_expr (op : bop) (v1 : value) (v2 : value) : value =
  match op with
  | Plus    -> plus   (v1, v2)
  | Minus   -> minus  (v1, v2)
  | Times   -> times  (v1, v2)
  | Div     -> div    (v1, v2)
  | Modulo  -> modulo (v1, v2)
  | Pow     -> pow    (v1, v2)
  | Gt      -> gt     (v1, v2)
  | Lt      -> lt     (v1, v2)
  | Gte     -> gte    (v1, v2)
  | Lte     -> lte    (v1, v2)
  | Equals  -> equal  (v1, v2)
  | NEquals -> nequal (v1, v2)

let rec eval_expression (st : Store.t) (e : expr) : value = 
  match e with
  
  | Var x ->
      let value = Store.get st x in
      if  value = None then failwith ("NameError: name " ^ x ^ " is not defined")
      else Expression.get_value value
  
  | Val v -> v

  | UnOp (op, e)       -> eval_unop_expr  op (eval_expression st e)
  | BinOp (op, e1, e2) -> eval_binop_expr op (eval_expression st e1) (eval_expression st e2)


let rec small_step (prog : program) (st : Store.t) (cs : Callstack.t) (s : stmt) : State.t * Store.t * Callstack.t = 
  let eval = small_step prog st cs in
  match s with

  | Skip | Clear -> Cont None, st, cs
  
  | Sequence [current_stmt] ->
    let out,st',cs' = eval current_stmt in
    (match out with
      | Cont None       -> Cont None,st',cs'
      | Cont (Some s')  -> Cont (Some (Sequence [s'])),st',cs'
      | Return v        -> Return v ,st',cs'
      | Error           -> Error    ,st',cs'
      | AssumeF         -> AssumeF  ,st',cs')

    (*If we have at hand a function call without anything following it, then there is nothing to evaluate after its return, thus,
    the return value associated with the variable is inconsequential. Therefore, we simply set the state to Cont None. *)
  | FunCall (_,_,_) -> Cont None, st, cs

  | Sequence ( (FunCall (var,id,args)) :: rest) ->
    let eval_args   = List.map (fun e -> eval_expression st e) args in
    let function'   = Program.get_function id prog in
    let params      = function'.args in
    let var_vals    = try List.combine params eval_args
                      with _ -> failwith ("TypeError: argument arity mismatch when calling " ^ id) in
    let func_frame  = Store.create_store var_vals in
    let cs'         = (Callstack.Intermediate (st, Sequence rest, var) ) :: cs in
    Cont (Some function'.body),func_frame,cs'

  | Sequence (current_stmt :: rest) ->
      let out,st',cs' = eval current_stmt in
      (match out with
      | Cont None       -> Cont (Some (Sequence rest) ),st',cs'
      | Cont (Some s')  -> Cont (Some (Sequence (s'::rest))),st',cs'
      | Return v        -> Return v ,st',cs'
      | Error           -> Error    ,st',cs'
      | AssumeF         -> AssumeF  ,st',cs')

  | Assign (x,e) ->
    Store.set st x (eval_expression st e);
    Cont None, st, cs

  | IfElse (e, s1, s2) ->
      let guard = eval_expression st e in
      if is_true guard then
        Cont (Some s1),st,cs
      else
        Cont (Some s2),st,cs

  | While (e, body) as while_stmt ->
      Cont (Some ( IfElse(e, Sequence ( (sequence_content body) @ [while_stmt] ), Skip ) ) ),st,cs

  | Print e  -> let _ = e |> eval_expression st |> print_value in Cont None,st,cs

  | Return e ->
      let v     = eval_expression st e in
      let frame = Callstack.top cs in
      let cs'   = Callstack.pop cs in
        (match frame with
        | Callstack.Intermediate (st',s',x) -> (Store.set st' x v;
                                                Cont (Some s'),st',cs')
        | Callstack.Toplevel -> Return v,st,cs)
        
  | Assert e -> 
      let v = eval_expression st e in
      if is_true v then Cont None,st,cs
      else              Error,st,cs

  | Assume e -> 
      let v = eval_expression st e in
      if is_true v then Cont None,st,cs
      else              AssumeF,st,cs

  | Sequence [] -> failwith "InternalError: tried to evaluate an empty Sequence"

let rec eval (prog : program) (st : Store.t) (cs : Callstack.t) (s : stmt) : State.t * Store.t * Callstack.t = 
  let o,st',cs' = small_step prog st cs s in
  match o with
  | Cont (Some s') -> eval prog st' cs' s'
  | _              -> o,st',cs'

let interpret (prog : program) (main_id : string) : State.t =
  let main = get_function main_id prog in
  let st   = Store.create_empty_store 100 in
  let cs   = [Callstack.Toplevel] in
  let o, _, _ = eval prog st cs main.body in
  o