module type M = sig
    type t
    val interpret : Program.program -> t Return.t list
end