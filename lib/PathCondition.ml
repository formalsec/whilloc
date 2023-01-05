type t = Expression.expr list (* a conjunction of expressions *)

let string_of_pathcondition (pc : t) : string = 
  let rec aux (pc : t) : string list =
    match pc with
    | []      -> []
    | h :: t  -> Expression.string_of_expression h :: (aux t)
  in String.concat " ∧ " (aux pc)

let print_pc (pc : t) : unit =
  string_of_pathcondition pc |> print_endline