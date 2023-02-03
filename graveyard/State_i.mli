module type M = sig
    
    type t

    (* Getters *)
    val get_stmt  : t State.t -> Program.stmt
    val get_cont  : t State.t -> Program.stmt list
    val get_store : t State.t -> t Store.t
    val get_cs    : t State.t -> t Callstack.t
    val get_pc    : t State.t -> PathCondition.t

    (* State *)
    val create_initial_state : Program.program -> t State.t
    val is_final : t Return.t-> bool

    (* Symbols *)
    val make_symbol : string -> t

    (* Store *)
    val set : t Store.t -> string -> t -> unit
    val get : t Store.t -> string -> t
    val dup : t Store.t -> t Store.t

    (* Callstack *)
    val push : t Callstack.t -> t Callstack.frame -> t Callstack.t
    val pop  : t Callstack.t -> t Callstack.t 
    val top  : t Callstack.t -> t Callstack.frame

    (* Path condition*)
    val add_condition : t list -> t -> t list
    
end
