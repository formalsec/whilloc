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
%token SYMBOL_BOOL
%token SYMBOL_INT
%token SYMBOL_INT_C
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
    { Expr.Val v }
  | v = VAR;
    { Expr.Var v }
  | MINUS; e = expression;
    { Expr.Unop (Expr.Neg, e) } %prec unopt_prec
  | NOT; e = expression;
    { Expr.Unop (Expr.Not, e) } %prec unopt_prec
  | ABS; e = expression;
    { Expr.Unop (Expr.Abs, e) } %prec unopt_prec
  | STOI; e = expression;
    { Expr.Unop (Expr.StringOfInt, e) } %prec unopt_prec
  | e1 = expression; bop = binop_target; e2 = expression;
    { Expr.Binop (bop, e1, e2) }
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
  | v = VAR; DEFEQ; SYMBOL_BOOL; LPAREN; s = STRING; RPAREN;
    { Program.Symbol_bool (v, s)}
  | v = VAR; DEFEQ; SYMBOL_INT; LPAREN; s = STRING; RPAREN;
    { Program.Symbol_int (v, s)}
  | v = VAR; DEFEQ; SYMBOL_INT_C; LPAREN; s = STRING; COMMA; c = expression; RPAREN;
    { Program.Symbol_int_c (v, s, c)}
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
  | PLUS    { Expr.Plus }
  | MINUS   { Expr.Minus }
  | TIMES   { Expr.Times }
  | DIVIDE  { Expr.Div }
  | MODULO  { Expr.Modulo }
  | POW     { Expr.Pow }
  | GT      { Expr.Gt }
  | LT      { Expr.Lt }
  | GTE     { Expr.Gte }
  | LTE     { Expr.Lte }
  | EQUAL   { Expr.Equals }
  | NEQUAL  { Expr.NEquals }
  | OR      { Expr.Or }
  | AND     { Expr.And }
  | XOR     { Expr.Xor }
  | SHL     { Expr.ShiftL }
  | SHR     { Expr.ShiftR }
