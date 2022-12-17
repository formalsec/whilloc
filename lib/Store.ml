type t = (string, Program.value) Hashtbl.t (*function from Var to Values*)

let create_store (size : int) : t =
  Hashtbl.create size

let create (varvals : (string * Program.value) list) : t =
  let st = Hashtbl.create (List.length varvals) in
  List.iter (fun (x, v) -> Hashtbl.replace st x v) varvals;
  st

let set (st : t) (var : string) (v : Program.value) =
  Hashtbl.replace st var v

let get (st : t) (var : string) =
  Hashtbl.find_opt st var

let find_all (st : t) (var : string) =
  Hashtbl.find_all st var

let exists (st : t) (var : string) =
  Hashtbl.mem st var;;
