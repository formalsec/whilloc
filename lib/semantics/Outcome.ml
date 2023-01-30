type t = Cont | Return of Expression.expr | AssumeF | Error (* of (string, Expression.value) Hashtbl *)

let string_of_outcome (o : t) : string =
  "OUTCOME: " ^ 
  match o with
  | Cont     -> "Continue"
  | Error    -> "Assertion evaluated to false"
  | AssumeF  -> "Assumption evaluated to false"
  | Return e -> "Returned " ^ (Expression.string_of_expression e)

let should_halt (o: t) : bool =
  match o with
  | Error | AssumeF -> true
  | _ -> false
