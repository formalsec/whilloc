open Cmdliner

let doc = "Executes a program concretely or symbolically depending on the mode"
let sdocs = Manpage.s_common_options

let description =
  [
    "Given a program in the simple \"While\" language, executes the program \
     concretely or symbolically depending on the mode. At the end, it \
     generates a report named 'report.json' that includes some execution \
     metrics and counter models that were found.";
    "To run the program concretely, use the mode 'c'.";
    "To run the program symbolically, there are several modes to choose from. \
     These modes differs on the memory model that it uses to execute the \
     program.";
  ]

let man =
  [
    `S Manpage.s_description;
    `P (List.nth description 0);
    `P (List.nth description 1);
    `P (List.nth description 2);
  ]

let man_xrefs = []

let cmd_options input mode output verbose : Cmd_execute.options =
  { input; mode; output; verbose }

let options =
  Term.(
    const cmd_options $ Options.File.input $ Options.mode $ Options.File.output
    $ Options.verbose)

let term = Term.(const Cmd_execute.main $ options)
