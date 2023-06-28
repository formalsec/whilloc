module type M = sig
    type t
    type h
    type state = (t,h) SState.t

    val interpret : Program.program -> (Outcome.t * state) list 
end