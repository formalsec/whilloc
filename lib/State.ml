type ('v, 'h) t =
  Program.stmt
  * Program.stmt list
  * 'v Store.t
  * 'v Callstack.t
  * 'v PC.t
  * 'h

let get_statement (state : ('v, 'h) t) : Program.stmt =
  let stmt, _, _, _, _, _ = state in
  stmt

let get_continuation (state : ('v, 'h) t) : Program.stmt list =
  let _, cont, _, _, _, _ = state in
  cont

let get_store (state : ('v, 'h) t) : 'v Store.t =
  let _, _, st, _, _, _ = state in
  st

let get_callstack (state : ('v, 'h) t) : 'v Callstack.t =
  let _, _, _, cs, _, _ = state in
  cs

let get_pathcondition (state : ('v, 'h) t) : 'v PC.t =
  let _, _, _, _, pc, _ = state in
  pc

let push_statements (state : ('v, 'h) t) (to_add : Program.stmt list) :
    ('v, 'h) t =
  let stmt, stmts, st, cs, pc, heap = state in
  (stmt, to_add @ stmts, st, cs, pc, heap)

let to_string (str : 'v -> string) (heap_str : 'h -> string)
    (state : ('v, 'h) t) : string =
  let s, cont, store, cs, pc, heap = state in
  ">STATE:\n" ^ " -Cur Statement : " ^ Program.string_of_stmt s ^ "\n"
  ^ " -Continuation  : "
  ^ String.concat "; " (List.map Program.string_of_stmt cont)
  ^ "\n" ^ " -Store         : " ^ Store.to_string str store ^ "\n"
  ^ " -Callstaack    : " ^ Callstack.to_string str cs ^ "\n"
  ^ " -Path cond.    : "
  ^ PC.to_string str pc
  ^ "\n" ^ " -Heap          : " ^ heap_str heap

let print (str : 'v -> string) (heap_str : 'h -> string) (state : ('v, 'h) t) :
    unit =
  print_endline (to_string str heap_str state)

let dup (state : ('v, 'h) t) heap_dup : ('v, 'h) t =
  let s, cont, store, cs, pc, heap = state in
  (s, cont, Store.dup store, Callstack.dup cs, pc, heap_dup heap)
