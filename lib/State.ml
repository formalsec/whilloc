type t = Store.t * (Program.stmt list) * Callstack.t

let get_continuation (state : t) : Program.stmt list =
  let _,cont,_=state in cont

let push_statements (state : t) (to_add : Program.stmt list) : t =
  let st,stmts,cs = state in
  (st, to_add@stmts,cs)