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

let pp (fmt : Format.formatter) (model : t) : unit =
  let open Format in
  match model with
  | None -> pp_print_string fmt "No model"
  | Some [] -> pp_print_string fmt "Empty model"
  | Some m ->
      let m = List.sort (fun (x1, _) (x2, _) -> String.compare x1 x2) m in
      pp_print_list
        ~pp_sep:(fun fmt () -> fprintf fmt "@\n")
        (fun fmt (x, v) -> fprintf fmt "%s : %a" x Value.pp v)
        fmt m

let to_string (model : t) : string = Format.asprintf "%a" pp model
let print (model : t) : unit = Format.printf "%a@." pp model
