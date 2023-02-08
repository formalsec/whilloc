open Lib

let file = ref ""
let mode = ref ""
let out = ref ""
let verbose = ref false


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

let arguments () =

  let usage_msg = "Usage: -i <path> -mode <c/p> -o <path> [-v|-s] -h <path> [--parse]" in
  Arg.parse
    [
      ("-i"   , Arg.String (fun f -> file := f ), "Input file");
      ("-m"   , Arg.String (fun m -> mode := m ), "Mode to run: c - Concrete / s - Symbolic ");
      ("-o"   , Arg.String (fun o -> out  := o ), "Output file");
      ("-v"   , Arg.Set verbose, "Verbose")
    ]
    (fun s -> Printf.printf "Ignored Argument: %s" s)
    usage_msg

let main =
  print_string "\n=====================\n\tÆnima\n=====================\n\n";
  arguments();

  if (!file = "" && !mode = "" && !out = "") then (print_string "\nNo option selected. Use -h\n";)
  else if (!file = "") then (print_string "No input file. Use -i\n\n=====================\n\tFINISHED\n=====================\n";)
  else if (!mode = "") then (print_string "No mode selected. Use -mode\n\n=====================\n\tFINISHED\n=====================\n";)
  else if (!out  = "") then (print_string "No output file. Use -o\n\n=====================\n\tFINISHED\n=====================\n";)
  
  else

  let program  = !file |> read_file |> parse_program |> create_program in
  let module S = MakeInterpreter.M (EvalSymbolic.M) (DFS.M) in
  let module C = MakeInterpreter.M (EvalConcrete.M) (DFS.M) in

  match !mode with
    | "c" -> List.iter (Return.print Value.string_of_value)           (C.interpret program)
    | "s" -> List.iter (Return.print Expression.string_of_expression) (S.interpret program)
    | _   -> invalid_arg "Unknown provided mode. Available modes are:\n  s : for symbolic interpretation\n  c : for concrete interpretation\n"

let _ = main