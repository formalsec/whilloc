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

let run ?(no_values = false) input mode =
  let start = Sys.time () in
  print_header ();
  let program = input |> read_file |> parse_program |> create_program in
  Printf.printf "Input file: %s\nExecution mode: %s\n\n" input (mode_to_string mode);
  (match mode with
  | Concrete ->
      let rets = C.interpret program in
      List.iter
        (fun (out, _) ->
          Format.printf "Outcome: %a@." (Outcome.pp ~no_values) out)
        rets
  | Saf ->
      let rets = SAF.interpret program in
      List.iter
        (fun (out, _) ->
          Format.printf "Outcome: %a@." (Outcome.pp ~no_values) out)
        rets
  | Saite ->
      let rets = SAITE.interpret program in
      List.iter
        (fun (out, _) ->
          Format.printf "Outcome: %a@." (Outcome.pp ~no_values) out)
        rets
  | St ->
      let rets = ST.interpret program in
      List.iter
        (fun (out, _) ->
          Format.printf "Outcome: %a@." (Outcome.pp ~no_values) out)
        rets
  | Sopl ->
      let rets = SOPL.interpret program in
      List.iter
        (fun (out, _) ->
          Format.printf "Outcome: %a@." (Outcome.pp ~no_values) out)
        rets)
  (* ;Printf.printf "Total Execution time of Solver: %f\n" (!Translator.solver_time) *);
  if !Utils.verbose then
    Printf.printf "Total Execution time: %f\n" (Sys.time () -. start)

let main (opts : options) =
  Utils.verbose := opts.verbose;
  run (Fpath.to_string opts.input) opts.mode
