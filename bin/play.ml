open Lib
open Expression
open Encoding

let main =

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

let _ = main

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

	let _ = check [e4; e5; e6; e7] in

	print_endline "Done"	 
*)