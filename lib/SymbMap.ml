type t = (string, Value.t) Hashtbl.t

let eps : t = Hashtbl.create (Parameters.size)

let update (varvals : (string * Value.t) list) : unit =
  List.iter (fun (x, v) -> Hashtbl.replace eps x v) varvals

let map (var : string) =
  Hashtbl.find_opt eps var

let clear () =
  Hashtbl.reset eps