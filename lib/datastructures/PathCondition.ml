type 'v t = 'v list (* a conjunction of expressions *)

let create_pathcondition : ('v list) = []

let add_condition (pc : 'v list) (t : 'v) : ('v list) =
  t::pc

let string_of_pathcondition (to_string : 'v -> string) (pc : 'v list) : string = 
  let rec aux pc : string list =
    match pc with
    | []      -> []
    | h :: t  -> (to_string h) :: (aux t)
  in String.concat " ∧ " (aux pc)

let print_pc (to_string : 'v -> string) (pc : 'v t) : unit =
  string_of_pathcondition to_string pc |> print_endline
  