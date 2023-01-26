module type M = sig
  
  (* state type *)
  type t 

  (* value type *)
  type vt 

  val get_conf : t -> Program.stmt list

  val set : t -> string -> vt -> unit 
  
  val eval_expression : t -> Expression.t -> vt 

  val make_symbol : t -> string -> vt 

  val val_to_string : t -> vt -> string 

end 
