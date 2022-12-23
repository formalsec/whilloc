type frame = Intermediate of (Store.t * Program.stmt list * string) | Toplevel

type t = frame list

let top (cs : t): frame =
  match cs with
  | [] -> failwith "InternalError: Tried to peek at the top of an empty stack"
  | top :: _ -> top

let pop (cs : t) : t =
  match cs with
  | [] -> failwith "InternalError: Tried to retrieve an empty stack"
  | _ :: t -> t