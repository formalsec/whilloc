{
  open Parser
  open Lexing

  exception Syntax_Error of string

  let create_syntax_error ?(eof=false) (msg : string) (lexbuf : Lexing.lexbuf) : exn =
    let c = Lexing.lexeme lexbuf in
    let formatted_msg = (
      match eof with
      | true  -> Printf.sprintf "%s. Line number: %d." msg (lexbuf.lex_curr_p.pos_lnum)
      | false -> Printf.sprintf "%s: %s. Line number: %d." msg c (lexbuf.lex_curr_p.pos_lnum)
    ) in (Syntax_Error formatted_msg)
}


let digit   = ['0' - '9']
let letter  = ['a' - 'z' 'A' - 'Z']
let int     = '-'?digit+
let frac    = '.' digit*
let exp     = ['e' 'E'] ['-' '+']? digit+
let float   = digit* frac? exp?|"nan"|"inf"
let bool    = "true"|"false"
let var     = (letter | '_'*letter)(letter|digit|'_'|'\'')*
let symbol  = '\''(var|int)
let white   = (' '|'\t')+
let newline = '\r'|'\n'|"\r\n"
let loc     = "$loc_"(digit|letter|'_')+
let three_d = digit digit digit
let c_code  = '\\'three_d


rule read =
  parse
  | white             { read lexbuf }
  | newline           { new_line lexbuf; read lexbuf }
  | "="               { DEFEQ }
  | ';'               { SEMICOLON }
  | ','               { COMMA }
  | '+'               { PLUS }
  | '-'               { MINUS }
  | '*'               { TIMES }
  | '/'               { DIVIDE }
  | '%'               { MODULO }
  | "**"              { POW }
  | "=="              { EQUAL }
  | "!="              { NEQUAL }
  | '>'               { GT }
  | '<'               { LT }
  | ">="              { GTE }
  | "<="              { LTE }
  | '!'               { NOT }
  | "||"              { OR }
  | "&&"              { AND }
  | '^'               { XOR }
  | "<<"              { SHL }
  | ">>"              { SHR }
  | '('               { LPAREN }
  | ')'               { RPAREN }
  | '['               { LBRACKET }
  | ']'               { RBRACKET }
  | '{'               { LBRACE }
  | '}'               { RBRACE }
  | int               { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | bool              { BOOLEAN (bool_of_string (Lexing.lexeme lexbuf)) }
  | '"'               { read_string (Buffer.create 16) lexbuf }
  | "abs"             { ABS }
  (*| "max"             { MAX }
  | "min"             { MIN }*)
  | "if"              { IF }
  | "else"            { ELSE }
  | "while"           { WHILE }
  | "return"          { RETURN }
  | "function"        { FUNCTION }
  | "assume"          { ASSUME }
  | "assert"          { ASSERT }
  | "skip"            { SKIP }
  | "clear"           { CLEAR }
  | "print"           { PRINT }
  | "symbol"          { SYMBOL }
  | "symbol_int"      { SYMBOL_INT }
  | "new"             { NEW }
  | "delete"          { DELETE }
  | '"'               { read_string (Buffer.create 16) lexbuf }
  (*| letter(letter|digit|'_')* as id { try
                                        Hashtbl.find keyword_table id
                                      with Not_found -> VAR id }*)
  | var               { VAR (Lexing.lexeme lexbuf) }
  | "/*"              { read_comment lexbuf }
  | _                 { raise (create_syntax_error "Unexpected char" lexbuf) }
  | eof               { EOF }


and read_string buf =
  parse
  | '"'                  { STRING (Buffer.contents buf) }
  | '\\' '/'             { Buffer.add_char buf '/'; read_string buf lexbuf }
  | '\\' '\\'            { Buffer.add_char buf '\\'; read_string buf lexbuf }
  | '\\' 'b'             { Buffer.add_char buf '\b'; read_string buf lexbuf }
  | '\\' 'v'             { Buffer.add_char buf '\011'; read_string buf lexbuf }
  | '\\' 'f'             { Buffer.add_char buf '\012'; read_string buf lexbuf }
  | '\\' 'n'             { Buffer.add_char buf '\n'; read_string buf lexbuf }
  | '\\' 'r'             { Buffer.add_char buf '\r'; read_string buf lexbuf }
  | '\\' 't'             { Buffer.add_char buf '\t'; read_string buf lexbuf }
  | '\\' '\"'            { Buffer.add_char buf '\"'; read_string buf lexbuf }
  | '\\' '\''            { Buffer.add_char buf '\''; read_string buf lexbuf }
  | '\\' '0'             { Buffer.add_char buf '\000'; read_string buf lexbuf }
  | [^ '"' '\\']+        {
                           Buffer.add_string buf (Lexing.lexeme lexbuf);
                           read_string buf lexbuf
                         }
  | _                    { raise (create_syntax_error "Illegal string character" lexbuf) }
  | eof                  { raise (create_syntax_error ~eof:true "String is not terminated" lexbuf) }


and read_comment =
  parse
  | "*/"    { read lexbuf }
  | newline { new_line lexbuf; read_comment lexbuf }
  | _       { read_comment lexbuf }
  | eof     { raise (create_syntax_error ~eof:true "Comment is not terminated" lexbuf)}

(*and read_type =
(* Read Language Types
  parse
  | "Int"    { INT_TYPE }
  | "Flt"    { FLT_TYPE }
  | "Bool"   { BOOL_TYPE }
  | "Str"    { STR_TYPE }
  | "Symbol" { SYMBOL_TYPE }*)
  | _        { raise (create_syntax_error "Unexpected type" lexbuf) }
*)
