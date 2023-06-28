module Make
    (Eval : Eval_intf.M)
    (Search : Search_intf.M)
    (Heap : Heap_intf.M with type vt = Eval.t)
    (Choice : Choice_intf.Choice with type v = Eval.t and type h = Heap.t) :
  Interpreter_intf.M with type t = Eval.t and type h = Heap.t = struct
  open Program
  open Outcome

  type t = Eval.t
  type h = Heap.t
  type state = (Eval.t, Heap.t) SState.t

  (* Evaluates an expressions *)
  let eval = Eval.eval

  (* Evaluates a boolean expression *)
  let is_true = Eval.is_true

  (* Creates a fresh symbol *)
  let make_symbol = Eval.make_symbol

  (* Adds an expression to a path condition *)
  let add_condition = PathCondition.add_condition

  (* Integer constant that bounds the number of steps performed by the interpreter *)
  let tank = Parameters.tank

  (* Helper functions, common across many different contexts (concrete, symbolic, concolic,...) *)

  let initial_state (program : Program.program) : state * Program.stmt list =
    let main = Program.get_function Parameters.main_id program in
    let state =
      SState.
        {
          heap = Heap.init ();
          store = Store.create_empty_store Parameters.size;
          pc = PathCondition.create_pathcondition;
          cs = Callstack.create_callstack;
        }
    in
    (state, [ main.body ])

  (* -------------------------------------------------------------------------------- *)
  (* The interpreter itself. It consists of a 'step' function and a 'search' function *)
  (* -------------------------------------------------------------------------------- *)

  let ( let/ ) = Choice.bind

  (* The 'step' function is a small-step semantics evaluator and uses the "continuations" trick, and thus it is tail recursive. Note: the evaluation of expressions is big-step *)
  let rec step (prog : program) (s : Program.stmt) (cont : Program.stmt list) :
      Outcome.t Choice.t =
    let return stmts = Choice.return (Outcome.Cont stmts) in

    match s with
    | Skip | Clear -> return cont
    | Sequence (s1 :: s2) -> step prog s1 (s2 @ cont)
    | Assign (x, e) ->
        let/ state = Choice.get in
        let e' = eval state.store e in
        Store.set state.store x e';
        return cont
    | Symbol_bool (x, s) -> (
        let symb_opt = make_symbol s "bool" in
        match symb_opt with
        | None ->
            failwith
              "ApplicationError: tried to create a symbolic value in a \
               concrete execution context"
        | Some symb_val ->
            let/ state = Choice.get in
            Store.set state.store x symb_val;
            return cont)
    | Symbol_int (x, s) -> (
        let symb_opt = make_symbol s "int" in
        match symb_opt with
        | None ->
            failwith
              "ApplicationError: tried to create a symbolic value in a \
               concrete execution context"
        | Some symb_val ->
            let/ state = Choice.get in
            Store.set state.store x symb_val;
            return cont)
    | Symbol_int_c (x, s, c) -> (
        let symb_opt = make_symbol s "int" in
        match symb_opt with
        | None ->
            failwith
              "ApplicationError: tried to create a symbolic value in a \
               concrete execution context"
        | Some symb_val ->
            let/ state = Choice.get in
            Store.set state.store x symb_val;
            let e = eval state.store c in
            let pc' = add_condition state.pc e in
            if is_true pc' then return cont else Choice.return AssumeF)
    | Print es ->
        let/ state = Choice.get in
        let vs = List.map (eval state.store) es in
        print_endline ">Program Print";
        List.iter Eval.print vs;
        print_endline "";
        return cont
    | FunCall (x, f, es) ->
        let/ state = Choice.get in
        let vs = List.map (eval state.store) es in
        let f' = Program.get_function f prog in
        let xs = f'.args in
        let xvs =
          try List.combine xs vs
          with _ ->
            failwith ("TypeError: Argument arity mismatch when calling " ^ f)
        in
        let sto' = Store.create_store xvs in
        let frame = Callstack.Intermediate (state.store, cont, x) in
        let cs' = Callstack.push state.cs frame in
        let/ _ = Choice.set { state with cs = cs'; store = sto' } in
        return [ f'.body ]
    | Return e -> (
        let/ state = Choice.get in
        let v = eval state.store e in
        let frame = Callstack.top state.cs in
        let cs' = Callstack.pop state.cs in
        match frame with
        | Callstack.Intermediate (sto', cont', x) ->
            let sto'' = Store.dup sto' in
            Store.set sto'' x v;
            let/ _ = Choice.set { state with cs = cs'; store = sto'' } in
            return cont'
        | Callstack.Toplevel ->
            let/ _ = Choice.set { state with cs = cs' } in
            Choice.return @@ Outcome.Return (Eval.to_string v))
    | IfElse (e, s1, s2) ->
        let/ state = Choice.get in
        let v = eval state.store e in
        let/ b = Choice.select v in
        if b then return (s1 :: cont) else return (s2 :: cont)
    | While (e, body) as while_stmt ->
        let/ state = Choice.get in
        let v = eval state.store e in
        let/ b = Choice.select v in
        if b then return (body :: while_stmt :: cont) else return cont
    | Assume e ->
        let/ state = Choice.get in
        let v = eval state.store e in
        let/ b = Choice.select v in
        if b then return cont else Choice.return Outcome.AssumeF
    | Assert e ->
        let/ state = Choice.get in
        let v = eval state.store e in
        let/ b = Choice.select v in
        if b then return cont
        else
          let/ state' = Choice.get in
          let _, model = Eval.test_assert state'.pc in
          Choice.return
          @@ Outcome.Error model
    | New (x, e) ->
        let f_new (s : state) =
          let size = eval s.store e in
          let lst = Heap.malloc s.heap size s.pc in
          List.map
            (fun (hp, loc, pc') ->
              ( loc,
                SState.
                  {
                    heap = hp;
                    pc = pc';
                    store = Store.dup s.store;
                    cs = Callstack.dup s.cs;
                  } ))
            lst
        in
        let/ l = Choice.lift f_new in
        let/ state = Choice.get in
        Store.set state.store x l;
        return cont
    | Update (a, index, e) ->
        let f_update (s : state) =
          match Store.get_opt s.store a with
          | Some loc ->
              let index_v = eval s.store index in
              let v = eval s.store e in
              let b = Heap.in_bounds s.heap loc index_v s.pc in
              if b then
                let lst = Heap.update s.heap loc index_v v s.pc in
                let dup = List.length lst > 1 in
                List.map
                  (fun (hp, pc') ->
                    let store', cs' =
                      if dup then (Store.dup s.store, Callstack.dup s.cs)
                      else (s.store, s.cs)
                    in
                    ( (),
                      SState.{ heap = hp; pc = pc'; store = store'; cs = cs' }
                    ))
                  lst
              else failwith "Index out of bounds"
          | None -> failwith "InternalError: array is not defined"
        in
        let/ _ = Choice.lift f_update in
        return cont
    | LookUp (x, a, index) ->
        let f_lookup (s : state) =
          match Store.get_opt s.store a with
          | Some loc ->
              let index_v = eval s.store index in
              let b = Heap.in_bounds s.heap loc index_v s.pc in
              if b then
                let lst = Heap.lookup s.heap loc index_v s.pc in
                let dup = List.length lst > 1 in

                List.map
                  (fun (hp, v, pc') ->
                    let store', cs' =
                      if dup then (Store.dup s.store, Callstack.dup s.cs)
                      else (s.store, s.cs)
                    in
                    (v, SState.{ heap = hp; pc = pc'; store = store'; cs = cs' }))
                  lst
              else failwith "Index out of bounds"
          | None -> failwith "InternalError: array is not defined"
        in
        let/ v = Choice.lift f_lookup in
        let/ state = Choice.get in
        Store.set state.store x v;
        return cont
    | Delete _ ->
        assert false
        (*
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
  *)
    | _ -> assert false

  (* The 'search' function contains all the logic of the search of the state space, it kinda is like a scheduler of states *)
  let rec search (gas : int) (prog : program) (cont : Program.stmt list) :
      Outcome.t Choice.t =
    if gas = 0 then Choice.return Outcome.EndGas
    else
      match cont with
      (* allows programs to terminate without return-stmt *)
      | [] -> Choice.return (Outcome.Return "0")
      | s :: cont' -> (
          let/ out = step prog s cont' in
          match out with
          | Cont cont'' -> search (gas - 1) prog cont''
          | _ -> Choice.return out)

  (*
  let save_file path data =
    if not (Sys.file_exists path) then ignore (Sys.command ("mkdir -p " ^ path));
    let oc = open_out (path ^ "/report.json") in
    output_string oc data;
    close_out oc


  let write_report (loop_time : float) (paths : int) (step_count : int) (out : string) : unit =
    let solver_time =
      !Encoding.Incremental.solver_time +. !Encoding.Batch.solver_time
    in
    let solver_count =
      !Encoding.Incremental.solver_count + !Encoding.Batch.solver_count
    in
    let report_str =
      "{" ^ "\"loop_time\" : \"" ^ string_of_float loop_time ^ "\", "
      ^ "\"solver_time\" : \"" ^ string_of_float solver_time
      ^ "\", " ^ "\"paths_explored\" : " ^ string_of_int paths ^ ", "
      ^ "\"solver_counter\" : " ^ string_of_int solver_count ^ ", "
      ^ "\"instruction_counter\" : " ^ string_of_int step_count ^ "}"
    in
    save_file out report_str
  *)

  let interpret (prog : program) : (Outcome.t * state) list =
    let state, cont = initial_state prog in
    let exec = search tank prog cont in
    Choice.run state exec
end
