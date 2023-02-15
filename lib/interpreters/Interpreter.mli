module type M = sig
    type t
    (*
    Maybe add here the epsilon_map, in the symbolic case do Encoding.get_model and in the concrete case the model is the current store
    val epsilon : string -> Value.t
    The domain of this function coincides with the set of symbolic variable created during the execution of the program
    *)
    val interpret : Program.program -> t Return.t list
end