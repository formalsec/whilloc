type frame = Intermediate of (SStore.t * Program.stmt list * string) | Toplevel

type t = frame list

let top (cs : t): frame =
  match cs with
  | [] -> failwith "InternalError: Tried to peek from an empty stack"
  | top :: _ -> top

let pop (cs : t) : t =
  match cs with
  | [] -> failwith "InternalError: Tried to pop from an empty stack"
  | _ :: t -> t

let push (f : frame) (cs : t) : t =
  f::cs