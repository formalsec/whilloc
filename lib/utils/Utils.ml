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

let write_file (fname : string) (text : string) : unit =
  let oc = open_out fname in
  Printf.fprintf oc "%s\n" text;
  close_out oc

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