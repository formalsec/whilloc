open Smtml

module M = struct
  type value = Expr.t
  type block = value array
  type t = (int, block) Hashtbl.t * int

  exception BlockNotInHeap

  let init ?(next = 0) () : t = (Hashtbl.create Parameters.size, next)

  let pp_block fmt (block : block) =
    Fmt.fprintf fmt "%a"
      (Fmt.pp_lst ~pp_sep:Fmt.pp_comma Expr.pp)
      (Array.to_list block)

  let pp (fmt : Fmt.t) ((heap, _) : t) : unit =
    let open Fmt in
    let pp_binding fmt (_, v) = fprintf fmt "%a" pp_block v in
    fprintf fmt "%a" (pp_hashtbl ~pp_sep:pp_newline pp_binding) heap

  let to_string (heap : t) : string = Fmt.asprintf "%a" pp heap

  let is_within (sz : int) (index : value) (pc : value Pc.t) : bool =
    let e1 = Expr.(relop Ty.Ty_int Ty.Lt index (make @@ Val (Int 0))) in
    let e2 = Expr.(relop Ty.Ty_int Ty.Ge index (make @@ Val (Int sz))) in
    let e3 = Expr.(binop Ty.Ty_bool Ty.Or e1 e2) in

    not (Eval_symbolic.is_true (e3 :: pc))

  let in_bounds (heap : t) (arr : value) (i : value) (pc : value Pc.t) : bool =
    let h, _ = heap in
    match Expr.view arr with
    | Val (Int l) -> (
      match Hashtbl.find_opt h l with
      | Some a -> is_within (Array.length a) i pc
      | _ -> raise BlockNotInHeap )
    | _ ->
      failwith "InternalError: HeapArrayIte.in_bounds, arr must be location"

  let copy ((heap, i) : t) : t = (Hashtbl.copy heap, i)

  let find_block (heap : t) (loc : value) : int * block =
    let heap', _ = heap in
    match Expr.view loc with
    | Val (Int loc') -> (
      let block = Hashtbl.find_opt heap' loc' in
      match block with
      | Some block' -> (loc', block')
      | None -> failwith "Block does not exist" )
    | _ -> failwith "Location needs to be a concrete value"

  let malloc (h : t) (sz : value) (pc : value Pc.t) :
    (t * value * value Pc.t) list =
    let tbl, next = h in
    match Expr.view sz with
    | Val (Int i) ->
      Hashtbl.replace tbl next (Array.make i Expr.(make @@ Val (Int 0)));
      [ ((tbl, next + 1), Expr.(make @@ Val (Int next)), pc) ]
    | _ ->
      failwith "InternalError: HeapArrayIte.malloc, size must be an integer"

  let update (heap : t) (loc : value) (index : value) (v : value)
    (path : value Pc.t) : (t * value Pc.t) list =
    let heap', curr = heap in
    let loc, block = find_block heap loc in
    match Expr.view index with
    | Val (Int index') ->
      let _ = Array.set block index' v in
      let _ = Hashtbl.replace heap' loc block in
      [ ((heap', curr), path) ]
    | Symbol s when Symbol.type_of s = Ty_int ->
      let block' =
        Array.mapi
          (fun j old_expr ->
            let e = Expr.(relop Ty.Ty_bool Ty.Eq index (make @@ Val (Int j))) in
            if Eval_symbolic.is_true (e :: path) then
              Expr.(Bool.ite e v old_expr)
            else old_expr )
          block
      in
      let _ = Hashtbl.replace heap' loc block' in
      [ ((heap', curr), path) ]
    | _ -> failwith "Invalid index"

  let lookup (h : t) (arr : value) (index : value) (pc : value Pc.t) :
    (t * value * value Pc.t) list =
    let tbl, _ = h in
    match Expr.view index with
    | Val (Int i) -> (
      (* quando o 'index' tem tipo "value", por exemplo: 5,2,... *)
      match Expr.view arr with
      | Val (Int l) -> (
        match Hashtbl.find_opt tbl l with
        | Some arr -> [ (h, arr.(i), pc) ]
        | _ ->
          failwith
            "InternalError: HeapArrayIte, accessed array is not in the heap" )
      | _ ->
        failwith "InternalError:  HeapArrayIte.update, arr must be a location" )
    | _ -> (
      (* quando o 'index' tem tipo "expression", por exemplo: Binop(+,x_hat,2), Symb y_hat,... *)
      match Expr.view arr with
      | Val (Int l) -> (
        match Hashtbl.find_opt tbl l with
        | Some arr ->
          let aux =
            Array.of_list
              (List.filteri
                 (fun index' _ ->
                   (* can be optimized *)
                   let e =
                     Expr.(
                       relop Ty.Ty_bool Ty.Eq index (make @@ Val (Int index')) )
                   in
                   Eval_symbolic.is_true (e :: pc) )
                 (Array.to_list
                    (Array.mapi
                       (fun j e ->
                         ( Expr.(
                             relop Ty.Ty_bool Ty.Eq index (make @@ Val (Int j)) )
                         , e ) )
                       arr ) ) )
          in
          let f (bop, e) l =
            match Expr.view e with
            | Triop (_, Ty.Ite, a, b, _) ->
              let e1 = Expr.(binop Ty.Ty_bool Ty.And bop a) in
              Expr.(Bool.ite e1 b l)
            | _ -> Expr.(Bool.ite bop e l)
          in
          let expr = Array.fold_right f aux Expr.(make @@ Val (Int 0)) in
          [ (h, expr, pc) ]
        | _ ->
          failwith
            "InternalError: HeapArrayIte, accessed array is not in the heap" )
      | _ ->
        failwith "InternalError:  HeapArrayIte.update, arr must be a location" )

  let free (h : t) (arr : value) (pc : value Pc.t) : (t * value Pc.t) list =
    let tbl, _ = h in
    match Expr.view arr with
    | Val (Int l) -> (
      match Hashtbl.find_opt tbl l with
      | Some _ ->
        Hashtbl.replace tbl l (Array.make 0 Expr.(make @@ Val (Int 0)));
        [ (h, pc) ]
      | _ -> failwith "InternalError: HeapArrayIte.free, illegal free" )
    | _ -> failwith "InternalError: HeapArrayIte.free, arr must be location"

  let get_block ((h, _) : t) (addr : value) : block option =
    let addr' =
      match Expr.view addr with Val (Int l) -> l | _ -> assert false
    in
    match Hashtbl.find_opt h addr' with
    | Some block -> if Array.length block = 0 then None else Some block
    | None -> None

  let set_block (h : t) (addr : value) (block : block) : t =
    let h', _ = h in
    let addr' =
      match Expr.view addr with Val (Int l) -> l | _ -> assert false
    in
    Hashtbl.replace h' addr' block;
    h

  let clone h = copy h
end

module M' : Heap_intf.M with type value = Expr.t = M
include M
