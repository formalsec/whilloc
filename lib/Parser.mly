%token SKIP
%token PRINT
%token DEFEQ
%token WHILE
%token IF ELSE
%token RETURN
%token FUNCTION
%token ASSUME
%token ASSERT
%token CLEAR
%token SYMBOL
%token SYMBOL_INT
%token NEW
%token DELETE

%token LPAREN RPAREN
%token LBRACE RBRACE
%token LBRACKET RBRACKET
%token COMMA SEMICOLON

%token <int>    INT
%token <bool>   BOOLEAN
%token <string> STRING
%token <string> VAR

%token NOT ABS STOI
%token OR AND XOR SHL SHR
%token PLUS MINUS TIMES DIVIDE MODULO POW EQUAL NEQUAL GT LT GTE LTE
%token EOF

%left OR XOR AND
%left EQUAL NEQUAL
%left GT LT GTE LTE SHL SHR
%left PLUS MINUS
%left TIMES DIVIDE MODULO
%right POW

%nonassoc unopt_prec

%type <Program.func list> program_target

%start program_target

%%


program_target:
  | funcs = separated_nonempty_list (SEMICOLON, function_definition); EOF;
   { funcs }

function_definition:
  | FUNCTION; id = VAR; LPAREN; args = separated_list (COMMA, VAR); RPAREN; LBRACE; body = statement_sequence; RBRACE
   { {id; args; body} }


(* v ::= int | bool *)
value:
  | i = INT;
    { Value.Integer i }
  | b = BOOLEAN;
    { Value.Boolean b }


(* e ::= v | x | -e | e+e | f(e) | (e) *)
expression:
  | v = value;
    { Expression.Val v }
  | v = VAR;
    { Expression.Var v }
  | MINUS; e = expression;
    { Expression.UnOp (Expression.Neg, e) } %prec unopt_prec
  | NOT; e = expression;
    { Expression.UnOp (Expression.Not, e) } %prec unopt_prec
  | ABS; e = expression;
    { Expression.UnOp (Expression.Abs, e) } %prec unopt_prec
  | STOI; e = expression;
    { Expression.UnOp (Expression.StringOfInt, e) } %prec unopt_prec
  | e1 = expression; bop = binop_target; e2 = expression;
    { Expression.BinOp (bop, e1, e2) }
  | LPAREN; e=expression ; RPAREN
    { e }


(* s ::= skip | x := e | s1; s2 | if (e) { s1 } else { s2 } | while (e) { s } | x := f(v1,...,vn) | return e  *)
statement:
  | SKIP;
    { Program.Skip }
  | ASSUME; LPAREN; e = expression; RPAREN;
    { Program.Assume e }
  | ASSERT; LPAREN; e = expression; RPAREN;
    { Program.Assert e }
  | CLEAR
    { Program.Clear }
  | v = VAR; DEFEQ; e = expression;
    { Program.Assign (v, e) }
  | v = VAR; DEFEQ; f = VAR; LPAREN; args = separated_list(COMMA, expression); RPAREN;
    { Program.FunCall (v,f,args)}
  | IF; LPAREN; e = expression; RPAREN; LBRACE; s1 = statement_sequence; RBRACE; ELSE; LBRACE; s2 = statement_sequence; RBRACE;
    { Program.IfElse(e, s1, s2) }
  | WHILE; LPAREN; e = expression; RPAREN; LBRACE; s = statement_sequence; RBRACE;
    { Program.While (e, s) }
  | RETURN; e = expression;
    { Program.Return e }
  | PRINT; LPAREN; exprs = separated_nonempty_list(COMMA, expression); RPAREN;
    { Program.Print exprs }
  | v = VAR; DEFEQ; SYMBOL; LPAREN; s = STRING; RPAREN;
    { Program.Symbol (v, s)}
  | v = VAR; DEFEQ; SYMBOL_INT; LPAREN; s = STRING; RPAREN;
    { Program.Symbol_int (v, s)}
  | arr = VAR; DEFEQ; NEW; LPAREN; e = expression; RPAREN;
    { Program.New (arr, e) }
  | arr = VAR; LBRACKET; e1 = expression; RBRACKET; DEFEQ; e2 = expression;
    { Program.Update (arr, e1, e2) }
  | v = VAR; DEFEQ; arr = VAR; LBRACKET; e = expression; RBRACKET;
    { Program.LookUp (v, arr, e) }
  | DELETE; arr = VAR;
    { Program.Delete (arr) }


statement_sequence:
  | s = separated_nonempty_list (SEMICOLON, statement);
    { Program.Sequence s }


%inline binop_target:
  | PLUS    { Expression.Plus }
  | MINUS   { Expression.Minus }
  | TIMES   { Expression.Times }
  | DIVIDE  { Expression.Div }
  | MODULO  { Expression.Modulo }
  | POW     { Expression.Pow }
  | GT      { Expression.Gt }
  | LT      { Expression.Lt }
  | GTE     { Expression.Gte }
  | LTE     { Expression.Lte }
  | EQUAL   { Expression.Equals }
  | NEQUAL  { Expression.NEquals }
  | OR      { Expression.Or }
  | AND     { Expression.And }
  | XOR     { Expression.Xor }
  | SHL     { Expression.ShiftL }
  | SHR     { Expression.ShiftR }














(*------------------------------------*)
(*---------------graveyard------------*)
(*------------------------------------*)

(*%token MAX MIN*) (*%token INT_TYPE BOOL_TYPE STR_TYPE SYMBOL_TYPE*)

  (*| MAX; LPAREN; e1 = expression; e2 = expression; RPAREN;
    { Program.BinOpt (Program.Max, e1, e2) }
  | MIN; LPAREN; e1 = expression; e2 = expression; RPAREN;
    { Program.BinOpt (Program.Min, e1, e2) }*)


  (*| MODULO  { Program.Modulo }
  | EQUAL   { Program.Equal }
  | GT      { Program.Gt }
  | LT      { Program.Lt }
  | EGT     { Program.Egt }
  | ELT     { Program.Elt }
  | POW     { Program.Pow }*)
(* if (e) { s } | if (e) {s} else { s } *)
(*  stmt_target: exps_stmts = ifelse_target; { exps_stmts }*)
(*ifelse_target:
  | IF; LPAREN; e = expr_target; RPAREN; LBRACE; s1 = stmt_block; RBRACE; ELSE;LBRACE; s2 = stmt_block; RBRACE;
    { Program.If(e, s1, Some s2) }
  | IF; LPAREN; e = expr_target; RPAREN; LBRACE; s = stmt_block; RBRACE;
    { Program.If(e, s, None) }*)
(*type_target:
  | INT_TYPE;
  { Type.IntType }
  | BOOL_TYPE;
    { Type.BoolType }
  | STR_TYPE;
    { Type.StrType }
  | SYMBOL_TYPE;*)

  (*| MINUS; e = expr_target;
    { Program.UnOpt (Program.Neg, e) } %prec unopt_prec
  | NOT; e = expr_target;
    { Program.UnOpt (Program.Not, e) } %prec unopt_prec
  | ABS; e = expr_target;
    { Program.UnOpt (Program.StringOfInt, e) } %prec unopt_prec*)

(*value:
  | b = BOOLEAN;
    { Val.Bool b }
  | s = STRING;
    { Val.Str s }
  | s = SYMBOL;
    { Val.Symbol s }*)
