type 'v frame =
  | Intermediate of ('v Store.t * Program.stmt list * string)
  | Toplevel

type 'v t = 'v frame list

exception EmptyStack of string

let create_callstack : 'v t = [ Toplevel ]

let top (cs : 'v t) : 'v frame =
  match cs with
  | [] -> raise (EmptyStack "Callstack.top: tried to peek from an empty stack")
  | top :: _ -> top

let pop (cs : 'v t) : 'v t =
  match cs with
  | [] -> raise (EmptyStack "Callstack.pop: tried to pop from an empty stack")
  | _ :: t -> t

let push (cs : 'v t) (f : 'v frame) : 'v t = f :: cs

let rec dup (cs : 'v t) : 'v t =
  match cs with
  | [] -> failwith "InternalError: Callstack.dup, empty callstack"
  | [ h ] ->
      assert (h = Toplevel);
      [ h ]
  | h :: t -> (
      match h with
      | Toplevel -> [ h ]
      | Intermediate (store, cont, var) ->
          Intermediate (Store.dup store, cont, var) :: dup t)

let to_string (str : 'v -> string) (cs : 'v t) : string =
  let f x y =
    match x with
    | Toplevel -> "_Toplevel_\n" ^ y
    | Intermediate (store, cont, var) ->
        "_Intermediate_:\n\t" ^ var ^ "\n\t\t"
        ^ String.concat "\n\t\t" (List.map Program.string_of_stmt cont)
        ^ "\n\t" ^ Store.to_string str store ^ "\n" ^ y
  in
  List.fold_right f cs ""

let print (str : 'v -> string) (cs : 'v t) : unit =
  to_string str cs |> print_endline
