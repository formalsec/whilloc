open Whilloc
open Utils

module SAF_Choice = ListChoice.Make (EvalSymbolic.M) (HeapArrayFork.M)
module SAITE_Choice = ListChoice.Make (EvalSymbolic.M) (HeapArrayITE.M)
module ST_Choice = ListChoice.Make (EvalSymbolic.M) (HeapTree.M)
module SOPL_Choice = ListChoice.Make (EvalSymbolic.M) (HeapOpList.M)

module SAF =
  Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapArrayFork.M) (SAF_Choice)

module SAITE =
  Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapArrayITE.M) (SAITE_Choice)

module ST = Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapTree.M) (ST_Choice)

module SOPL =
  Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapOpList.M) (SOPL_Choice)

  
type options = {
  input : Fpath.t;
  mode : string;
  output : Fpath.t option;
  verbose : bool;
}

let run input mode =
    let start = Sys.time () in
    print_header ();
    let program = input |> read_file |> parse_program |> create_program in
    Printf.printf "Input file: %s\nExecution mode: %s\n\n" input mode;
    (match mode with
    | "saf" ->
        let rets = SAF.interpret program in
        List.iter
          (fun (out, _) ->
            Format.printf "Outcome: %s@." (Outcome.to_string out))
          rets
    | "saite" ->
        let rets = SAITE.interpret program in
        List.iter
          (fun (out, _) ->
            Format.printf "Outcome: %s@." (Outcome.to_string out))
          rets
    | "st" ->
        let rets = ST.interpret program in
        List.iter
          (fun (out, _) ->
            Format.printf "Outcome: %s@." (Outcome.to_string out))
          rets
    | "sopl" ->
        let rets = SOPL.interpret program in
        List.iter
          (fun (out, _) ->
            Format.printf "Outcome: %s@." (Outcome.to_string out))
          rets
    | _ -> assert false)
    (* ;Printf.printf "Total Execution time of Solver: %f\n" (!Translator.solver_time) *);
    if !Utils.verbose then
      Printf.printf "Total Execution time: %f\n" (Sys.time () -. start);
    print_footer ()


let main (opts : options) : int  = 
  Utils.verbose := opts.verbose;
  run (Fpath.to_string opts.input) opts.mode;
  0