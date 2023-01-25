type t = Program.stmt * (Program.stmt list) * Store.t * Callstack.t

let get_current_stmt (state : t) : Program.stmt =
  let stmt,_,_,_=state in stmt

let get_continuation (state : t) : Program.stmt list =
  let _,cont,_,_=state in cont

let push_statements (state : t) (to_add : Program.stmt list) : t =
  let stmt,stmts,st,cs = state in
  (stmt,to_add@stmts,st,cs)