open Whilloc
open Bos

exception Timeout

module SAF_Choice = ListChoice.Make (EvalSymbolic.M) (HeapArrayFork.M)
module SAITE_Choice = ListChoice.Make (EvalSymbolic.M) (HeapArrayITE.M)
module ST_Choice = ListChoice.Make (EvalSymbolic.M) (HeapTree.M)
module SOPL_Choice = ListChoice.Make (EvalSymbolic.M) (HeapOpList.M)

module SAF =
  Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapArrayFork.M) (SAF_Choice)
module SAITE =
  Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapArrayITE.M) (SAITE_Choice)
module ST = 
	Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapTree.M) (ST_Choice)
module SOPL =
  Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapOpList.M) (SOPL_Choice)

let _max_timeout = 10.0
let unset () = Sys.set_signal Sys.sigalrm Sys.Signal_ignore

let set =
  let raise n = if n = -2 then raise Timeout in
  fun () ->
    Sys.set_signal Sys.sigalrm (Sys.Signal_handle raise);
    ignore
    @@ ( Unix.setitimer Unix.ITIMER_REAL
          { Unix.it_interval = 0.; Unix.it_value = _max_timeout}
        : Unix.interval_timer_status )

let run model file = 
  print_string "\n=====================\n\tÆnima\n=====================\n\n";
  let program = file |> Utils.read_file |> Utils.parse_program |> Utils.create_program in
    Printf.printf "Input file: %s\nExecution mode: %s\n\n" file model;
    (match model with
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

let run_with_timeout model file =
  try
    Fun.protect ~finally:unset (fun () ->
        set ();
        try
          run model file
        with Timeout -> Printf.printf "File %s timeout\n" (file))
  with Timeout -> Printf.printf "General timeout\n"

let () = 
  let model = Sys.argv.(1) in
	let dir = Fpath.v Sys.argv.(2) in
  let sum = 0 in
  let result =
    OS.Path.fold
      ~elements:`Files
      ~traverse:`Any
      ((fun model file sum -> 
        if Fpath.has_ext ".wl" file then 
        (run_with_timeout model (Fpath.to_string file);
        sum + 1)
      else
        sum)
      model)
      sum
      [dir]
  in
  match result with
  | Ok sum ->
      Printf.printf "Total number of files tested: %d\n" sum
  | Error err ->
      Printf.printf "Error during fold: %s\n" (Format.asprintf "%a" Rresult.R.pp_msg err)