let get_files dir =
  let files = [] in
  let result =
    Bos.OS.Path.fold ~elements:`Files ~traverse:`Any
      (fun file files ->
        if Fpath.has_ext ".wl" file then file :: files else files )
      files [ dir ]
  in
  match result with Ok files -> files | Error (`Msg err) -> failwith err
