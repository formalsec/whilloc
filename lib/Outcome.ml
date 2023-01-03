type t = Cont | Return of Expression.expr | AssumeF | Error

let string_of_outcome (o : t) : string =
  let prefix = "OUTCOME: " in
  match o with
  | Cont     -> prefix ^ "Continue"
  | Error    -> prefix ^ "Assertion evaluated to false"
  | AssumeF  -> prefix ^ "Assumption evaluated to false"
  | Return e -> prefix ^ "Returned " ^ (Expression.string_of_expression e)

let should_halt (o: t) : bool =
  match o with
  | Error | AssumeF -> true
  | _ -> false
