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

let to_string (str : 'v -> string) (state : 'v t) : string =
  let s,cont,store,cs,pc = state in ">STATE:\n" ^
  " -Cur Statement : " ^ (Program.string_of_stmt s)       ^ "\n" ^
  " -Continuation  : " ^ (String.concat "; " (List.map Program.string_of_stmt cont)) ^ "\n" ^
  " -Store         : " ^ (Store.to_string str store)      ^ "\n" ^
  " -Callstaack    : " ^ (Callstack.to_string str cs)     ^ "\n" ^
  " -Path cond.    : " ^ (PathCondition.to_string str pc) ^ "\n\n"

let print (str : 'v -> string) (state : 'v t) : unit = 
  print_endline (to_string str state)

let dup (state : 'v t) : 'v t =
  let s,cont,store,cs,pc = state in
  (s, cont, Store.dup store, Callstack.dup cs, pc)
