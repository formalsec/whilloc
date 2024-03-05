type t = (string * Value.t) list option [@@deriving yojson]

val empty : t
val get_value : t -> string -> Value.t
val pp : ?no_values:bool -> Format.formatter -> t -> unit
val to_string : t -> string
