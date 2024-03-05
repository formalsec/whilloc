type t =
  | Cont of Program.stmt list
  | Return of string
  | AssumeF
  | Error of Model.t [@name "Assert Failure"]
  | EndGas [@name "Out of gas"]
  [@@deriving yojson]

let pp ?(no_values = false) fmt = function
  | Cont _ -> Format.pp_print_string fmt "Continue"
  | Error e ->
      Format.fprintf fmt
        "Assertion violated, counter example:@\n@[<v 4>    %a@]"
        (Model.pp ~no_values) e
  | AssumeF -> Format.pp_print_string fmt "Assumption evaluated to false"
  | Return e -> Format.fprintf fmt "Returned %s" e
  | EndGas -> Format.pp_print_string fmt "EndGas"

let to_string (o : t) : string = Format.asprintf "%a" (pp ~no_values:false) o

let should_halt (o : t) : bool =
  match o with Error _ | AssumeF | EndGas -> true | _ -> false
