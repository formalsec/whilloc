include Format

type t = Format.formatter

let pp_int (fmt : t) (i : int) : unit = pp_print_int fmt i
let pp_float (fmt : t) (f : float) : unit = pp_print_float fmt f
let pp_char (fmt : t) (c : char) : unit = pp_print_char fmt c
let pp_str (fmt : t) (s : string) : unit = pp_print_string fmt s
let pp_bool (fmt : t) (b : bool) : unit = pp_print_bool fmt b

let pp_iter ?(pp_sep = pp_print_cut) (iter : ('a -> unit) -> 'b -> unit)
    (pp_el : t -> 'a -> unit) (fmt : t) (el : 'b) : unit =
  let is_first = ref true in
  let pp_el' el =
    if !is_first then is_first := false else pp_sep fmt ();
    pp_el fmt el
  in
  iter pp_el' el

let pp_hashtbl ?(pp_sep = pp_print_cut) (pp_v : t -> 'a * 'b -> unit) (fmt : t)
    (tbl : ('a, 'b) Hashtbl.t) =
  let hashtbl_iter f tbl = Hashtbl.iter (fun a b -> f (a, b)) tbl in
  pp_iter ~pp_sep hashtbl_iter pp_v fmt tbl

let pp_lst ?(pp_sep = pp_print_cut) (pp_v : t -> 'a -> unit) (fmt : t) (lst : 'a list) =
  pp_print_list ~pp_sep pp_v fmt lst
