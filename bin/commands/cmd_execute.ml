open Whilloc
open Utils
module C_Choice = ListChoice.Make (EvalConcrete.M) (HeapConcrete.M)
module SAF_Choice = ListChoice.Make (EvalSymbolic.M) (HeapArrayFork.M)
module SAITE_Choice = ListChoice.Make (EvalSymbolic.M) (HeapArrayITE.M)
module ST_Choice = ListChoice.Make (EvalSymbolic.M) (HeapTree.M)
module SOPL_Choice = ListChoice.Make (EvalSymbolic.M) (HeapOpList.M)
module C = Interpreter.Make (EvalConcrete.M) (DFS.M) (HeapConcrete.M) (C_Choice)

module SAF =
  Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapArrayFork.M) (SAF_Choice)

module SAITE =
  Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapArrayITE.M) (SAITE_Choice)

module ST = Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapTree.M) (ST_Choice)

module SOPL =
  Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapOpList.M) (SOPL_Choice)

type mode = 
  | Concrete
  | Saf
  | Saite
  | St
  | Sopl
  [@@deriving yojson]

type report = {
  filename: string;
  mode: mode;
  execution_time: float;
  solver_time: float;
  num_paths: int;
  num_problems: int;
  problems: Outcome.t list
} [@@deriving yojson] 


type options = {
  input : Fpath.t;
  mode : mode;
  output : Fpath.t option;
  verbose : bool;
}

let mode_to_string = function
  | Concrete -> "c"
  | Saf -> "saf"
  | Saite -> "saite"
  | St -> "st"
  | Sopl -> "sopl"


let write_report report = 
  let json = report |> report_to_yojson |> Yojson.Safe.to_string in
  let file = Fpath.v "report.json" in
  Bos.OS.File.write file json |> Rresult.R.get_ok

let run ?(no_values = false) input mode =
  let start = Sys.time () in
  print_header ();
  let program = input |> read_file |> parse_program |> create_program in
  Printf.printf "Input file: %s\nExecution mode: %s\n\n" input (mode_to_string mode);
  let (problems, num_paths) = (match mode with
  | Concrete ->
      let rets = C.interpret program in
      (List.filter_map
        (fun (out, _) ->
          (Format.printf "Outcome: %a@." (Outcome.pp ~no_values) out; match out with Error _ | EndGas -> Some out | _ -> None))
        rets, List.length rets)
  | Saf ->
      let rets = SAF.interpret program in
      (List.filter_map
        (fun (out, _) ->
          (Format.printf "Outcome: %a@." (Outcome.pp ~no_values) out; match out with Error _ | EndGas -> Some out | _ -> None))
        rets, List.length rets)
  | Saite ->
      let rets = SAITE.interpret program in
      (List.filter_map
        (fun (out, _) ->
          (Format.printf "Outcome: %a@." (Outcome.pp ~no_values) out; match out with Error _ | EndGas -> Some out | _ -> None))
        rets, List.length rets)
  | St ->
      let rets = ST.interpret program in
      (List.filter_map
        (fun (out, _) ->
          (Format.printf "Outcome: %a@." (Outcome.pp ~no_values) out; match out with Error _ | EndGas -> Some out | _ -> None))
        rets, List.length rets)
  | Sopl ->
      let rets = SOPL.interpret program in
      (List.filter_map
        (fun (out, _) ->
          (Format.printf "Outcome: %a@." (Outcome.pp ~no_values) out; match out with Error _ | EndGas -> Some out | _ -> None))
        rets, List.length rets))
  in  
  let execution_time = Sys.time () -. start in
  let num_problems = List.length problems in
  if num_problems = 0 then Printf.printf "Everything Ok!\n" else Printf.printf "Found %d problems\n" num_problems;
  if !Utils.verbose then
    Printf.printf "\n=====================\nTotal Execution time: %f\nTotal Solver time: %f\n" (execution_time) (!Translator.solver_time);
  write_report 
  {execution_time; mode; num_paths; num_problems; problems;
  filename = input;
  solver_time = !Translator.solver_time} 

let main (opts : options) =
  Utils.verbose := opts.verbose;
  run (Fpath.to_string opts.input) opts.mode
