open Whilloc

exception Timeout

type options = {
  inputs : Fpath.t;
  mode : Cmd_execute.mode;
  timeout : float option;
  verbose : bool;
}

let _max_timeout = ref 0.0
let unset () = Sys.set_signal Sys.sigalrm Sys.Signal_ignore

let set =
  let raise n = if n = -2 then raise Timeout in
  fun () ->
    Sys.set_signal Sys.sigalrm (Sys.Signal_handle raise);
    ignore
    @@ (Unix.setitimer Unix.ITIMER_REAL
          { Unix.it_interval = 0.; Unix.it_value = !_max_timeout }
         : Unix.interval_timer_status)

let run_single mode file =
  try
    Fun.protect ~finally:unset (fun () ->
        set ();
        try Cmd_execute.run file mode ~no_values:true with
        | Timeout ->
            Printf.printf
              "Timeout occurred while processing file: %s (Max Timeout: %f \
               seconds)\n"
              file !_max_timeout
        (* maybe is not the best way to treat exceptions *)
        | ex ->
            Printf.printf "Fatal error: exception %s\n" (Printexc.to_string ex))
  with Timeout -> Printf.printf "General timeout\n"

let run (opts : options) : unit =
  let files = Dir.get_files opts.inputs in
  List.iter (run_single opts.mode)
    (List.map Fpath.to_string (List.sort Fpath.compare files));
  Printf.printf "Total number of files tested: %d\n" (List.length files)

let main (opts : options) =
  _max_timeout := Option.value ~default:0.0 opts.timeout;
  Utils.verbose := opts.verbose;
  run opts
