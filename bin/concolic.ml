open Lib

open Expression
open Value

module C = MakeInterpreter.M (EvalConcolic.M) (DFS.M)

let create_program (funcs : Program.func list) : Program.program = (*TODO assert pairwise distinct function ids*)
  let prog = Hashtbl.create 100 in
  List.iter (fun (f : Program.func) -> Hashtbl.replace prog f.id f) funcs;
  prog

let parse_program (str : string) : Program.func list =
  let lexbuf = Lexing.from_string str in
  let funcs  = Parser.program_target Lexer.read lexbuf in
  funcs

let read_file (fname : string) : string =
  let ch = open_in fname in
  let str_file = really_input_string ch (in_channel_length ch) in
  close_in ch;
  str_file

let rec concolic_loop program (global_pc : Expression.t PathCondition.t) : bool = 
  if Encoding.is_sat global_pc then
    (*model = Encoding.get_model global_pc in TODO get_model*)
    let returns = C.interpret program in (* model needs to enter here somehow *)
    let return  = List.hd returns in
    if Return.outcome return = Outcome.Error then
      false
    else
      let _,npc = List.split (Return.pc return) in
      let npc   = List.map Expression.negate npc  in (* BUG! the negation of this pc, which is a conjunction of expressions, is not the conjunction of each clause negated *)  
      concolic_loop program (npc @ global_pc) 
  else
    true

let main =
  
  let filename = Sys.argv.(1) in
  let program  = filename |> read_file |> parse_program |> create_program in
  let _        = concolic_loop program [ Val (Boolean true) ] in
  ()

let _ = main