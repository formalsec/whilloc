open Lib
open Value
open Expression
open Encoding

	let get_model' () : (string*Value.t) list = 

		match (Z3.Solver.get_model !solver) with
		
			| None       -> invalid_arg "InternalError: Encoding.get_model, there is no model given the last Check"
			| Some model -> (*print_endline ("\nModel:\n"^Z3.Model.to_string model);*)
				
				List.map
				(fun const ->
					let name 	  = Z3.Symbol.to_string (Z3.FuncDecl.get_name const) 		in
					let _ 	  	= Z3.Sort.to_string   (Z3.FuncDecl.get_range const)  	in
					let interp  = Z3.Model.get_const_interp model const |> Option.get in
					let interp' = Z3.Expr.to_string interp in
	
					let symb		= Z3.Expr.mk_const ctx (mk_string_symb name) z3_sort in 
	
					let get_type_z3 = (*get the type in the form "(Int", "(Bool",..., i.e. "(TYPE"; and then remove the left paranthesis *)
						fun t:string -> let str = (String.split_on_char ' ' t |> List.hd) in String.sub str 1 ((String.length str) - 1) in
	
					match get_type_z3 interp' with
	
					| "Int"  ->
							let x = Z3.Expr.mk_app ctx lit_operations.int_accessor [ symb ] in 
							let v = Z3.Model.eval model x true |> Option.get in
							let s = Z3.Arithmetic.Integer.numeral_to_string v in
							(name, Integer (int_of_string s))
							(*print_endline (Z3.Arithmetic.Integer.numeral_to_string v ^ " with sort " ^ sort ^ " with name " ^ name);*)
	
					| "Bool" ->
							let x = Z3.Expr.mk_app ctx lit_operations.bool_accessor [ symb ] in 
							let v = Z3.Model.eval model x true |> Option.get in
							let s = Z3.Expr.to_string v in
							(name, Boolean (bool_of_string s))
	
					| t 		 -> failwith ("InternalError: Encoding.string_binds, there is no corresponding type with " ^ t);
					)
	
				(Z3.Model.get_const_decls model)
let main = 
	print_endline "";
	let i1 = (Integer (-1)) in
	let _  = (Integer 2) in
	let i3 = (Integer 2) in

	let symb_x = (SymbVal "symb_val_x") in
	let symb_y = (SymbVal "symb_val_y") in
	let symb_z = (SymbVal "symb_val_z") in
	let symb_w = (SymbVal "symb_val_w") in

	let e2 = BinOp (Lt , symb_y, symb_z) in
	let e3 = BinOp (Lt, symb_x, symb_y) in
	let e4 = BinOp (Lt, symb_x, Val i3) in
	let e5 = BinOp (Gte, symb_x, Val i1) in
	let e6 = BinOp (Lte, symb_z, Val i3) in
	let e7 = UnOp (Not, symb_w) in

	let r = Encoding.is_sat [e2; e3; e4; e5; e6; e7] in

	let m = get_model' () in

	List.iter (fun (x,y) -> print_endline ( "Variable " ^ x ^ " has value " ^ (Value.string_of_value y))) m;

	print_endline (string_of_bool r);

	print_endline "Play.ml: Done"

(*let main =
	let npc = [Expression.Val (Value.Boolean(true)); Expression.Val (Value.Boolean(true)); Expression.Val (Value.Boolean(true))] in
	let npc = List.fold_right (fun x y -> Expression.BinOp(Expression.Or, Expression.negate x, y) ) npc (Expression.Val (Value.Boolean (false))) in
	let () = print_endline " " in
	Expression.print_expression npc*)

let _ = main

(*
let main =
	(* play with BinaryTree construction, etc *)
	
	let right = Node (5, Nil, Nil) in
	let left	= Node (3, Nil, Nil) in
	let tree 	= Node (4, left, right) in

	let tree = add_left tree 50 in
	let tree = add_left tree 0 in
	let tree = add_right tree 13 in
	let tree = add_right tree 73 in
	let tree = add_left tree 42 in

	print_endline (string_of_int (size tree));
	print_endline (string_of_int (depth tree));
	print_endline "\n";

	print_string (string_of_tree "" false string_of_int tree); 

	print_endline (to_graphviz string_of_int tree);
	print_endline "\n";
	
	print_endline "Play.ml: Done"

let _ = main
*)

(*
	let t = Val (Boolean true) in
	let _ = Val (Boolean false) in
		
	let i1 = Val (Integer 1) in
	let i2 = Val (Integer 2) in
	let i3 = Val (Integer 3) in

	let symb_x = Val (SymbVal "symb_val_x") in
	let symb_y = Val (SymbVal "symb_val_y") in
	let symb_z = Val (SymbVal "symb_val_z") in
	let symb_w = Val (SymbVal "symb_val_w") in

	let e1 = BinOp (Minus, i2, i1) in
	let e2 = BinOp (Plus , i2, i3) in
	let e3 = BinOp (Times, e2, symb_z) in
	let e4 = BinOp (Lt, symb_x, symb_y) in
	let e5 = BinOp (Gt, symb_z, e1) in
	let e6 = BinOp (Lte, e3, symb_y) in
	let e7 = BinOp (Equals, symb_w, t) in

	let _ = is_sat [e4; e5; e6; e7] in

	print_endline "Play.ml: Done"	 
*)