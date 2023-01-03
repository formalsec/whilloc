type t = Expression.expr list

let rec print_pc (pc : t) : unit =
  match pc with
  | []      -> print_endline ""
  | h :: t  -> Expression.print_expression h; print_pc t