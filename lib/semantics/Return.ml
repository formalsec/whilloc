type 'v t = 'v State.t * Outcome.t

let string_of_return (str : 'v -> string) (ret : 'v t) : string =
  let (_,_,st,_,pc), out = ret in "#RETURN:\n" ^
  " -Outcome   : " ^ (Outcome.to_string out)          ^ "\n" ^
  " -Store     : " ^ (Store.to_string str st)         ^ "\n" ^
  " -Path cond.: " ^ (PathCondition.to_string str pc) ^ "\n\n" 

let print (to_string : 'v -> string) (ret : 'v t) : unit =
  string_of_return to_string ret |> print_endline
