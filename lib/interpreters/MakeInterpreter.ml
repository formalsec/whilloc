module M (Eval : Eval.M) (Search : Search.M) (Heap : Heap.M with type vt = Eval.t) : Interpreter.M with type t = Eval.t and type h = Heap.t = struct

  open Program
  open Outcome

  type t = Eval.t
  type h = Heap.t

  (* Evaluates an expressions *)
  let eval    = Eval.eval

  (* Evaluates a boolean expression *)
  let is_true = Eval.is_true

  (* Negates an expression *)
  let negate  = Eval.negate

  (* Creates a fresh symbol *)
  let make_symbol = Eval.make_symbol

  (* Asserts whether a given expression is true or not *)
  let test_assert = Eval.test_assert

  (* Adds an expression to a path condition *)
  let add_condition = PathCondition.add_condition

  (* Selects which state to expand given a set of candidate states *)
  let pick = Search.pick

  (* Merges the set of candidate states with the set of states returned by the 'step' function *)
  let join = Search.join

  (* Integer constant that bounds the number of steps performed by the interpreter *)
  let tank = Parameters.tank

  (* Helper functions, common across many different contexts (concrete, symbolic, concolic,...) *)

  let initial_state (program : Program.program) =
    let main  = Program.get_function Parameters.main_id program in
    let store = Store.create_empty_store Parameters.size        in
    let cs    = Callstack.create_callstack           in
    let pathc = PathCondition.create_pathcondition   in
    (Skip, [main.body], store, cs, pathc, Heap.init ())

  let is_final (result : (t,h) Return.t) : bool =
    let state,out = result in
    let (stmt',cont',_,_,_,_) = state in
    if stmt'=Program.Skip && cont'=[] && out=Outcome.Cont then failwith "BadProgram: functions should always return a value"
    else
    match out with
    | Cont     -> false
    | AssumeF  -> true
    | Error  _ -> true
    | Return _ -> true

  (* -------------------------------------------------------------------------------- *)
  (* The interpreter itself. It consists of a 'step' function and a 'search' function *)
  (* -------------------------------------------------------------------------------- *)

  (* The 'step' function is a small-step semantics evaluator and uses the "continuations" trick, and thus it is tail recursive. Note: the evaluation of expressions is big-step *)
  let step (prog : program) (state : (t,h) State.t) : (t,h) Return.t list =

    let s,cont,store,cs,pc,heap = state in

    match s with

    | Skip | Clear ->
      (match cont with
      | [ ]                     -> [ state, Cont  ]
      | next_statement :: cont' -> [ (next_statement, cont', store, cs, pc, heap), Cont  ])

    | Sequence (s1::s2) -> [ (s1, s2@cont, store, cs, pc, heap), Cont ]

    | Assign (x,e) ->
        let e' = eval store e in
        Store.set store x e';
        [ (Skip, cont, store, cs, pc, heap), Cont ]

    | Symbol (x,s) ->
        let symb_opt = make_symbol s in
        (match symb_opt with
        | None          -> failwith "ApplicationError: tried to create a symbolic value in a concrete execution context"
        | Some symb_val -> Store.set store x symb_val;
                           [ (Skip, cont, store, cs, pc, heap), Cont ])

    | Symbol_int (x,s) ->
        let symb_opt = make_symbol s in
        (match symb_opt with
        | None          -> failwith "ApplicationError: tried to create a symbolic value in a concrete execution context"
        | Some symb_val -> Store.set store x symb_val;
                           [ (Skip, cont, store, cs, pc, heap), Cont ])

    | Print exprs ->
        let exprs = List.map (eval store) exprs in
        let ()    = print_endline ">Program Print" in
        let ()    = List.iter Eval.print exprs; print_endline "" in
        [ (Skip, cont, store, cs, pc, heap), Cont ]

    | FunCall (var,id,args) ->
        let eval_args   = List.map (fun e -> eval store e) args in
        let function'   = Program.get_function id prog in
        let params      = function'.args in
        let var_vals    = try List.combine params eval_args
                          with _ -> failwith ("TypeError: Argument arity mismatch when calling " ^ id) in
        let func_init   = Store.create_store var_vals in
        let frame       = Callstack.Intermediate (store, cont, var) in
        let cs'         = Callstack.push cs frame in
        [ (function'.body, [], func_init, cs', pc, heap), Cont ]

    | Return e ->
        let v     = eval store e in
        let frame = Callstack.top cs in
        let cs'   = Callstack.pop cs in
          (match frame with
          | Callstack.Intermediate (store',rest,var) ->  let store'' = Store.dup store' in
                                                         Store.set store'' var v;
                                                         [ (Skip, rest, store'', cs', pc, heap), Cont ]
          | Callstack.Toplevel  -> [ (Skip, cont, store, cs', pc, heap), Return (Eval.to_string v) ])

    | IfElse (e, s1, s2) ->
        let e'  = eval store e in
        let e'' = negate e'    in

        let then_pc = add_condition pc e'  in
        let else_pc = add_condition pc e'' in

        let then_guard = is_true then_pc in
        let else_guard = is_true else_pc in

        let store' = if then_guard && else_guard then (Store.dup store) else store in

        let then_branch = if then_guard then [ (s1, cont, store , cs, then_pc, heap), Cont ] else [ ] in
        let else_branch = if else_guard then [ (s2, cont, store', cs, else_pc, heap), Cont ] else [ ] in

        then_branch @ else_branch

    | While (e,body) as while_stmt ->
        let e'  = eval store e  in
        let e'' = negate e'     in

        let true_pc  = add_condition pc e'  in
        let false_pc = add_condition pc e'' in

        let guard_true  = is_true true_pc   in
        let guard_false = is_true false_pc  in

        let store' = if guard_true && guard_false then (Store.dup store) else store in

        let body_branch = if guard_true  then [ ( body, while_stmt::cont, store , cs, true_pc,  heap ), Cont ] else [ ] in
        let skip_branch = if guard_false then [ ( Skip,             cont, store', cs, false_pc, heap ), Cont ] else [ ] in

        body_branch @ skip_branch

    | Assume e ->
        let e        = eval store e in
        let pc'      = add_condition pc e in
        let pc''     = add_condition pc (negate e) in
        let continue = is_true pc' in
        if continue then [ (Skip, cont, store, cs, pc' , heap ), Cont    ]
        else             [ (Skip, cont, store, cs, pc'', heap ), AssumeF ]

    | Assert e ->
        let e        = eval store e in
        let pc'      = add_condition pc e in
        let pc''     = add_condition pc (negate e) in
        let err,model = test_assert pc'' in
        if err then [ (Skip, cont, store, cs, pc , heap), Error model ]
        else        [ (Skip, cont, store, cs, pc', heap), Cont        ]

    | New (x, e) ->
        let size = eval store e in
        let lst = Heap.malloc heap size pc in
        let dup = (List.length lst) > 1 in
        List.map (fun (hp, loc, pc') ->
          let store', cs' =
            if dup then Store.dup store, Callstack.dup cs else store, cs in
          Store.set store' x loc;
          (Skip, cont, store', cs', pc', hp), Cont
        ) lst

    | Update (a, index, e) ->
        (match Store.get_opt store a with
        | Some loc ->

          let index_v = eval store index in
          let v = eval store e in
          let lst = Heap.update heap loc index_v v pc in
          let dup = (List.length lst) > 1 in

          List.map (fun (hp, pc') ->
            let store', cs' =
              if dup then Store.dup store, Callstack.dup cs else store, cs in
            (Skip, cont, store', cs', pc', hp), Cont
          ) lst
        | None -> failwith "InternalError: array is not defined")


    | LookUp (x, a, index) ->
        (match Store.get_opt store a with
        | Some loc ->
          let index_v = eval store index in
          let lst = Heap.lookup heap loc index_v pc in
          let dup = (List.length lst) > 1 in

          List.map (fun (hp, v, pc') ->
            let store', cs' =
              if dup then Store.dup store, Callstack.dup cs else store, cs in
            Store.set store' x v;
            (Skip, cont, store', cs', pc', hp), Cont
          ) lst
        | None -> failwith "InternalError: array is not defined")


    | Delete a ->
      (match Store.get_opt store a with
      | Some loc ->
        let lst = Heap.free heap loc pc in
        let dup = (List.length lst) > 1 in

        List.map (fun (hp, pc') ->
          let store', cs' =
            if dup then Store.dup store, Callstack.dup cs else store, cs in
          (Skip, cont, store', cs', pc', hp), Cont
        ) lst
      | None -> failwith "InternalError: array is not defined")

    | Sequence [ ] -> failwith "InternalError: Interpreter.step, reached an empty program"


  (* The 'search' function contains all the logic of the search of the state space, it kinda is like a scheduler of states *)
  let rec search (gas : int) (prog : program) (states : (t,h) State.t list) (returns : (t,h) Return.t list) : (t,h) Return.t list * (t,h) State.t list =

    if gas=0 || states=[] then returns,states else

    let state, states' = pick states     in
    let branches       = step prog state in

    let branches_final, branches_cont = List.partition is_final branches in
    let states_cont   , _             = List.split branches_cont         in

    search (gas-1) prog (join states_cont states') (returns @ branches_final)

  let interpret (prog : program) ?(origin=initial_state prog) () : (t,h) Return.t list * (t,h) State.t list =
    search tank prog [origin] [ ]

end
