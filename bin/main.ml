open Lib
open Utils

module C  = MakeInterpreter.M (EvalConcrete.M) (DFS.M) (HeapConcrete.M)
(* module S  = MakeInterpreter.M (EvalSymbolic.M) (DFS.M) (HeapSymbolic.M) *)
module S  = MakeInterpreter.M (EvalSymbolic.M) (DFS.M) (HeapTree.M)
module CC = MakeInterpreter.M (EvalConcolic.M) (DFS.M) (HeapConcolic.M)

let rec concolic_loop (program : Program.program) (global_pc : Expression.t PathCondition.t) (outs : (CC.t, CC.h) Return.t list) : (CC.t, CC.h) Return.t list = 

  if Encoding.is_sat global_pc then

    let model   = Encoding.get_model ~print_model:true () in
    let ()      = SymbMap.update model  in

    let returns,conts = CC.interpret program () in
    
    ignore conts;

    let return  = List.hd returns in
    let state,_ = return          in

    let _,pc    = List.split (State.get_pathcondition state) in
    let neg_pc  = PathCondition.negate pc                    in

    concolic_loop program (neg_pc::global_pc) (return::outs)
  
  else
    let _ = SymbMap.clear () in
    outs

let main =
  print_string "\n=====================\n\tÆnima\n=====================\n\n";
  arguments();

  if (!file = "" && !mode = "" && !out = "") then (print_string "\nNo option selected. Use -h\n";)
  else if (!file = "") then (print_string "No input file. Use -i\n\n=====================\n\tFINISHED\n=====================\n";)
  else if (!mode = "") then (print_string "No mode selected. Use -m\n\n=====================\n\tFINISHED\n=====================\n";)
  else if (!out  = "") then (print_string "No output file. Use -o\n\n=====================\n\tFINISHED\n=====================\n";)
  
  else

  let program   = !file |> read_file |> parse_program |> create_program in
  let meta_data = Printf.sprintf ("Input file: %s\nExecution mode: %s\nOutput file: %s\n\n") !file !mode !out in

  let str_of_returns =
  match !mode with

    | "c"   -> let returns,_ = C.interpret program () in
               String.concat "\n" (List.map (Return.string_of_return EvalConcrete.M.to_string) returns)
             
    | "s"   -> let returns,_ = S.interpret program () in
               String.concat "\n" (List.map (Return.string_of_return EvalSymbolic.M.to_string) returns)
    
    | "cc"  -> let returns   = concolic_loop program [ ] [ ] in
               String.concat "\n" (List.map (Return.string_of_return EvalConcolic.M.to_string) returns)
             
    | _   -> invalid_arg "Unknown provided mode. Available modes are:\n  c : for concrete interpretation\n  s : for symbolic interpretation\n  cc : for concolic interpretation"

  in write_file !out (meta_data ^ str_of_returns);
  print_string "\n=====================\n\tExiting\n=====================\n\n"

let _ = main