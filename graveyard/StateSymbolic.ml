module M : State_i.M = struct

  open Expression
  open Program
  open Outcome
  
  type t = Expression.t

  (* Getters *)
  let get_stmt  state = let stmt,_,_,_,_=state in stmt
  let get_cont  state = let _,cont,_,_,_=state in cont
  let get_store state = let _,_,st,_,_  =state in st
  let get_cs    state = let _,_,_,cs,_  =state in cs
  let get_pc    state = let _,_,_,_,pc  =state in pc

  (* State *)
  let create_initial_state program =
    let main  = Program.get_function Parameters.main_id program in
    let store = Store.create_empty_store Parameters.size in
    let cs    = [Callstack.Toplevel] in
    let pathc = [Val (Boolean true)] in
    (Skip, [main.body], store, cs, pathc)

  let is_final result =
    let state,out = result in
    let (stmt',cont',_,_,_) = state in
    if stmt'=Skip && cont'=[] && out=Cont then failwith "BadProgram: StateConcrete.is_final, functions should always return a value"
    else
    match out with
    | Cont     -> false
    | AssumeF  -> true
    | Error    -> true
    | Return _ -> true

  (* Store *)
  let set (store : t Store.t) (var : string) (v : t) : unit      = Store.set store var v
  let get (store : t Store.t) (var : string)         : t         = Store.get store var
  let dup (store : t Store.t)                        : t Store.t = Store.dup store
  
  (* Callstack *)
  let push (cs : t Callstack.t) (f : t Callstack.frame)  : t Callstack.t     = Callstack.push cs f
  let top  (cs : t Callstack.t)                          : t Callstack.frame = Callstack.top cs
  let pop  (cs : t Callstack.t)                          : t Callstack.t     = Callstack.pop cs

  (* Path condition*)
  let add_condition pc t = t::pc


  (* ------------------------- *)


  (* Symbols X̂x̂ *)
  let make_fresh_symb_generator (pref : string) : (unit -> string) =
    let count = ref 1 in
    fun () -> let x = !count in
      count := x+1; pref ^ (string_of_int x)

  let generate_fresh_var = make_fresh_symb_generator Parameters.symbol

  let make_symbol (name : string) = 
    Val (SymbVal ( generate_fresh_var() ^ "__" ^ name) )

end