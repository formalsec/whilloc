open Cmdliner

module AppInfo = struct
  let version = "1.0.0"
  let doc = "A simple \"while\"-like programming language that includes memory allocation support."
end

let execute_cmd = 
  let open Doc_execute in
  let info = Cmd.info "execute" ~doc in
  Cmd.v info term

let cmd_list = 
  [ execute_cmd
  ]


let main_cmd = 
  let open AppInfo in 
  let default_fun () = `Help (`Pager, None) in
  let default = Term.(ret (const default_fun $ const ())) in
  let info = Cmd.info "wl" ~version ~doc  in 
  Cmd.group info ~default cmd_list

let () = 
  Printexc.record_backtrace true;
  try exit (Cmdliner.Cmd.eval' main_cmd)
  with exn ->
    flush_all ();
    Format.eprintf "%s: uncaught exception %s@." Sys.argv.(0) (Printexc.to_string exn);
    Printexc.print_backtrace stderr;
    exit 1