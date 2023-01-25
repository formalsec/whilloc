(* Idea: have a Search directory (module). in there, we can have DFS.ml, BFS.ml, Heuristics.ml, etc...*)

(*
pick_head + join_push    = DFS = pick_last + join_enqueue
pick_head + join_enqueue = BFS = pick_last + join_push
*)

let pick_head (states : SState.t list) : (SState.t * SState.t list) =
  match states with
  | []     -> failwith "InternalError: Tried to pick a state to expand from an empty collection of states"
  | h :: t -> h,t

let pick_last (states : SState.t list) : (SState.t * SState.t list) =
  let rec aux (states : SState.t list) (acc : SState.t list): (SState.t * SState.t list) =
    match states with
    | []     -> failwith "InternalError: Tried to pick a state to expand from an empty collection of states"
    | [h]    -> h,(List.rev acc) (*meh*)
    | h :: t -> aux t (h::acc) 
  in aux states []

let join_push (new_states : SState.t list) (old_states : SState.t list) : SState.t list =
  new_states @ old_states

let join_enqueue (new_states : SState.t list) (old_states : SState.t list) : SState.t list =
  old_states @ new_states

let is_final (result : Return.t) : bool = (*TODO learn how to code pls*)
  let st,out = result in
  let (stmt',cont',_,_,_) = st in
  if stmt'=Program.Skip && cont'=[] && out=Cont then failwith "BadProgram: Symbolic, functions should always return a value"
  else
  match out with
  | Cont -> false
  | AssumeF  -> true
  | Error    -> true
  | Return _ -> true
