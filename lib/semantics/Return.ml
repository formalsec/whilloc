type 'v t = 'v State.t * Outcome.t

let string_of_return (to_string : 'v -> string) (ret : 'v t) : string =
  let (_,_,st,_,pc), out = ret in "\n#RETURN:\n" ^
  " -PC:      " ^ (PathCondition.string_of_pathcondition to_string pc) ^ "\n" ^
  " -OUTCOME: " ^ (Outcome.string_of_outcome out)            ^ "\n" ^
  " -STORE:"    ^ (Store.string_of_store to_string st)       ^ "\n"

let print (to_string : 'v -> string) (ret : 'v t) : unit =
  string_of_return to_string ret |> print_endline

(*
type 'v t = 'v Store.t * Outcome.t * PathCondition.t
type 'v t =    Outcome.t * PathCondition.t

let string_of_return (store_str : 'v -> string) (out_str : 'v -> string) (ret : 'v t) : string =
  let store,out,pc = ret in "\n#RETURN #\n" ^
  " PC:      " ^ (PathCondition.string_of_pathcondition pc)   ^ "\n" ^
  " Outcome: " ^ (Outcome.string_of_outcome out_str out)      ^ "\n" ^
  " STORE:"    ^ (Store.string_of_store store_str store)      ^ "\n"

let print_return (store_str : 'v -> string) (out_str : 'v -> string) (ret : 'v t) : unit =
  string_of_return store_str out_str ret |> print_endline
*)