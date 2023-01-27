module type State = sig

  (* state type *)
  type t 

  (* value type *)
  type value

  (* store type *)
  type store
  
  (*
  callstack ???
  type cs
  path cond ??? 
  type pc
  *)

  val get_stmt : t -> Program.stmt list

  val get_continuation : t -> Program.stmt list

  val get_store : store -> .stmt list

  val create_store : (string * Expression.value) list -> store

  val set : store -> string -> value -> unit

  val get : store -> string -> value 

  val is_symbolic_expression : store -> Expression.expr -> bool
  
  val eval_expression : store -> Expression.t -> value 

  (* val make_symbol : t -> string -> value *) (* do I really need this in the signature? *)

  val string_of_t : t -> string

  val string_of_value : t -> value -> string
  
  val top : t -> t (* FIXME idk the type of this thing*)

  val pop : t -> t

  val push : t -> t

  exception EmptyStack
  exception NameError

end
