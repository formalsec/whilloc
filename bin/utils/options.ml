open Cmdliner

module File = struct
  let parse_fpath str test_f =
    let file = Fpath.v str in
    match test_f file with
    | Ok true -> `Ok file
    | Ok false -> `Error (str ^ " is not a file")
    | Error (`Msg err) -> `Error err

  let fpath = ((fun str -> `Ok (Fpath.v str)), Fpath.pp)
  let valid_fpath = ((fun str -> parse_fpath str Bos.OS.Path.exists), Fpath.pp)
  let non_dir_fpath = ((fun str -> parse_fpath str Bos.OS.File.exists), Fpath.pp)
  let dir_fpath = ((fun str -> parse_fpath str Bos.OS.Dir.exists), Fpath.pp)

  let input =
    let docv = "FILE" in
    let doc = "Name of the input file." in
    Arg.(required & pos 0 (some non_dir_fpath) None & info [] ~doc ~docv)

  let inputs =
    let docv = "FILE/DIR" in
    let doc = "Name of the input file or input directory." in
    Arg.(required & pos 0 (some valid_fpath) None & info [] ~doc ~docv)

  let output =
    let docv = "FILE" in
    let doc = "Name of the output file." in
    Arg.(value & opt (some fpath) None & info [ "o"; "output" ] ~doc ~docv)
end

let mode_conv = 
  Arg.enum
    [ ("c", Cmd_execute.Concrete)
    ; ("saf", Cmd_execute.Saf)
    ; ("saite", Cmd_execute.Saite)
    ; ("st", Cmd_execute.St)
    ; ("sopl", Cmd_execute.Sopl)]

let mode =
  let docv = "MODE" in
  let doc =
    "Mode of the execution. Options include: (1) 'c' for Concrete; (2) 'saf' \
     for Symbolic with Array Fork Memory; (3) 'saite' for Symbolic with Array \
     ITE Memory; (4) 'st' for Symbolic with Tree Memory; and (5) 'sopl' for \
     Symbolic with Operation List Memory."
  in
  Arg.(required & pos 1 (some mode_conv) None & info [] ~doc ~docv)

let verbose =
  let doc = "Show the statements being executed." in
  Arg.(value & flag & info [ "v"; "verbose" ] ~doc)

let timeout =
  let docv = "DURATION" in
  let doc =
    "Floating point number representing the maximum duration in seconds for \
     each program to run. When exceeded, the program will be killed. The \
     default value is 0 which will disable the assciated timeout."
  in
  Arg.(value & opt (some float) None & info [ "timeout" ] ~doc ~docv)
