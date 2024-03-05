type ('v, 'h) t =
  Program.stmt * Program.stmt list * 'v Store.t * 'v Callstack.t * 'v PC.t * 'h

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

let pp (pp_val : Fmt.t -> 'v -> unit) (pp_heap : Fmt.t -> 'h -> unit)
    (fmt : Fmt.t) (state : ('v, 'h) t) : unit =
  let open Fmt in
  let s, cont, store, cs, pc, heap = state in
  fprintf fmt
    ">STATE:@. -Cur Statement : %a@.  -Continuation  : %a@.  -Store         : \
     %a@.  -Callstaack    : %a@.  -Path cond.    : %a@.  -Heap          : %a@."
    Program.pp s (pp_lst "; " Program.pp) cont (Store.pp pp_val) store
    (Callstack.pp pp_val) cs (PC.pp pp_val) pc pp_heap heap

let to_string (pp_val : Fmt.t -> 'v -> unit) (pp_heap : Fmt.t -> 'h -> unit)
    (state : ('v, 'h) t) : string =
  Format.asprintf "%a" (pp pp_val pp_heap) state

let print (pp_val : Fmt.t -> 'v -> unit) (pp_heap : Fmt.t -> 'h -> unit)
    (state : ('v, 'h) t) : unit =
  to_string pp_val pp_heap state |> print_endline

let dup (state : ('v, 'h) t) heap_dup : ('v, 'h) t =
  let s, cont, store, cs, pc, heap = state in
  (s, cont, Store.dup store, Callstack.dup cs, pc, heap_dup heap)
