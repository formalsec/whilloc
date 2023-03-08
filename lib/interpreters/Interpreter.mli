module type M = sig
    type t
    val interpret : Program.program -> ?origin:t State.t -> unit -> t Return.t list * t State.t list
end