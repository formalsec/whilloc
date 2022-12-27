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
  let entry_point = "aenima" in
  let program     = filename |> read_file |> parse_program |> create_program in
  let prog_state  = Smallstep.interpret program entry_point in
  print_endline (Outcome.string_of_outcome prog_state)

let _ = main