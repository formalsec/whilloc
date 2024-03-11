let pick_head states =
  match states with
  | [] ->
    failwith
      "InternalError: Tried to pick a state to expand from an empty collection \
       of states"
  | h :: t -> (h, t)

let pick_last states =
  let rec aux acc states =
    match states with
    | [] ->
      failwith
        "InternalError: Tried to pick a state to expand from an empty \
         collection of states"
    | [ h ] -> (h, List.rev acc) (*meh*)
    | h :: t -> aux (h :: acc) t
  in
  aux [] states

let join_push new_states old_states = new_states @ old_states
let join_enqueue new_states old_states = old_states @ new_states
