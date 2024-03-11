module type S = sig
  type t
  type h
  type state = (t, h) Sstate.t

  val interpret : Program.program -> (Outcome.t * state) list
end
