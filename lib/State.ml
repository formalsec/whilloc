type t = Cont of Program.stmt option | Error | AssumeF | Return of Expression.value

let string_of_state (o : t) : string =
  let prefix = "STATE: " in
  match o with
  | Cont s   -> prefix ^ "Cont " ^ 
                  (match s with
                  | None   -> "o"
                  | Some s -> Program.string_of_stmt s)
  | Error    -> prefix ^ "Assertion evaluated to false"
  | AssumeF  -> prefix ^ "Assumption evaluated to false"
  | Return v -> prefix ^ "Returned " ^ Expression.string_of_value v

let should_halt (o: t) : bool =
  match o with
  | Error | AssumeF -> true
  | _ -> false