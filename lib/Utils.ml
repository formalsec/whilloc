let file = ref ""
let mode = ref ""
let out = ref ""
let verbose = ref false
let time = ref 0.0

let create_program (funcs : Program.func list) : Program.program =
  let prog = Hashtbl.create Parameters.size in
  let replace (prog : Program.program) (func : Program.func) =
    let f = Hashtbl.find_opt prog func.id in
    match f with
    | None -> Hashtbl.replace prog func.id func
    | Some _ -> failwith "BadProgram: function names must pairwise distinct"
  in
  List.iter (fun func -> replace prog func) funcs;
  prog

let parse_program (str : string) : Program.func list =
  let lexbuf = Lexing.from_string str in
  let funcs = Parser.program_target Lexer.read lexbuf in
  funcs

let read_file (fname : string) : string =
  let ch = open_in fname in
  let str_file = really_input_string ch (in_channel_length ch) in
  close_in ch;
  str_file

let write_file (fname : string) (text : string) : unit =
  let out_file = fname ^ "/output" in
  if not (Sys.file_exists fname) then ignore (Sys.command ("mkdir -p " ^ fname));
  let oc = open_out out_file in
  Printf.fprintf oc "%s\n" text;
  close_out oc

let arguments () =
  let usage_msg =
    "Usage: -i <path> -mode <c/p> -o <path> [-v|-s] -h <path> [--parse]"
  in
  Arg.parse
    [
      ("-i", Arg.String (fun f -> file := f), "Input file");
      ( "-m",
        Arg.String (fun m -> mode := m),
        "Mode to run: c - Concrete / saf - Symbolic with Array Fork Memory / \
         saite - Symbolic with Array ITE Memory / sopl - Symbolic with \
         Operation List Memory / st - Symbolic with Tree Memory" );
      ("-o", Arg.String (fun o -> out := o), "Output file");
      ("-v", Arg.Set verbose, "Verbose");
    ]
    (fun s -> Printf.printf "Ignored Argument: %s" s)
    usage_msg

let random_int () = Random.int Parameters.max_int

let time_call (desc : string) (f : unit -> 'a) : 'a =
  let start = Sys.time () in
  let result = f () in
  let delta = Sys.time () -. start in
  Printf.printf "Execution time of %s: %f\n" desc delta;
  result

let total_time_call (desc : string) (acc : float ref) (f : unit -> 'a) : 'a =
  let start = Sys.time () in
  let result = f () in
  let delta = Sys.time () -. start in
  if !verbose (* && delta > 0.99 *) then
    Printf.printf "Execution time of %s: %f\n" desc delta;
  acc := !acc +. delta;
  result
