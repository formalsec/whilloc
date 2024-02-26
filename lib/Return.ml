type ('v, 'h) t = ('v, 'h) State.t * Outcome.t

let string_of_return (str : 'v -> string) (heap_to_string : 'h -> string)
    (ret : ('v, 'h) t) : string =
  let (_, _, st, _, pc, h), out = ret in
  "#RETURN:\n" ^ " -Outcome   : " ^ Outcome.to_string out ^ "\n"
  ^ " -Store     : " ^ Store.to_string str st ^ "\n" ^ " -Path cond.: "
  ^ PathCondition.to_string str pc
  ^ "\n" ^ " -Heap      : " ^ heap_to_string h ^ "\n\n"

let get_outcome (ret : ('v, 'h) t) : Outcome.t =
  let _, out = ret in
  out

let get_pc (ret : ('v, 'h) t) : 'v PathCondition.t =
  let state, _ = ret in
  State.get_pathcondition state

let print (to_string : 'v -> string) (heap_to_string : 'h -> string)
    (ret : ('v, 'h) t) : unit =
  string_of_return to_string heap_to_string ret |> print_endline
