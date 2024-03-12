module M : Eval_intf.M with type t = Value.t * Encoding.Expr.t = struct
  type t = Value.t * Encoding.Expr.t
  type st = t Store.t

  module Eval_concrete = Eval_concrete.M
  module Eval_symbolic = Eval_symbolic.M
  module E = Encoding.Expr
  module T = Encoding.Ty
  module S = Encoding.Symbol

  let project_store (store : st) : Value.t Store.t * Encoding.Expr.t Store.t =
    let key_values = Store.fold (fun k v z -> (k, fst v) :: z) store [] in
    let key_symbols = Store.fold (fun k v z -> (k, snd v) :: z) store [] in
    let concrete_store = Store.create_store key_values in
    let symbolic_store = Store.create_store key_symbols in
    (concrete_store, symbolic_store)

  let eval (store : st) (e : Term.t) : t =
    let cstore, sstore = project_store store in
    (Eval_concrete.eval cstore e, Eval_symbolic.eval sstore e)

  let is_true (exprs : t list) : bool =
    let v, _ = List.split exprs in
    Eval_concrete.is_true v

  let test_assert (exprs : t list) : bool * Model.t =
    let _, e = List.split exprs in
    Eval_symbolic.test_assert e

  let negate (e : t) : t =
    let value, expression = e in
    (Eval_concrete.negate value, Eval_symbolic.negate expression)

  let pp (fmt : Fmt.t) (e : t) : unit =
    let value, expression = e in
    Fmt.fprintf fmt "(%a, %a)" Eval_concrete.pp value Eval_symbolic.pp
      expression

  let to_string (e : t) : string = Fmt.asprintf "%a" pp e
  let print (e : t) : unit = to_string e |> print_endline

  let make_symbol (name : string) (tp : string) =
    let symbolic_name = Parameters.symbol_prefix ^ name in
    let symbolic_value =
      if String.equal "bool" tp then
        E.mk_symbol (S.mk_symbol T.Ty_bool symbolic_name)
      else E.mk_symbol (S.mk_symbol T.Ty_int symbolic_name)
    in
    let concrete_value =
      match Symb_map.map symbolic_name with
      | None -> Value.Integer (Utils.random_int ())
      | Some v -> v
    in
    Some (concrete_value, symbolic_value)
end
