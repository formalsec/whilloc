(lang dune 3.5)

(using menhir 2.1)

(name whilloc)

(generate_opam_files true)

(source
 (github formalsec/whilloc))

(authors
  "Francisco Miguel Sena"
  "José Fragoso Santos")

(maintainers
  "José Fragoso Santos"
  "Filipe Marques")

(license "AGPL-3.0-or-later")

(documentation https://formalsec.github.io/whilloc)

(package
 (name whilloc)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune z3 menhir bos)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
