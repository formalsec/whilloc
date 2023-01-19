open Lib

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

let main =
  let filename    = Sys.argv.(1) in
  let entry_point = "aenima" in (*Ænima*)
  let program     = filename |> read_file |> parse_program |> create_program in

  let ()          = print_endline "\n>>> Symbolic Interpreter" in
  let prog_return = Symbolic.interpret program entry_point in
  let ()          = List.iter Return.print_return prog_return in

  let ()          = print_endline "\n>>> Smallstep Interpreter" in
  let prog_state  = Smallstep.interpret program entry_point in
  let ()          = print_endline (Outcome.string_of_outcome prog_state ^ "\n") in

  let ()          = print_endline "\n>>> Bigstep Interpreter" in
  let prog_state  = Bigstep.interpret program entry_point in
                    print_endline (Outcome.string_of_outcome prog_state ^ "\n")

let _ = main