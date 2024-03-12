module type M = sig
  type t (* the representation of the heap itself *)
  type vt (* the type of the index and size of the arrays *)

  module Eval : Eval_intf.M with type t = vt

  val init : unit -> t
  val pp : Fmt.t -> t -> unit
  val to_string : t -> string
  val malloc : t -> vt -> vt Pc.t -> (t * vt * vt Pc.t) list
  val lookup : t -> vt -> vt -> vt Pc.t -> (t * vt * vt Pc.t) list
  val update : t -> vt -> vt -> vt -> vt Pc.t -> (t * vt Pc.t) list
  val free : t -> vt -> vt Pc.t -> (t * vt Pc.t) list
  val in_bounds : t -> vt -> vt -> vt Pc.t -> bool
  val clone : t -> t
end
