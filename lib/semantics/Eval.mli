module type M = sig
    
    type t

    val eval      : (t Store.t) -> Expression.t -> t
    val is_true   : t list -> bool
    val negate    : t -> t
    val print     : t -> unit
    val to_string : t -> string

    val add_condition  : t PathCondition.t -> t -> t PathCondition.t
    val make_symbol    : string -> t (*TODO fazer t option e tratar o caso None*)

end