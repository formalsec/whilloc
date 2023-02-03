open Program
open Outcome

let create_initial_state program =
  let main  = Program.get_function Parameters.main_id program in
  let store = Store.create_empty_store Parameters.size in
  let cs    = Callstack.create_callstack in
  let pathc = PathCondition.create_pathcondition in
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

(*
let is_final out =
  match out with
  | Cont     -> false
  | _        -> true

let assert_correct_state state out : unit =
  let (stmt',cont',_,_,_) = state in
  if stmt'=Skip && cont'=[] && out=Cont then failwith "BadProgram: functions should always return a value"
  else ()   
*)