type 'v t = Program.stmt * (Program.stmt list) * 'v Store.t * 'v Callstack.t * 'v PathCondition.t

  let get_statement (state : 'v t) : Program.stmt =
    let stmt,_,_,_,_=state in stmt

  let get_continuation (state : 'v t) : Program.stmt list =
    let _,cont,_,_,_=state in cont

  let get_store (state : 'v t) : 'v Store.t =
    let _,_,st,_,_=state in st

  let get_callstack (state : 'v t) : 'v Callstack.t =
    let _,_,_,cs,_=state in cs

  let get_pathcondition (state : 'v t) : 'v PathCondition.t =
    let _,_,_,_,pc=state in pc

  let push_statements (state : 'v t) (to_add : Program.stmt list) : 'v t =
    let stmt,stmts,st,cs,pc = state in
    (stmt,to_add@stmts,st,cs,pc)

  let to_string (f : 'v -> string) (state : 'v t) : string =
    let _ = f in
    let _ = state in
    "State.ml TODO to_string"

  let print (f : 'v -> string) (state : 'v t) : unit = 
    print_endline (to_string f state)