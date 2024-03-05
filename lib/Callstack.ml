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

let pp (pp_val : Fmt.t -> 'v -> unit) (fmt : Fmt.t) (cs : 'store t) : unit =
  let open Fmt in
  let pp_frame fmt = function
    | Toplevel -> pp_str fmt "Toplevel"
    | Intermediate (store, cont, var) ->
        fprintf fmt "Intermediate: %a@.%a@.%s" (Store.pp pp_val) store
          (pp_lst "\n\t\t" Program.pp)
          cont var
  in
  pp_lst "\n" pp_frame fmt cs

let to_string (pp_val : Fmt.t -> 'v -> unit) (cs : 'v t) : string =
  Format.asprintf "%a" (pp pp_val) cs

let print (pp_val : Fmt.t -> 'v -> unit) (cs : 'v t) : unit =
  to_string pp_val cs |> print_endline
