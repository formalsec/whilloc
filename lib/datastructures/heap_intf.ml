module type M = sig
  type t (* the representation of the heap itself *)
  type vt (* the type of the index and size of the arrays *)

  val init : unit -> t
  val to_string : t -> string

  val malloc :
    t -> vt -> vt PathCondition.t -> (t * vt * vt PathCondition.t) list

  val lookup :
    t -> vt -> vt -> vt PathCondition.t -> (t * vt * vt PathCondition.t) list

  val update :
    t -> vt -> vt -> vt -> vt PathCondition.t -> (t * vt PathCondition.t) list

  val free : t -> vt -> vt PathCondition.t -> (t * vt PathCondition.t) list
  val in_bounds : t -> vt -> vt -> vt PathCondition.t -> bool
  val clone : t -> t
end
