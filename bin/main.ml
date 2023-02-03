open Lib

let create_program (funcs : Program.func list) : Program.program = (*TODO assert pairwise distinct function ids*)
  let prog = Hashtbl.create 100 in
  List.iter (fun (f : Program.func) -> Hashtbl.replace prog f.id f) funcs;
  prog

let parse_program (str : string) : Program.func list =
  let lexbuf = Lexing.from_string str in
  let funcs  = Parser.program_target Lexer.read lexbuf in
  funcs

(*
let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let parse_with_error lexbuf =
  try Parser.prog Lexer.read lexbuf with
  | SyntaxError msg ->
    fprintf stderr "%a: %s\n" print_position lexbuf msg;
    None
  | Parser.Error ->
    fprintf stderr "%a: syntax error\n" print_position lexbuf;
    exit (-1)   
*)

let read_file (fname : string) : string =
  let ch = open_in fname in
  let str_file = really_input_string ch (in_channel_length ch) in
  close_in ch;
  str_file

let main =
  let filename    = Sys.argv.(1) in
  let program     = filename |> read_file |> parse_program |> create_program in

  let module I = MakeInterpreter.M (EvalSymbolic.M) (DFS.M) in
  let prog_return = I.interpret program in
  List.iter (Return.print Expression.string_of_expression) prog_return

(*
module I = MakeInterpreter.M (EvalSymbolic) (DFS)
module I = MakeInterpreter.M (EvalConcrete) (DFS)
I.interpret (...)

module I = MakeInterpreter.M (EvalSymbolic) (StateSymbolic) (DFS)
module I = MakeInterpreter.M (EvalConcrete) (StateConcrete) (DFS)
I.interpret (...)
*)   

  (*
  let ()          = print_endline "\n>>> Symbolic Interpreter" in
  let prog_return = Symbolic.interpret program in
  let ()          = List.iter Return.print_return prog_return in

  let ()          = print_endline "\n>>> Smallstep Interpreter" in
  let prog_state  = Smallstep.interpret program in
  let ()          = print_endline (Outcome.string_of_outcome prog_state ^ "\n") in

  let ()          = print_endline "\n>>> Bigstep Interpreter" in
  let prog_state  = Bigstep.interpret program in
                    print_endline (Outcome.string_of_outcome prog_state ^ "\n")
  *)

let _ = main