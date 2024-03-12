open Whilloc
open Utils

(* Choice *)
module C_Choice = List_choice.Make (Eval_concrete.M) (Heap_concrete.M)
module SAF_Choice = List_choice.Make (Eval_symbolic.M) (Heap_array_fork.M)
module SAITE_Choice = List_choice.Make (Eval_symbolic.M) (Heap_arrayite.M)
(* module ST_Choice = List_choice.Make (Eval_symbolic.M) (Heap_tree.M) *)
(* module SOPL_Choice = List_choice.Make (Eval_symbolic.M) (Heap_oplist.M) *)

(* Interpreter *)
module C = Interpreter.Make (Eval_concrete.M) (Dfs.M) (Heap_concrete.M) (C_Choice)

module SAF = Interpreter.Make (Eval_symbolic.M) (Dfs.M) (Heap_array_fork.M) (SAF_Choice)

module SAITE = Interpreter.Make (Eval_symbolic.M) (Dfs.M) (Heap_arrayite.M) (SAITE_Choice)
(* module ST = Interpreter.Make (Eval_symbolic.M) (Dfs.M) (Heap_tree.M) (ST_Choice) *)
(* module SOPL =  Interpreter.Make (Eval_symbolic.M) (Dfs.M) (Heap_oplist.M) (SOPL_Choice) *)

type mode =
  | Concrete
  | Saf
  | Saite
  | St
  | Sopl
[@@deriving yojson]

type report =
  { filename : string
  ; mode : mode
  ; execution_time : float
  ; solver_time : float
  ; num_paths : int
  ; num_problems : int
  ; problems : Outcome.t list
  }
[@@deriving yojson]

type options =
  { input : Fpath.t
  ; mode : mode
  ; output : Fpath.t option
  ; verbose : bool
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
  match Bos.OS.File.write file json with
  | Ok v -> v
  | Error (`Msg err) -> failwith err

let run ?(test=false) input mode =
  let start = Sys.time () in
  print_header ();
  let program = input |> read_file |> parse_program |> create_program in
  Printf.printf "Input file: %s\nExecution mode: %s\n\n" input
    (mode_to_string mode);
  let problems, num_paths =
    match mode with
    | Concrete ->
      let rets = C.interpret program in 
      ( List.filter_map
          (fun (out, _) -> if test then Format.printf "%a@." (Outcome.pp ~no_values:false) out;
            match out with
            | Outcome.Error _ | Outcome.EndGas -> Some out
            | _ -> None )
          rets
      , List.length rets )
    | Saf ->
      let rets = SAF.interpret program in
      ( List.filter_map
          (fun (out, _) -> if test then Format.printf "%a@." (Outcome.pp ~no_values:false) out;
            match out with
            | Outcome.Error _ | Outcome.EndGas -> Some out
            | _ -> None )
          rets
      , List.length rets )
    | Saite ->
      let rets = SAITE.interpret program in
      ( List.filter_map
          (fun (out, _) -> if test then Format.printf "%a@." (Outcome.pp ~no_values:false) out;
            match out with
            | Outcome.Error _ | Outcome.EndGas -> Some out
            | _ -> None )
          rets
      , List.length rets )
    (*| St ->
      let rets = ST.interpret program in
      ( List.filter_map
          (fun (out, _) -> if test then Format.printf "%a@." (Outcome.pp ~no_values:false) out;
            match out with
            | Outcome.Error _ | Outcome.EndGas -> Some out
            | _ -> None )
          rets
      , List.length rets )
    | Sopl ->
      let rets = SOPL.interpret program in
      ( List.filter_map
          (fun (out, _) -> if test then Format.printf "%a@." (Outcome.pp ~no_values:false) out;
            match out with
            | Outcome.Error _ | Outcome.EndGas -> Some out
            | _ -> None )
          rets
      , List.length rets ) *)
    | _ -> assert false
  in
  let execution_time = Sys.time () -. start in
  let num_problems = List.length problems in
  if num_problems = 0 then Printf.printf "Everything Ok!\n"
  else Printf.printf "Found %d problems!\n" num_problems;
  if !Utils.verbose then
    Printf.printf
      "\n\
       =====================\n\
       Total Execution time: %f\n\
       Total Solver time: %f\n"
      execution_time 0.0(* !Translator.solver_time *);
  write_report
    { execution_time
    ; mode
    ; num_paths
    ; num_problems
    ; problems
    ; filename = input
    ; solver_time = 0. (* !Translator.solver_time *)
    }

let main (opts : options) =
  Utils.verbose := opts.verbose;
  run (Fpath.to_string opts.input) opts.mode
