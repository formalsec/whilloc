type t = Cont | Return of string | AssumeF | Error of Model.t

let to_string (o : t) : string =
  match o with
  | Cont     -> "Continue"
  | Error e  -> "Assertion violated, counter example:" ^ (Model.to_string e)
  | AssumeF  -> "Assumption evaluated to false"
  | Return e -> "Returned " ^ e

let should_halt (o : t) : bool =
  match o with
  | Error _ | AssumeF -> true
  | _ -> false

let print (o : t) : unit =
  to_string o |> print_endline