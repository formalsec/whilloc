type ('v, 'h) t = ('v, 'h) State.t * Outcome.t

let pp (pp_val : Fmt.t -> 'v -> unit) (pp_heap : Fmt.t -> 'h -> unit)
    (fmt : Fmt.t) (ret : ('v, 'h) t) : unit =
  let open Fmt in
  let (_, _, st, _, pc, h), out = ret in
  fprintf fmt
    "#RETURN:@\n -Outcome   : %a@\n -Store     : %a@\n -Path cond.: %a@\n \
     -Heap      : %a@\n"
    (Outcome.pp ~no_values:false)
    out (Store.pp pp_val) st (PC.pp pp_val) pc pp_heap h

let string_of_return (pp_val : Fmt.t -> 'v -> unit)
    (pp_heap : Fmt.t -> 'h -> unit) (ret : ('v, 'h) t) : string =
  Format.asprintf "%a" (pp pp_val pp_heap) ret

let get_outcome (ret : ('v, 'h) t) : Outcome.t =
  let _, out = ret in
  out

let get_pc (ret : ('v, 'h) t) : 'v PC.t =
  let state, _ = ret in
  State.get_pathcondition state

let print (pp_val : Fmt.t -> 'v -> unit) (pp_heap : Fmt.t -> 'h -> unit)
    (ret : ('v, 'h) t) : unit =
  print_endline (string_of_return pp_val pp_heap ret)
