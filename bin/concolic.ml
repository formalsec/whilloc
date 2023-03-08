open Lib

module CC = MakeInterpreter.M (EvalConcolic.M) (DFS.M)

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

let rec concolic_loop (program : Program.program) (global_pc : Expression.t PathCondition.t) : bool = 
  
  if Encoding.is_sat global_pc then
  
    let model  = Encoding.get_model() in
    let ()     = SymbMap.update model in

    let returns,_ = CC.interpret program () in
    let return    = List.hd returns                in
    
    let state,outcome = return in

    match outcome with
    | Error _  -> Outcome.print outcome; false
    | _        ->
    let _,pc   = List.split (State.get_pathcondition state) in
    let neg_pc = PathCondition.negate pc in
    concolic_loop program (neg_pc :: global_pc)
  
  else
    let () = print_endline "No assertion violated\n\nExiting now..." in
    true

let main =
  
  let filename = Sys.argv.(1) in
  let program  = filename |> read_file |> parse_program |> create_program in
  print_endline "";
  let _        = concolic_loop program [ ] in
  ()

let _ = main