type t = (string, Value.t) Hashtbl.t (*partial function from Var to Values*)

let create_empty_store (size : int) : t =
  Hashtbl.create size

let create_store (varvals : (string * Value.t) list) : t =
  let st = Hashtbl.create (List.length varvals) in
  List.iter (fun (x, v) -> Hashtbl.replace st x v) varvals;
  st

let set (st : t) (var : string) (v : Value.t) =
  Hashtbl.replace st var v

let get (st : t) (var : string) =
  Hashtbl.find_opt st var

let find_all (st : t) (var : string) =
  Hashtbl.find_all st var

let exists (st : t) (var : string) =
  Hashtbl.mem st var;;

let string_of_store (st : t) : string =
  String.concat "\n" (Hashtbl.fold (fun x y z -> ("      " ^ x ^ "  ->  " ^ (Value.string_of_value y)) :: z ) st [])