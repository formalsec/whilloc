module type M = sig
  type t

  val eval : t Store.t -> Expression.t -> t
  val is_true : t list -> bool
  val test_assert : t list -> bool * Model.t
  val negate : t -> t
  val to_string : t -> string
  val print : t -> unit
  val make_symbol : string -> string -> t option
end
