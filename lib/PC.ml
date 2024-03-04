type 'v t = 'v list (* a conjunction over all the elements in the list *)

let create_pathcondition : 'v list = []
let add_condition (pc : 'v list) (t : 'v) : 'v list = t :: pc

let negate (pc : 'v list) : 'v =
  List.fold_right
    (fun x y -> Term.make_boperation Or (Term.negate x) y)
    pc Term.make_false

let to_string (to_string : 'v -> string) (pc : 'v list) : string =
  let rec aux pc : string list =
    match pc with [] -> [] | h :: t -> to_string h :: aux t
  in
  String.concat " AND " (aux pc)
(* ∧ *)

let print (str : 'v -> string) (pc : 'v t) : unit =
  to_string str pc |> print_endline
