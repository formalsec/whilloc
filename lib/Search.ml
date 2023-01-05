let pick (states : SState.t list) : (SState.t * SState.t list) =
  match states with
  | []     -> failwith "InternalError: Tried to pick a state to expand from an empty collection of states"
  | h :: t -> h,t

let is_final (result : Return.t) : bool =
  let _,out = result in
  match out with
  | Cont -> false
  | AssumeF -> print_endline "HA!"; true
  | _    -> true

let join (state : SState.t list) (states : SState.t list) : SState.t list =
  state @ states
