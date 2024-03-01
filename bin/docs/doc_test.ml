open Cmdliner

let doc = "Executes all programs with the extension .wl in the given directory and mode."
let sdocs = Manpage.s_common_options

let description = 
  [
    "Executes all programs with the extension .wl in the given directory and mode.";
    "The difference of running programs using this command and command 'wl execute' \
    is that this command will run all programs in the given directory. In addition,
    this command have the option to set a time limit for each program's execution. 
    When the time limit is exceeded, the execution is killed";
  ]

let man = [
  `S Manpage.s_description;
  `P (List.nth description 0);
  `P (List.nth description 1)
]

let man_xrefs =[ `Page ("wl execute", 2) ]

let cmd_options inputs mode timeout verbose : Cmd_test.options =
  { inputs; mode; timeout; verbose }

let options = 
  Term.(
    const cmd_options
    $ Options.File.inputs
    $ Options.mode
    $ Options.timeout
    $ Options.verbose
  )

let term = Term.(const Cmd_test.main $ options)