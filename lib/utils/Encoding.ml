open Z3
open Expression
open Value

(* Context *)

let ctx =
	mk_context
		[ ("model", "true"); ("proof", "false"); ("unsat_core", "false") ]

(* Solver *)

let solver = ref (Z3.Solver.mk_solver ctx None)

(* Types *)

let ints_sort  = Z3.Arithmetic.Integer.mk_sort ctx
let bools_sort = Z3.Boolean.mk_sort ctx

let mk_string_symb s = Z3.Symbol.mk_string ctx s

type type_constructors = {
  boolean_type_constructor   : Z3.FuncDecl.func_decl;
  int_type_constructor       : Z3.FuncDecl.func_decl;
}

type z3_values = {
  (*  Constructors  *)
  bool_constructor   : Z3.FuncDecl.func_decl;
  int_constructor    : Z3.FuncDecl.func_decl;

  (*  Accessors  *)
  bool_accessor      : Z3.FuncDecl.func_decl;
  int_accessor       : Z3.FuncDecl.func_decl;

  (*  Recognizers  *)
  bool_recognizer    : Z3.FuncDecl.func_decl;
  int_recognizer     : Z3.FuncDecl.func_decl;
}

let mk_add = fun e1 e2 -> Z3.Arithmetic.mk_add ctx [e1; e2]
let mk_sub = fun e1 e2 -> Z3.Arithmetic.mk_sub ctx [e1; e2]
let mk_mul = fun e1 e2 -> Z3.Arithmetic.mk_mul ctx [e1; e2]
let mk_div = fun e1 e2 -> Z3.Arithmetic.mk_div ctx e1 e2
let mk_pow = fun e1 e2 -> Z3.Arithmetic.mk_power ctx e1 e2
let mk_gt  = fun e1 e2 -> Z3.Arithmetic.mk_gt ctx e1 e2
let mk_lt  = fun e1 e2 -> Z3.Arithmetic.mk_lt ctx e1 e2
let mk_gte = fun e1 e2 -> Z3.Arithmetic.mk_ge ctx e1 e2
let mk_lte = fun e1 e2 -> Z3.Arithmetic.mk_le ctx e1 e2
let mk_eq  = fun e1 e2 -> Z3.Boolean.mk_eq  ctx e1 e2
let mk_or  = fun e1 e2 -> Z3.Boolean.mk_or  ctx [e1; e2]
let mk_and = fun e1 e2 -> Z3.Boolean.mk_and ctx [e1; e2]
let mk_xor = fun e1 e2 -> Z3.Boolean.mk_xor ctx e1 e2


let z3_sort, lit_operations =
  (* Type constructors  *)
  let bool_constructor =
    Z3.Datatype.mk_constructor ctx (mk_string_symb "Bool") (mk_string_symb "isBool")
      [(mk_string_symb "boolValue")] [Some bools_sort] [0] in
  let int_constructor =
    Z3.Datatype.mk_constructor ctx (mk_string_symb "Int") (mk_string_symb "isInt")
      [(mk_string_symb "intValue")] [Some ints_sort] [0] in

  let aux_sort =
    Z3.Datatype.mk_sort
      ctx
      (mk_string_symb "Symb_Literal")
      [
          bool_constructor;
          int_constructor
      ] in

  try
    (*  Constructors  *)
    let z3_constructors = Z3.Datatype.get_constructors aux_sort in
    let bool_constructor    = List.nth z3_constructors 0 in
    let int_constructor     = List.nth z3_constructors 1 in

    (*  Accessors  *)
    let z3_accessors    = Z3.Datatype.get_accessors aux_sort in
    let bool_accessor       = List.nth (List.nth z3_accessors 0) 0 in
    let int_accessor        = List.nth (List.nth z3_accessors 1) 0 in

    (*  Recognizers  *)
    let z3_recognizers  = Z3.Datatype.get_recognizers aux_sort in
    let bool_recognizer     = List.nth z3_recognizers 0 in
    let int_recognizer      = List.nth z3_recognizers 1 in

    let literal_operations   = {
      (*  Constructors  *)
      bool_constructor   = bool_constructor;
      int_constructor    = int_constructor;

      (*  Accessors  *)
      bool_accessor      = bool_accessor;
      int_accessor       = int_accessor;

      (*  Recognizers  *)
      bool_recognizer    = bool_recognizer;
      int_recognizer     = int_recognizer
    } in
    aux_sort, literal_operations
  with _ -> raise (Failure ("InternalError: construction of z3_sort"))

(* Solver helper functions *)

let push (solver : Z3.Solver.solver) : unit =
  Z3.Solver.push solver

let pop (solver : Z3.Solver.solver) (lvl : int) : unit =
  Z3.Solver.pop solver lvl

let get_model ?(print_model=false) () : (string * Value.t) list =

  let res =

  match (Z3.Solver.get_model !solver) with
    | None       -> invalid_arg "InternalError: Encoding.get_model, there is no model given the last Check"
    | Some model ->
      List.map
      (fun const ->
        let name 	  = Z3.Symbol.to_string (Z3.FuncDecl.get_name const) 		in
        let _ 	  	= Z3.Sort.to_string   (Z3.FuncDecl.get_range const)  	in
        let interp  = Z3.Model.get_const_interp model const |> Option.get in
        let interp' = Z3.Expr.to_string interp in

        let symb		= Z3.Expr.mk_const ctx (mk_string_symb name) z3_sort in

        let get_type_z3 = (*get the type in the form "(Int" or "(Bool" or ... i.e., "(TYPE"; then, remove the left paranthesis *)
          fun t:string -> let str = (String.split_on_char ' ' t |> List.hd) in String.sub str 1 ((String.length str) - 1) in

        match get_type_z3 interp' with

        | "Int"  ->
            let x = Z3.Expr.mk_app ctx lit_operations.int_accessor [ symb ] in
            let v = Z3.Model.eval model x true |> Option.get in
            let s = Z3.Arithmetic.Integer.numeral_to_string v in
            (name, Integer (int_of_string s))

        | "Bool" ->
            let x = Z3.Expr.mk_app ctx lit_operations.bool_accessor [ symb ] in
            let v = Z3.Model.eval model x true |> Option.get in
            let s = Z3.Expr.to_string v in
            (name, Boolean (bool_of_string s))

        | t 		 -> failwith ("InternalError: Encoding.string_binds, there is no corresponding type with " ^ t);
        )

      (Z3.Model.get_const_decls model) in

      if print_model then let _ = print_endline "Z3 Model" in
                          List.iter (fun (x,y) -> print_endline (x ^ ": " ^ (Value.string_of_value y))) res;
                          print_endline ""
      else ();

  res

(* Encoding of expressions *)

let encode_unop (op : uop) (e : Z3.Expr.expr) : Z3.Expr.expr =
  match op with
  | Not ->
      let e'  = Z3.Expr.mk_app ctx lit_operations.bool_accessor [ e ] in
      let e'' = Z3.Boolean.mk_not ctx e' in
      Z3.Expr.mk_app ctx lit_operations.bool_constructor [ e'' ]
  | Neg ->
      let e'  = Z3.Expr.mk_app ctx lit_operations.int_accessor [ e ] in
      let e'' = Z3.Arithmetic.mk_unary_minus ctx e' in
      Z3.Expr.mk_app ctx lit_operations.int_constructor [ e'' ]
  | _   -> failwith ("TODO: Encoding.encode_unop, missing implementation of " ^ string_of_uop op)

let binop_numbers_to_numbers (mk_op : Z3.Expr.expr -> Z3.Expr.expr -> Z3.Expr.expr) (e1 : Z3.Expr.expr) (e2 : Z3.Expr.expr) : Z3.Expr.expr =
  let e1' = Z3.Expr.mk_app ctx lit_operations.int_accessor [ e1 ] in
  let e2' = Z3.Expr.mk_app ctx lit_operations.int_accessor [ e2 ] in
  let e'  = mk_op e1' e2' in
  Z3.Expr.mk_app ctx lit_operations.int_constructor [ e' ]

let binop_numbers_to_booleans (mk_op : Z3.Expr.expr -> Z3.Expr.expr -> Z3.Expr.expr) (e1 : Z3.Expr.expr) (e2 : Z3.Expr.expr) : Z3.Expr.expr =
  let e1' = Z3.Expr.mk_app ctx lit_operations.int_accessor [ e1 ] in
  let e2' = Z3.Expr.mk_app ctx lit_operations.int_accessor [ e2 ] in
  let e' = mk_op e1' e2' in
  Z3.Expr.mk_app ctx lit_operations.bool_constructor [ e' ]

let binop_booleans_to_booleans (mk_op : Z3.Expr.expr -> Z3.Expr.expr -> Z3.Expr.expr) (e1 : Z3.Expr.expr) (e2 : Z3.Expr.expr) : Z3.Expr.expr =
  let e1' = Z3.Expr.mk_app ctx lit_operations.bool_accessor [ e1 ] in
  let e2' = Z3.Expr.mk_app ctx lit_operations.bool_accessor [ e2 ] in
  let e' = mk_op e1' e2' in
  Z3.Expr.mk_app ctx lit_operations.bool_constructor [ e' ]

let encode_value (v : Value.t) : Z3.Expr.expr =

  match v with

  | Integer i ->
      let int_arg = Z3.Arithmetic.Integer.mk_numeral_i ctx i in
      Z3.Expr.mk_app ctx lit_operations.int_constructor [int_arg]

  | Boolean b ->
      let bool_arg =
        match b with
        | true  -> Boolean.mk_true ctx
        | false -> Boolean.mk_false ctx in
      Z3.Expr.mk_app ctx lit_operations.bool_constructor [bool_arg]

  | Loc l -> invalid_arg ("InternalError: Encoding.encode_value, tried to encode a location value " ^ (string_of_int l))

let encode_binop (op : bop) (v1 : Z3.Expr.expr) (v2 : Z3.Expr.expr) : Z3.Expr.expr =
  match op with
  | Plus 		-> binop_numbers_to_numbers   mk_add v1 v2
  | Minus		-> binop_numbers_to_numbers   mk_sub v1 v2
  | Times 	-> binop_numbers_to_numbers   mk_mul v1 v2
  | Div    	-> binop_numbers_to_numbers   mk_div v1 v2
  | Pow    	-> binop_numbers_to_numbers   mk_pow v1 v2
  | Gt 			-> binop_numbers_to_booleans  mk_gt  v1 v2
  | Lt			-> binop_numbers_to_booleans  mk_lt  v1 v2
  | Gte			-> binop_numbers_to_booleans  mk_gte v1 v2
  | Lte 		-> binop_numbers_to_booleans  mk_lte v1 v2
  | Equals 	-> binop_numbers_to_booleans  mk_eq  v1 v2
  | Or 			-> binop_booleans_to_booleans mk_or  v1 v2
  | And 		-> binop_booleans_to_booleans mk_and v1 v2
  | Xor 		-> binop_booleans_to_booleans mk_xor v1 v2
  | _ 			-> failwith ("TODO: Encoding.encode_binop, missing implementation of " ^ string_of_bop op)

let rec encode_expr (e : Expression.t) : Z3.Expr.expr =
  match e with
  | Val v -> encode_value v
  | Var v -> failwith ("InternalError: Encoding.encode_expr, tried to encode variable " ^ v)
  | UnOp (op, e) ->
      let e' = encode_expr e in
      encode_unop op e'
  | BinOp (op, e1, e2) ->
      let e1' = encode_expr e1 and e2' = encode_expr e2 in
      encode_binop op e1' e2'
  | SymbVal s -> Z3.Expr.mk_const ctx (mk_string_symb s) z3_sort
  | SymbInt s -> Z3.Expr.mk_app ctx lit_operations.int_constructor [Z3.Expr.mk_const ctx (mk_string_symb s) ints_sort]

let is_sat (exprs : Expression.t list) : bool =

  try
    let exprs'  = List.map encode_expr exprs in
    let exprs'' = List.map (fun x -> Z3.Expr.mk_app ctx lit_operations.bool_accessor [ x ]) exprs' in

    Z3.Solver.reset !solver;
    Z3.Solver.add   !solver exprs'';

    let status  = Z3.Solver.check !solver [] in

    match status with
    | Z3.Solver.SATISFIABLE 	-> true
    | Z3.Solver.UNSATISFIABLE -> false
    | Z3.Solver.UNKNOWN 			-> false

  with (Failure msg) ->
    Printf.printf "InternalError: Z3: call to solver failed with exception %s\n" msg;
    false
