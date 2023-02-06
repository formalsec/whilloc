module type M = sig
    
    type t

    val eval      : (t Store.t) -> Expression.t -> t
    val is_true   : t list -> bool
    val negate    : t -> t
    val print     : t -> unit
    val to_string : t -> string

    val make_symbol    : string -> t option

end