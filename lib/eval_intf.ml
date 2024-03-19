module type M = sig
  type t

  val eval : t Store.t -> Expr.t -> t
  val is_true : t list -> bool
  val test_assert : t list -> bool * Model.t
  val negate : t -> t
  val pp : Fmt.t -> t -> unit
  val to_string : t -> string
  val print : t -> unit
  val make_symbol : string -> string -> t option
end
