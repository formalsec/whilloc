type t = (string, Expression.expr) Hashtbl.t (*partial function from Var to Expressions*)

let create_empty_store (size : int) : t =
  Hashtbl.create size

let create_store (varvals : (string * Expression.expr) list) : t =
  let st = Hashtbl.create (List.length varvals) in
  List.iter (fun (x, v) -> Hashtbl.replace st x v) varvals;
  st

let set (st : t) (var : string) (e : Expression.expr) =
  Hashtbl.replace st var e

let get (st : t) (var : string) =
  let value = Hashtbl.find_opt st var in
  (match value with
  | None    -> failwith ("NameError: SStore.get, name '" ^ var ^ "' is not defined")
  | Some v  -> v) (* here, 'v' will always be an expr.Val *)

let find_all (st : t) (var : string) =
  Hashtbl.find_all st var

let exists (st : t) (var : string) =
  Hashtbl.mem st var;;

let string_of_store (st : t) : string =
  String.concat "\n" (Hashtbl.fold (fun x y z -> ("      " ^ x ^ "  ->  " ^ (Expression.string_of_expression y)) :: z ) st [])