# Whilloc [![Build](https://github.com/formalsec/whilloc/actions/workflows/build.yml/badge.svg)](https://github.com/formalsec/whilloc/actions/workflows/build.yml) [![Coverage Status](https://coveralls.io/repos/github/formalsec/whilloc/badge.svg?branch=HEAD)](https://coveralls.io/github/formalsec/whilloc?branch=HEAD)

A simple "while"-like programming language that includes memory
allocation support.

## Built from source

- Install [opam](https://opam.ocaml.org/doc/Install.html).
- Bootstrap the OCaml compiler:

```sh
opam init
opam switch create 4.14.0 4.14.0
```

- Then, install the library dependencies:

```sh
git clone https://github.com/wasp-platform/whilloc.git
cd whilloc
opam install . --deps-only
```

- Build and install:

```sh
dune build @install
dune install
```
