open Lib

let create_program (funcs : Program.func list) : Program.program =
  let prog    = Hashtbl.create Parameters.size in
  let replace =
    fun (prog : Program.program) (func : Program.func) ->
      let f = (Hashtbl.find_opt prog func.id) in
      match f with
        | None   -> Hashtbl.replace prog func.id func
        | Some _ -> failwith "BadProgram: function names must pairwise distinct" in
  List.iter (fun func -> replace prog func) funcs;
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
  let filename = Sys.argv.(1) in
  let program  = filename |> read_file |> parse_program |> create_program in
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