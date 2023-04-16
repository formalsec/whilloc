module type M = sig
    type t
    type h
    val interpret : Program.program -> ?origin: (t,h) State.t -> unit -> (t,h) Return.t list * (t,h) State.t list
end