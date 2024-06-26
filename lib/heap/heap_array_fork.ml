open Smtml

module M = struct
  type value = Expr.t
  type block = value array

  type t =
    { map : (int, block) Hashtbl.t
    ; i : int
    }

  exception BlockNotInHeap

  let init ?(next = 0) () : t =
    { map = Hashtbl.create Parameters.size; i = next }

  let pp_block fmt (block : block) =
    Fmt.fprintf fmt "%a"
      (Fmt.pp_lst ~pp_sep:Fmt.pp_comma Expr.pp)
      (Array.to_list block)

  let pp (fmt : Fmt.t) (heap : t) : unit =
    let open Fmt in
    let pp_binding fmt (_, v) = fprintf fmt "%a" pp_block v in
    fprintf fmt "%a" (pp_hashtbl ~pp_sep:pp_newline pp_binding) heap.map

  let to_string (heap : t) : string = Format.asprintf "%a" pp heap

  let is_within (sz : int) (index : value) (pc : value Pc.t) : bool =
    let e1 = Expr.(relop Ty.Ty_int Ty.Lt index (make @@ Val (Int 0))) in
    let e2 = Expr.(relop Ty.Ty_int Ty.Ge index (make @@ Val (Int sz))) in
    let e3 = Expr.(binop Ty.Ty_bool Ty.Or e1 e2) in

    not (Eval_symbolic.is_true (e3 :: pc))

  let in_bounds (heap : t) (arr : value) (i : value) (pc : value Pc.t) : bool =
    match Expr.view arr with
    | Val (Int l) -> (
      match Hashtbl.find_opt heap.map l with
      | Some a -> is_within (Array.length a) i pc
      | _ -> raise BlockNotInHeap )
    | _ ->
      failwith "InternalError: HeapArrayFork.in_bounds, arr must be location"

  let copy (heap : t) : t = { heap with map = Hashtbl.copy heap.map }

  let find_block (heap : t) (loc : value) : int * block =
    match Expr.view loc with
    | Val (Int loc') -> (
      let block = Hashtbl.find_opt heap.map loc' in
      match block with
      | Some block' -> (loc', block')
      | None -> failwith "Block does not exist" )
    | _ -> failwith "Location needs to be a concrete value"

  let malloc (heap : t) (size : value) (path : value Pc.t) :
    (t * value * value Pc.t) list =
    match Expr.view size with
    | Val (Int size') ->
      let block = Array.make size' Expr.(make @@ Val (Int 0)) in
      let _ = Hashtbl.add heap.map heap.i block in
      [ ({ heap with i = heap.i + 1 }, Expr.(make @@ Val (Int heap.i)), path) ]
    | _ -> failwith "Size needs to be a concrete integer"

  let lookup (heap : t) (loc : value) (index : value) (path : value Pc.t) :
    (t * value * value Pc.t) list =
    let _, block = find_block heap loc in
    match Expr.view index with
    | Val (Int index') ->
      let ret = Array.get block index' in
      [ (heap, ret, path) ]
    | Symbol s when Symbol.type_of s = Ty_int ->
      let blockList = Array.to_list block in
      let temp =
        List.mapi
          (fun index' expr ->
            let cond =
              Expr.(relop Ty.Ty_bool Ty.Eq index (make @@ Val (Int index')))
            in
            (copy heap, expr, Pc.add_condition path cond) )
          blockList
      in
      List.filteri
        (fun index' _ ->
          (* can be optimized *)
          let e =
            Expr.(relop Ty.Ty_bool Ty.Eq index (make @@ Val (Int index')))
          in
          Eval_symbolic.is_true (e :: path) )
        temp
    | _ -> failwith "Invalid index"

  let update (heap : t) (loc : value) (index : value) (v : value)
    (path : value Pc.t) : (t * value Pc.t) list =
    let loc, block = find_block heap loc in
    match Expr.view index with
    | Val (Int index') ->
      let _ = Array.set block index' v in
      let _ = Hashtbl.replace heap.map loc block in
      [ (heap, path) ]
    | Symbol s when Symbol.type_of s = Ty_int ->
      let blockList = Array.to_list block in
      let temp =
        List.mapi
          (fun index' _ ->
            let newBlock = Array.copy block in
            let newHeap = Hashtbl.copy heap.map in
            let _ = Array.set newBlock index' v in
            let _ = Hashtbl.replace newHeap loc newBlock in
            let cond =
              Expr.(relop Ty.Ty_bool Ty.Eq index (make @@ Val (Int index')))
            in
            ({ heap with map = newHeap }, Pc.add_condition path cond) )
          blockList
      in
      List.filteri
        (fun index' _ ->
          (* can be optimized *)
          let e =
            Expr.(relop Ty.Ty_bool Ty.Eq index (make @@ Val (Int index')))
          in
          Eval_symbolic.is_true (e :: path) )
        temp
    | _ -> failwith "Invalid index"

  let free (heap : t) (loc : value) (path : value Pc.t) : (t * value Pc.t) list
      =
    let loc', _ = find_block heap loc in
    let _ =
      Hashtbl.replace heap.map loc' (Array.make 0 Expr.(make @@ Val (Int 0)))
    in
    [ (heap, path) ]

  let get_block (h : t) (addr : value) : block option =
    let addr' =
      match Expr.view addr with Val (Int l) -> l | _ -> assert false
    in
    match Hashtbl.find_opt h.map addr' with
    | Some block -> if Array.length block = 0 then None else Some block
    | None -> None

  let set_block (h : t) (addr : value) (block : block) : t =
    let addr' =
      match Expr.view addr with Val (Int l) -> l | _ -> assert false
    in
    Hashtbl.replace h.map addr' block;
    h

  let clone h = copy h
end

module M' : Heap_intf.M with type value = Expr.t = M
include M
