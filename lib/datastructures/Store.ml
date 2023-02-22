type 'v t = (string, 'v) Hashtbl.t

let create_empty_store (size : int) : 'v t =
  Hashtbl.create size

let create_store (varvals : (string * 'v) list) : 'v t =
  let st = Hashtbl.create (List.length varvals) in
  List.iter (fun (x, v) -> Hashtbl.replace st x v) varvals;
  st

let set (store : 'v t) (var : string) (v : 'v) : unit =
  Hashtbl.replace store var v

let get (store : 'v t) (var : string) : 'v =
  let value = Hashtbl.find_opt store var in
  (match value with
  | None    -> failwith ("NameError: Store.get, name '" ^ var ^ "' is not defined") 
  | Some v  -> v)

let dup (store : 'v t) : 'v t =
  Hashtbl.copy store

let find_all (store : 'v t) (var : string) : 'v list =
  Hashtbl.find_all store var

let exists (store : 'v t) (var : string) : bool =
  Hashtbl.mem store var

let iterate (f : string -> 'v -> unit) (store : 'v t) : unit =
  Hashtbl.iter f store

let fold (f : 'a -> 'b -> 'c -> 'c) ( htbl : ('a, 'b) Hashtbl.t) (init : 'c) : 'c =
  Hashtbl.fold f htbl init

let to_string (str : 'v -> string ) (store : 'v t) : string =
  "\n" ^ String.concat "\n" (Hashtbl.fold (fun x y z -> ("\t\t" ^ x ^ "  ->  " ^ (str y)) :: z ) store [])