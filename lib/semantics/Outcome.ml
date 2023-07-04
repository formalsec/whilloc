type t = Cont of Program.stmt list | Return of string | AssumeF | Error of Model.t | EndGas 

let to_string (o : t) : string =
  match o with
  | Cont _    -> "Continue"
  | Error e  -> "Assertion violated, counter example:" ^ (Model.to_string e)
  | AssumeF  -> "Assumption evaluated to false"
  | Return e -> "Returned " ^ e
  | EndGas -> "EndGas"

let should_halt (o : t) : bool =
  match o with
  | Error _ | AssumeF | EndGas -> true
  | _ -> false

let print (o : t) : unit =
  to_string o |> print_endline