open Cmdliner

module AppInfo = struct
  let version = "1.0.0"
  let doc = "A simple \"while\"-like programming language that includes memory allocation support."

  let description = [
    "TODO description";
    "Use wl <command> --help for more information on a specific command."
  ]

  let sdocs = Manpage.s_common_options

  let man = [
    `S Manpage.s_description;
    `P (List.nth description 0);
    `P (List.nth description 1);
    `S Manpage.s_common_options;
    `P  "These options are common to all commands.";
    `S Manpage.s_bugs;
    `P "Check bug reports at https://github.com/formalsec/whilloc/issues"
  ]

  let man_xrefs = []
end

let execute_cmd = 
  let open Doc_execute in
  let info = Cmd.info "execute" ~doc ~sdocs ~man ~man_xrefs in
  Cmd.v info term

let cmd_list = 
  [ execute_cmd
  ]


let main_cmd = 
  let open AppInfo in 
  let default_fun () = `Help (`Pager, None) in
  let default = Term.(ret (const default_fun $ const ())) in
  let info = Cmd.info "wl" ~version ~doc ~sdocs ~man ~man_xrefs in 
  Cmd.group info ~default cmd_list

let () = 
  Printexc.record_backtrace true;
  try exit (Cmdliner.Cmd.eval' main_cmd)
  with exn ->
    flush_all ();
    Format.eprintf "%s: uncaught exception %s@." Sys.argv.(0) (Printexc.to_string exn);
    Printexc.print_backtrace stderr;
    exit 1