type 'a t =
  | Nil
  | Node of 'a * 'a t * 'a t

let rec fold_tree (f : 'b -> 'a -> 'a -> 'a) (e : 'a) (tree : 'b t) : 'a =
  match tree with
  | Nil -> e
  | Node (x, left, right) -> f x (fold_tree f e left) (fold_tree f e right)

let size     (tree : 'a t) = fold_tree (fun _ l r -> 1 + l + r) 0 tree
let depth    (tree : 'a t) = fold_tree (fun _ l r -> 1 + max l r) 0 tree
let preorder (tree : 'a t) = fold_tree (fun x l r -> [x] @ l @ r) [] tree
let string_of_tree_preorder (f : 'a -> string) (tree : 'a t) = List.map f (preorder tree)

let rec add_left (tree : 'a t) (x : 'a) : 'a t =
  let subtree = Node (x,Nil,Nil) in
  match tree with
  | Nil -> subtree
  | Node (v, left, right) when left ==Nil -> Node (v, subtree, right)
  | Node (v, left, right) when right==Nil -> Node (v, left, subtree)
  | Node (v, left, right) -> Node (v, add_left left x, right)

let rec add_right (tree : 'a t) (x : 'a) : 'a t =
  let subtree = Node (x,Nil,Nil) in
  match tree with
  | Nil -> subtree
  | Node (v, left, right) when right==Nil -> Node (v, left, subtree)
  | Node (v, left, right) when left ==Nil -> Node (v, subtree, right)
  | Node (v, left, right) -> Node (v, left, add_right right x)

let rec string_of_tree (prefix : string) (is_left : bool) (f : 'a -> string) (tree : 'a t) : string =
  match tree with
  | Nil -> ""
  | Node (x, l , r) ->
    let helper,next_prefix = if is_left then "├──","│   " else "└──","    " in
    prefix ^ helper ^ (f x) ^ "\n" ^ (string_of_tree (prefix^next_prefix) true f l) ^ (string_of_tree (prefix^next_prefix) false f r)

let print_tree (f : 'a -> string) (tree : 'a t) : unit = 
  print_endline (string_of_tree "" false f tree)

  (*use program lines to simultaneously identify each node of the graph and its statement *)
let to_graphviz (f : 'a -> string) (tree : 'a t) : string =
  let header = "strict graph {\n  size=\"6,6\";\n  node [color=lightblue2, style=filled];\n\n  " in
  let rec aux = function
  | Nil -> ""
  | Node (x, (Node (xl, _, _) as left ) , (Node (xr, _, _) as right ) ) -> ((f x) ^ " -- {" ^ (f xl) ^ " " ^ (f xr) ^ "}\n  ") ^ (aux left) ^ (aux right)
  | Node (x, (Node (xl, _, _) as left ) , Nil )  -> ((f x) ^ " -- {" ^ (f xl) ^ "}\n  ") ^ (aux left)
  | Node (x, Nil , (Node (xr, _, _) as right ) ) -> ((f x) ^ " -- {" ^ (f xr) ^ "}\n  ") ^ (aux right)
  | Node (x, Nil, Nil ) -> (f x) ^ "\n  "
in
header ^ (aux tree) ^ "}"