type t = (string * Value.t) list option

val empty : t
val get_value : t -> string -> Value.t
val pp : Format.formatter -> t -> unit
val to_string : t -> string
