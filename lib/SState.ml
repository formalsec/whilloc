type ('v, 'h) t = {
  store : 'v Store.t;
  cs : 'v Callstack.t;
  pc : 'v PC.t;
  heap : 'h;
}

let pp (pp_val : Fmt.t -> 'v -> unit) (pp_heap : Fmt.t -> 'h -> unit)
    (fmt : Format.formatter) (state : ('v, 'h) t) : unit =
  Format.fprintf fmt
    "{@.-Store         : %a@.-Callstack     : %a@.-Path cond.    : \
     %a@.-Heap          : %a@.}"
    (Store.pp pp_val) state.store (Callstack.pp pp_val) state.cs (PC.pp pp_val)
    state.pc pp_heap state.heap

let to_string (pp_val : Fmt.t -> 'v -> unit) (pp_heap : Fmt.t -> 'h -> unit)
    (state : ('v, 'h) t) : string =
  Format.asprintf "%a" (pp pp_val pp_heap) state

let print (pp_val : Fmt.t -> 'v -> unit) (pp_heap : Fmt.t -> 'h -> unit)
    (state : ('v, 'h) t) : unit =
  to_string pp_val pp_heap state |> print_endline

let dup (state : ('v, 'h) t) heap_dup : ('v, 'h) t =
  {
    state with
    store = Store.dup state.store;
    cs = Callstack.dup state.cs;
    heap = heap_dup state.heap;
  }
