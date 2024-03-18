module type M = sig
  type t (* the representation of the heap itself *)
  type value (* the type of the index and size of the arrays *)

  val init : unit -> t
  val pp : Fmt.t -> t -> unit
  val to_string : t -> string
  val malloc : t -> value -> value Pc.t -> (t * value * value Pc.t) list
  val lookup : t -> value -> value -> value Pc.t -> (t * value * value Pc.t) list
  val update : t -> value -> value -> value -> value Pc.t -> (t * value Pc.t) list
  val free : t -> value -> value Pc.t -> (t * value Pc.t) list
  val in_bounds : t -> value -> value -> value Pc.t -> bool
  val clone : t -> t
end
