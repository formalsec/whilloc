type t = (string * Value.t) list option [@@deriving yojson]

let empty = Some []

let get_value (model : t) (var : string) : Value.t =
  match model with
  | None ->
      Log.error
        "InternalError: Model.value_of, tried to get the value of variable %s \
         with a None model"
        var
  | Some model -> (
      match List.assoc var model with
      | exception Not_found ->
          Log.error
            "InternalError: Model.value_of, there is no variable with name %s \
             in this model"
            var
      | v -> v)

let pp ?(no_values = false) (fmt : Format.formatter) (model : t) : unit =
  let open Fmt in
  let pp_binding fmt (x, v) =
    fprintf fmt "%s : %a" x (Value.pp ~no_values) v
  in
  match model with
  | None -> pp_print_string fmt "No model"
  | Some [] -> pp_print_string fmt "Empty model"
  | Some m ->
      let m = List.sort (fun (x1, _) (x2, _) -> String.compare x1 x2) m in
      pp_lst ~pp_sep:pp_newline pp_binding fmt m

let to_string (model : t) : string =
  Format.asprintf "%a" (pp ~no_values:false) model
