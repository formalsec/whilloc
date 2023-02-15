module M : Eval.M with type t = Value.t * Expression.t = struct
  
  type   t = Value.t * Expression.t
  type  st = t Store.t

  module EvalConcrete = EvalConcrete.M
  module EvalSymbolic = EvalSymbolic.M

  let project_store (store : st) : Value.t Store.t * Expression.t Store.t =
    let key_values  = Store.fold (fun k v z -> (k, fst v) :: z) store [] in
    let key_symbols = Store.fold (fun k v z -> (k, snd v) :: z) store [] in
    let cstore = Store.create_store key_values  in
    let sstore = Store.create_store key_symbols in
    (cstore, sstore)

  let eval (store : st) (e : Expression.t) : t =
    let cstore,sstore = project_store store in
    (EvalConcrete.eval cstore e, EvalSymbolic.eval sstore e)

  let is_true (exprs : t list) : bool =
    let values,expressions = List.split exprs in
    (EvalConcrete.is_true values) || (EvalSymbolic.is_true expressions)

  let negate (e : t) : t =
    let value,expression = e in
    (EvalConcrete.negate value, EvalSymbolic.negate expression)

  let to_string (e : t) : string =
    let value,expression = e in
    "Concrete:\n" ^ (EvalConcrete.to_string value) ^ "\nSymbolic\n" ^ (EvalSymbolic.to_string expression)

  let print (e : t) : unit =
    to_string e |> print_endline

  let make_fresh_symb_generator (pref : string) : (unit -> string) =
    let count = ref 1 in
    fun () -> let x = !count in
      count := x+1; pref ^ (string_of_int x)

  let generate_fresh_var = make_fresh_symb_generator Parameters.symbol_prefix

  let make_symbol (name : string) =
    let symb_name   = generate_fresh_var() ^ "__" ^ name in
    let symb_value  = Value.SymbVal symb_name in
    let init_value  = Random.int 100 in
    Some (Value.Integer init_value, Expression.Val symb_value)

end