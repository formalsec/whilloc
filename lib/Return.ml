type t = (SState.t * Outcome.t)

let string_of_return (ret : t) : string =
  let (_,_,st,_,pc), out = ret in
  "\n# RETURN #\nPC:      " ^ (PathCondition.string_of_pathcondition pc) ^ "\n" ^ (Outcome.string_of_outcome out) ^ "\nSTORE:\n" ^ (SStore.string_of_store st) ^ "\n"

  let print_return (ret : t) : unit =
    string_of_return ret |> print_endline