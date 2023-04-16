(*
open Lib

module S  = MakeInterpreter.M (EvalSymbolic.M) (BFS.M) (HeapConcrete.M)
module CC = MakeInterpreter.M (EvalConcolic.M) (DFS.M) (HeapConcrete.M)

let create_program (funcs : Program.func list) : Program.program =
  let prog    = Hashtbl.create Parameters.size in
  let replace =
    fun (prog : Program.program) (func : Program.func) ->
      let f = (Hashtbl.find_opt prog func.id) in
      match f with
        | None   -> Hashtbl.replace prog func.id func
        | Some _ -> failwith "BadProgram: function names must pairwise distinct" in
  List.iter (fun func -> replace prog func) funcs;
  prog

let parse_program (str : string) : Program.func list =
  let lexbuf = Lexing.from_string str in
  let funcs  = Parser.program_target Lexer.read lexbuf in
  funcs

let read_file (fname : string) : string =
  let ch = open_in fname in
  let str_file = really_input_string ch (in_channel_length ch) in
  close_in ch;
  str_file

let rec symbvalues2variables (e : Expression.t) : Expression.t =
  match e with
  | SymbVal s -> Var s
  | Val _ -> e
  | Var _ -> e
  | UnOp  (op, e)      -> UnOp  (op, symbvalues2variables e)
  | BinOp (op, e1, e2) -> BinOp (op, symbvalues2variables e1, symbvalues2variables e2)

let get_symbvalues (store : S.t Store.t) =
  let exprs  = Hashtbl.fold (fun _ y z -> y :: z ) store [] in                       (* collect the expressions in store *)
  let exprs' = List.fold_right (fun x y -> Expression.get_symbols x @ y) exprs [] in (* get symbolic values from each expression *)
  let uniq_cons x xs = if List.mem x xs then xs else x :: xs in
  let remove_dups xs = List.fold_right uniq_cons xs [] in                            (* remove duplicates *)
  remove_dups exprs' 

let symb2conc_store (store : S.t Store.t) (model : (string * Value.t) list) : CC.t Store.t =

  let variables  = Hashtbl.fold (fun x _ z -> x :: z ) store []     in
  let store'     = Store.create_empty_store (List.length variables) in
  let symbvalues = get_symbvalues store                             in

  let symbstore  = Store.create_store model in
  let add_symb x = if Store.exists symbstore x then ()
                   else let rnd_int = Utils.random_int () in Store.set symbstore x (Value.Integer rnd_int) in
  let ()         = List.iter add_symb symbvalues in
  
  let () = print_endline "model:" in
  let () = Model.print (Some model) in
  let () = print_endline "symbstore:" in
  let () = Store.print Value.string_of_value symbstore in
  let () = print_endline "store:" in
  let () = Store.print Expression.string_of_expression store in

  let eval var =  let e_s  = Store.get store var in
                  let e_s' = symbvalues2variables e_s in
                  let e_c  = EvalConcrete.M.eval symbstore e_s' in
                  Store.set store' var (e_c, e_s)
  in
  let ()     = List.iter eval variables in
  let () = print_endline "store':" in
  let () = Store.print EvalConcolic.M.to_string store' in
  store'

let symb2conc_callstack (cs : S.t Callstack.t) (model : (string * Value.t) list) : CC.t Callstack.t =
  let f x y =
    match x with
    | Callstack.Toplevel -> Callstack.Toplevel :: y
    | Callstack.Intermediate (store,cont,var) -> (Callstack.Intermediate (symb2conc_store store model, cont, var)) :: y
  in
  List.fold_right f cs []

let symb2conc_state (state : S.t State.t) : CC.t State.t =
  
  let s,cont,store,cs,pc = state in

  if (Encoding.is_sat pc) then
    
    let model = Encoding.get_model () in

    (* Create concolic store based on Z3's model *)
    let store' = symb2conc_store store model  in

    (* Create concolic callstack *)
    let cs'    = symb2conc_callstack cs model in

    (* To create a concolic path condition we build a big AND expression over the symbolic pc and make its concolic value "Boolean.true" *)
    let pc_s = List.fold_right (fun x y -> Expression.make_boperation And x y) pc Expression.make_true in
    let pc'  = [(Value.Boolean true, pc_s)] in

    (s,cont,store',cs',pc')

  else
    failwith ("InternalError: Tried to onvert a symbolic state to a concolic state with impossible path condition")

let symb2conc_return (return : S.t Return.t) : CC.t Return.t =
  let state,out = return in
  (symb2conc_state state, out)

let rec concolic_loop (program : Program.program) (global_pc : Expression.t PathCondition.t) 
                      (outs : CC.t Return.t list) (origin : CC.t State.t) : CC.t Return.t list = 

  let returns,conts = CC.interpret program ~origin () in
  ignore conts;

  let return = List.hd returns      in
  let pc_cc  = Return.get_pc return in

  let _,pc_s     = List.split pc_cc          in
  let neg_pc     = PathCondition.negate pc_s in
  let global_pc' = neg_pc::global_pc         in

  if Encoding.is_sat global_pc then
    let model = Encoding.get_model () in
    let ()    = SymbMap.update model  in
    concolic_loop program global_pc' (return::outs) origin
  else
    let _ = SymbMap.clear () in
    return::outs

(*
let hybrid_alternate (program : Program.program) : CC.t Return.t list = 
  
  let finals,conts = S.interpret program ()           in
  let conts        = List.map symb2conc_state  conts  in
  let finals       = List.map symb2conc_return finals in

  let rec iter_concolic res = function
    | [ ]  -> res
    | s::t -> let _,pc   = List.split (State.get_pathcondition s) in
              let rets,_ = CC.interpret program () ~origin:s in
              iter_concolic (res@rets) t
  in
  finals @ (iter_concolic [] conts)
*)

let hybrid_search (program : Program.program) : CC.t Return.t list = 
  
  let finals,conts = S.interpret program ()           in
  let conts        = List.map symb2conc_state  conts  in
  let finals       = List.map symb2conc_return finals in

  if List.length conts = 0 then print_endline "empty" else ();

  let rec iter_concolic res = function
    | [ ]  -> res
    | s::t -> let _,pc = List.split (State.get_pathcondition s) in
              let rets = concolic_loop program pc [] s in
              iter_concolic (res@rets) t
  in
  finals @ (iter_concolic [] conts)

(*
let hybrid (program : Program.program) (X : Interpreter.M) (Y : Interpreter.M) (transformer : X->Y) : Y Return.t list =
  let finals_X, conts_X = X.interpret program in
  let conts_Y           = List.map transformer conts_X  in
  let finals_Y1         = List.map transformer finals_X in
  let finals_Y2,_       = List.map (Y.interpret program) conts_Y in
  finals_Y1@finals_Y2
*)

let main =
  
  let filename = Sys.argv.(1) in
  let program  = filename |> read_file |> parse_program |> create_program in
  let returns  = hybrid_search program in
  print_endline (String.concat "\n" (List.map (Return.string_of_return EvalConcolic.M.to_string) returns))
*)

let main = print_endline "TEMP"

let _ = main