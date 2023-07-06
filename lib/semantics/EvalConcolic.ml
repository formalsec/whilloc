module M : Eval_intf.M with type t = Value.t * Expression.t = struct

  type   t = Value.t * Expression.t
  type  st = t Store.t

  module EvalConcrete = EvalConcrete.M
  module EvalSymbolic = EvalSymbolic.M

  let project_store (store : st) : Value.t Store.t * Expression.t Store.t =
    let key_values     = Store.fold (fun k v z -> (k, fst v) :: z) store [] in
    let key_symbols    = Store.fold (fun k v z -> (k, snd v) :: z) store [] in
    let concrete_store = Store.create_store key_values  in
    let symbolic_store = Store.create_store key_symbols in
    (concrete_store, symbolic_store)

  let eval (store : st) (e : Expression.t) : t =
    let cstore,sstore = project_store store in
    (EvalConcrete.eval cstore e, EvalSymbolic.eval sstore e)

  let is_true (exprs : t list) : bool =
    let v,_ = List.split exprs in
    EvalConcrete.is_true v
  
  let may_be_true (exprs : t list) : bool = 
    let _, exprs' = List.split exprs in 
    Translator.is_sat exprs'

  let test_assert (exprs : t list) : bool * Model.t =
    let _,e = List.split exprs in
    EvalSymbolic.test_assert e

  let negate (e : t) : t =
    let value,expression = e in
    (EvalConcrete.negate value, EvalSymbolic.negate expression)

  let to_string (e : t) : string =
    let value,expression = e in
    "(" ^ (EvalConcrete.to_string value) ^ ", " ^ (EvalSymbolic.to_string expression) ^ ")"

  let print (e : t) : unit =
    to_string e |> print_endline

  let make_symbol (name : string) (tp : string) =
    let symbolic_name  = Parameters.symbol_prefix ^ name in
    let symbolic_value =
      if String.equal "bool" tp
        then Expression.make_symb_bool symbolic_name
      else Expression.make_symb_int symbolic_name in
    let concrete_value =
    match (SymbMap.map symbolic_name) with
      | None   -> Value.Integer (Utils.random_int ())
      | Some v -> v
    in
    Some (concrete_value, symbolic_value)

end
