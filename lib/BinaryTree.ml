type 'a t =
  | Nil
  | Node of 'a * 'a t * 'a t

let rec string_of_tree_preorder (tree : 'a t) (f : 'a -> string) : string =
  match tree with
  | Nil -> ""
  | Node (x, left, right) -> (f x) ^ (string_of_tree_preorder left f) ^ (string_of_tree_preorder right f)

let rec preorder (tree : 'a t) : 'a list =
  match tree with
  | Nil -> []
  | Node (x, left, right) ->  [x] @ preorder left @ preorder right

let preorder_tail (tree : 'a t) : 'a list =
  let rec pre_acc acc = function
    | Nil -> acc
    | Node (value, left, right) -> value :: (pre_acc (pre_acc acc right) left)
  in pre_acc [] tree

let rec size = function
  | Nil -> 0
  | Node (_, l, r) -> 1 + size l + size r

(* TODO converter to GraphViz format *)
let to_graphviz (tree : 'a t) : 'a list =
  preorder tree
(*
https://dreampuf.github.io/GraphvizOnline/
https://graphviz.org/   
*)