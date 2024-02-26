type ('v, 'h) t = {
  store : 'v Store.t;
  cs : 'v Callstack.t;
  pc : 'v PathCondition.t;
  heap : 'h;
}

let to_string (str : 'v -> string) (heap_str : 'h -> string)
    (state : ('v, 'h) t) : string =
  " -Store         : "
  ^ Store.to_string str state.store
  ^ "\n" ^ " -Callstaack    : "
  ^ Callstack.to_string str state.cs
  ^ "\n" ^ " -Path cond.    : "
  ^ PathCondition.to_string str state.pc
  ^ "\n" ^ " -Heap          : " ^ heap_str state.heap

let print (str : 'v -> string) (heap_str : 'h -> string) (state : ('v, 'h) t) :
    unit =
  print_endline (to_string str heap_str state)

let dup (state : ('v, 'h) t) heap_dup : ('v, 'h) t =
  {
    state with
    store = Store.dup state.store;
    cs = Callstack.dup state.cs;
    heap = heap_dup state.heap;
  }
