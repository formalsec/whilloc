type 'v t = 'v list (* a conjunction over all the elements in the list *)

let create_pathcondition : 'v list = []
let add_condition (pc : 'v list) (t : 'v) : 'v list = t :: pc

let negate (pc : 'v list) : 'v =
  List.fold_right
    (fun x y -> Term.make_boperation Or (Term.negate x) y)
    pc Term.make_false

let pp (pp_val : Fmt.t -> 'v -> unit) (fmt : Fmt.t) (pc : 'value list) : unit =
  Fmt.fprintf fmt "%a" (Fmt.pp_lst " AND " pp_val) pc

let to_string (pp_val : Fmt.t -> 'v -> unit) (pc : 'v list) : string =
  Fmt.asprintf "%a" (pp pp_val) pc

let print (pp_val : Fmt.t -> 'v -> unit) (pc : 'v list) : unit =
  to_string pp_val pc |> print_endline
