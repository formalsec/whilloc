type t = Normal | Error | AssumeF | Return of Program.value

let string_of_state (o : t) : string =
  let prefix = "STATE: " in
  match o with
  | Normal   -> prefix ^ "Mind and matter, potatoes and tomatoes"
  | Error    -> prefix ^ "Assertion evaluated to false"
  | AssumeF  -> prefix ^ "Assumption evaluated to false"
  | Return v -> prefix ^ "Returned " ^ Program.string_of_value v

let should_halt (o: t) : bool =
  match o with
  | Error | AssumeF -> true
  | _ -> false