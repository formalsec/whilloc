type t = Cont of Program.stmt list | Error | AssumeF | Return of Expression.value

let string_of_state (o : t) : string =
  let prefix = "STATE: " in
  match o with
  | Cont s   -> prefix ^ "Cont " ^ String.concat ";\n" ((fun x -> List.map Program.string_of_stmt x) s)
  | Error    -> prefix ^ "Assertion evaluated to false"
  | AssumeF  -> prefix ^ "Assumption evaluated to false"
  | Return v -> prefix ^ "Returned " ^ Expression.string_of_value v

let should_halt (o: t) : bool =
  match o with
  | Error | AssumeF -> true
  | _ -> false

let get_continuation (o : t) : Program.stmt list =
  match o with
  | Cont l -> l
  | _      -> failwith "InternalError: tried to retrieve continuation from a non Cont node"