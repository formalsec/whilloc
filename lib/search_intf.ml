module type M = sig
  val pick : 't list -> 't * 't list
  val join : 't list -> 't list -> 't list
end
