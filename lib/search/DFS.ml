module M : Search.M = struct

  open Operations

  let pick (states : 't list) : ('t * 't list) =
    pick_head states

  let join (new_states : 't list) (old_states : 't list) : 't list =
    join_push new_states old_states

end