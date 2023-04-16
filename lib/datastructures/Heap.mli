module type M = sig

    type   t    (* the representation of the heap itself *)
    type  vt    (* the type of the index and size of the arrays *)

    val init   : unit -> t
    val malloc : t -> vt -> t PathCondition.t -> (t * vt * t PathCondition.t) list
    val lookup : t -> string -> vt -> t PathCondition.t -> (t * vt * t PathCondition.t) list
    val update : t -> string -> vt -> vt -> t PathCondition.t -> (t * t PathCondition.t) list
    val free   : t -> string -> t PathCondition.t -> (t * t PathCondition.t) list

end