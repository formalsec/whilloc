module type Choice = sig
  type 'a t
  type v
  type h
  type state = (v, h) SState.t

  val return : 'a -> 'a t
  val bind : 'a t -> ('a -> 'b t) -> 'b t
  val get : state t
  val set : state -> unit t
  val select : v -> bool t
  val lift : (state -> ('a * state) list) -> 'a t
  val run : state -> 'a t -> ('a * state) list
end
