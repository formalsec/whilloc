type t = Cont | Return of Expression.value | AssumeF | Error

let string_of_outcome (o : t) : string =
  let prefix = "OUTCOME: " in
  match o with
  | Cont     -> prefix ^ "Cont"
  | Error    -> prefix ^ "Assertion evaluated to false"
  | AssumeF  -> prefix ^ "Assumption evaluated to false"
  | Return v -> prefix ^ "Returned " ^ (Expression.string_of_value v)

let should_halt (o: t) : bool =
  match o with
  | Error | AssumeF -> true
  | _ -> false
