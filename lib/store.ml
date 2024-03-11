type 'v t = (string, 'v) Hashtbl.t

let create_empty_store (size : int) : 'v t = Hashtbl.create size

let create_store (varvals : (string * 'v) list) : 'v t =
  let st = Hashtbl.create (List.length varvals) in
  List.iter (fun (x, v) -> Hashtbl.replace st x v) varvals;
  st

let set (store : 'v t) (var : string) (v : 'v) : unit =
  Hashtbl.replace store var v

let get (store : 'v t) (var : string) : 'v =
  let value = Hashtbl.find_opt store var in
  match value with
  | None -> failwith ("NameError: Store.get, name '" ^ var ^ "' is not defined")
  | Some v -> v

let get_opt (store : 'v t) (var : string) : 'v option =
  Hashtbl.find_opt store var

let remove (store : 'v t) (var : string) : unit = Hashtbl.remove store var
let dup (store : 'v t) : 'v t = Hashtbl.copy store

let find_all (store : 'v t) (var : string) : 'v list =
  Hashtbl.find_all store var

let exists (store : 'v t) (var : string) : bool = Hashtbl.mem store var

let iterate (f : string -> 'v -> unit) (store : 'v t) : unit =
  Hashtbl.iter f store

let fold (f : 'a -> 'b -> 'c -> 'c) (htbl : ('a, 'b) Hashtbl.t) (init : 'c) : 'c
    =
  Hashtbl.fold f htbl init

let pp (pp_val : Fmt.t -> 'v -> unit) (fmt : Fmt.t) (store : 'v t) : unit =
  let open Fmt in
  let pp_binding fmt (x, v) = fprintf fmt "%s -> %a" x pp_val v in
  if Hashtbl.length store = 0 then pp_str fmt "{}"
  else fprintf fmt "{ %a }" (pp_hashtbl ~pp_sep:pp_comma pp_binding) store

let to_string (pp_val : Fmt.t -> 'v -> unit) (store : 'v t) : string =
  Fmt.asprintf "%a" (pp pp_val) store

let print (pp_val : Fmt.t -> 'v -> unit) (store : 'v t) : unit =
  to_string pp_val store |> print_endline
