type frame = Intermediate of (Store.t * Program.stmt list * string) | Toplevel

type t = frame list

let top (cs : t): frame =
  match cs with
  | [] -> failwith "InternalError: Tried to peek from an empty stack"
  | top :: _ -> top

let pop (cs : t) : t =
  match cs with
  | [] -> failwith "InternalError: Tried to pop from an empty stack"
  | _ :: t -> t