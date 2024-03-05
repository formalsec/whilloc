module type M = sig
  type t (* the representation of the heap itself *)
  type vt (* the type of the index and size of the arrays *)

  val init : unit -> t
  val to_string : t -> string
  val malloc : t -> vt -> vt PC.t -> (t * vt * vt PC.t) list
  val lookup : t -> vt -> vt -> vt PC.t -> (t * vt * vt PC.t) list
  val update : t -> vt -> vt -> vt -> vt PC.t -> (t * vt PC.t) list
  val free : t -> vt -> vt PC.t -> (t * vt PC.t) list
  val in_bounds : t -> vt -> vt -> vt PC.t -> bool
  val clone : t -> t
end
