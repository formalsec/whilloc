module M (ConcreteEval : Eval.M) (SymbolicEval : Eval.M) : Eval.M with type t = (ConcreteEval.t * SymbolicEval.t) = struct

  type   t = ConcreteEval.t * SymbolicEval.t
  type  st = t Store.t

  (* let module Concolic = MakeConcolic.M (EvalConcrete.M) (EvalSymbolic.M) *)

  let project_store (store : st) : ConcreteEval.t Store.t * SymbolicEval.t Store.t =
    let key_values  = Hashtbl.fold (fun k v z -> (k, fst v) :: z) store [] in
    let key_symbols = Hashtbl.fold (fun k v z -> (k, snd v) :: z) store [] in
    let cstore = Store.create_store key_values  in
    let sstore = Store.create_store key_symbols in
    (cstore, sstore)

  let eval (store : st) (e : Expression.t) : t =
    let cstore,sstore = project_store store in
    (ConcreteEval.eval cstore e, SymbolicEval.eval sstore e)

  let is_true (exprs : t list) : bool =
    let values,expressions = List.split exprs in
    (ConcreteEval.is_true values) || (SymbolicEval.is_true expressions)

  let negate (e : t) : t =
    let value,expression = e in
    (ConcreteEval.negate value, SymbolicEval.negate expression)

  let to_string (e : t) : string =
    let value,expression = e in
    "Concrete:\n" ^ (ConcreteEval.to_string value) ^ "\nSymbolic\n" ^ (SymbolicEval.to_string expression)

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