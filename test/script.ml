open Whilloc
(* open Bos_setup *)
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

(* TODO:
  - receberes uma diretoria do teu Sys.argv.(2)
  - traverse da diretoria e encontrar '*.wl'
  - List.iter run_test_file
  *)

(*
  Bos: https://erratique.ch/software/bos/doc/
 *)

let _max_timeout = 10
(*
  timeout:

let unset () = Sys.set_signal Sys.sigalrm Sys.Signal_ignore

let set =
  let raise n = if n = -2 then raise Timeout in
  fun () ->
    Sys.set_signal Sys.sigalrm (Sys.Signal_handle raise);
    ignore
    @@ ( Unix.setitimer Unix.ITIMER_REAL
           { Unix.it_interval = 0.; Unix.it_value = _max_timeout }
         : Unix.interval_timer_status )

let run_test_file model file : 'a Result.t =
  try
    Fun.protect ~finally:unset (fun () ->
        set ();
        try
            Format.printf "Running '%s'@." input_file;
            let program =
              Utils.read_file input_file |> Utils.parse_program |> Utils.create_program
            in
            match model with
            | "saite" ->
                let outcomes = SAITE.interpret program in
                List.iter
                  (fun (o, _) -> Format.printf "Outcome: %s@." (Outcome.to_string o))
                  outcomes
            | _ -> assert false
        with Timeout -> print "file %s timeout" )
  with Timeout -> print "General timeout?"
*)

let () =
  let model = Sys.argv.(1) in
  let input_file = Sys.argv.(2) in
  Format.printf "Running '%s'@." input_file;
  let program =
    Utils.read_file input_file |> Utils.parse_program |> Utils.create_program
  in
  match model with
  | "saite" ->
      let outcomes = SAITE.interpret program in
      List.iter
        (fun (o, _) -> Format.printf "Outcome: %s@." (Outcome.to_string o))
        outcomes
  | _ -> assert false
