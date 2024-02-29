open Cmdliner

let doc = "execute something"

let term = Term.(const Cmd_execute.main $ const ())