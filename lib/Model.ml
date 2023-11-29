type t = (string * Value.t) list option

let empty = Some []

let rec value_of (model : t) (var : string) : Value.t =
  match model with
  | None ->
      failwith
        ("InternalError: Model.value_of, tried to get the value of variable "
       ^ var ^ " with a None model")
  | Some [] ->
      invalid_arg
        ("InternalError: Model.value_of, there is no variable with name " ^ var
       ^ " in this model")
  | Some ((x, v) :: t) -> if x == var then v else value_of (Some t) var

let to_string (model : t) : string =
  match model with
  | None -> "No model"
  | Some [] -> "Empty model"
  | Some m ->
      "\n\t\t\t\t"
      ^ String.concat "\n\t\t\t\t"
          (List.map (fun (x, v) -> Format.asprintf "%s : %a" x Value.pp v) m)

let print (model : t) : unit = to_string model |> print_endline
