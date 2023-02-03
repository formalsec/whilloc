type 'v frame = Intermediate of ( ('v Store.t) * Program.stmt list * string) | Toplevel
type 'v t     = ('v frame) list

exception EmptyStack of string

let create_callstack : 'v t =
  [Toplevel]

let top (cs : 'v t): 'v frame =
  match cs with
  | [] -> raise (EmptyStack "Callstack.ml: tried to peek from an empty stack")
  | top :: _ -> top

let pop (cs : 'v t) : 'v t =
  match cs with
  | [] -> raise (EmptyStack "Callstack.ml: tried to pop from an empty stack")
  | _ :: t -> t

let push (cs : 'v t) (f : 'v frame) : 'v t =
  f::cs