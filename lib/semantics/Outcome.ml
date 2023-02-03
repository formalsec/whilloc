type t = Cont | Return of string | AssumeF | Error (* of (string, Expression.value) Hashtbl *)

let string_of_outcome (o : t) : string =
  match o with
  | Cont     -> "Continue"
  | Error    -> "Assertion evaluated to false"
  | AssumeF  -> "Assumption evaluated to false"
  | Return e -> "Returned " ^ e

let should_halt (o : t) : bool =
  match o with
  | Error | AssumeF -> true
  | _ -> false
