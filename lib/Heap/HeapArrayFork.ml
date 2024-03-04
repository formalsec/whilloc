open Term
open Value

module M : Heap_intf.M with type vt = Term.t = struct
  type bt = Term.t array
  type t = { map : (int, bt) Hashtbl.t; i : int }
  type vt = Term.t

  let init () : t = { map = Hashtbl.create Parameters.size; i = 0 }

  let block_str (block : bt) : string =
    let blockList = Array.to_list block in
    String.concat ", " (List.map (fun el -> Term.to_string el) blockList)

  let to_string (heap : t) : string =
    Hashtbl.fold (fun _ b acc -> block_str b ^ "\n" ^ acc) heap.map ""

  let is_within (sz : int) (index : vt) (pc : vt PC.t) : bool =
    let e1 = Term.Binop (Lt, index, Val (Value.Integer 0)) in
    let e2 = Term.Binop (Gte, index, Val (Value.Integer sz)) in
    let e3 = Term.Binop (Or, e1, e2) in

    not (Translator.is_sat ([ e3 ] @ pc))

  let in_bounds (heap : t) (arr : vt) (i : vt) (pc : vt PC.t) : bool
      =
    match arr with
    | Val (Loc l) -> (
        match Hashtbl.find_opt heap.map l with
        | Some a -> is_within (Array.length a) i pc
        | _ ->
            failwith
              "InternalError: HeapArrayFork.in_bounds, accessed array is not \
               in the heap")
    | _ ->
        failwith "InternalError: HeapArrayFork.in_bounds, arr must be location"

  let copy (heap : t) : t = { heap with map = Hashtbl.copy heap.map }

  let find_block (heap : t) (loc : vt) : int * bt =
    match loc with
    | Val (Loc loc') -> (
        let block = Hashtbl.find_opt heap.map loc' in
        match block with
        | Some block' -> (loc', block')
        | None -> failwith "Block does not exist")
    | _ -> failwith "Location needs to be a concrete value"

  let malloc (heap : t) (size : vt) (path : vt PC.t) :
      (t * vt * vt PC.t) list =
    match size with
    | Val (Integer size') ->
        let block = Array.make size' (Val (Integer 0)) in
        let _ = Hashtbl.add heap.map heap.i block in
        [ ({ heap with i = heap.i + 1 }, Val (Loc heap.i), path) ]
    | _ -> failwith "Size needs to be a concrete integer"

  let lookup (heap : t) (loc : vt) (index : vt) (path : vt PC.t) :
      (t * vt * vt PC.t) list =
    let _, block = find_block heap loc in
    match index with
    | Val (Integer index') ->
        let ret = Array.get block index' in
        [ (heap, ret, path) ]
    | I_symb sym ->
        let blockList = Array.to_list block in
        let temp =
          List.mapi
            (fun index' expr ->
              let cond = Binop (Equals, I_symb sym, Val (Integer index')) in
              (copy heap, expr, PC.add_condition path cond))
            blockList
        in
        List.filteri
          (fun index' _ ->
            (* can be optimized *)
            let e = Binop (Equals, index, Val (Integer index')) in
            Translator.is_sat ([ e ] @ path))
          temp
    | _ -> failwith "Invalid index"

  let update (heap : t) (loc : vt) (index : vt) (v : vt)
      (path : vt PC.t) : (t * vt PC.t) list =
    let loc, block = find_block heap loc in
    match index with
    | Val (Integer index') ->
        let _ = Array.set block index' v in
        let _ = Hashtbl.replace heap.map loc block in
        [ (heap, path) ]
    | I_symb sym ->
        let blockList = Array.to_list block in
        let temp =
          List.mapi
            (fun index' _ ->
              let newBlock = Array.copy block in
              let newHeap = Hashtbl.copy heap.map in
              let _ = Array.set newBlock index' v in
              let _ = Hashtbl.replace newHeap loc newBlock in
              let cond = Binop (Equals, I_symb sym, Val (Integer index')) in
              ( { heap with map = newHeap },
                PC.add_condition path cond ))
            blockList
        in
        List.filteri
          (fun index' _ ->
            (* can be optimized *)
            let e = Binop (Equals, index, Val (Integer index')) in
            Translator.is_sat (e :: path))
          temp
    | _ -> failwith "Invalid index"

  let free (heap : t) (loc : vt) (path : vt PC.t) :
      (t * vt PC.t) list =
    let loc', _ = find_block heap loc in
    let _ = Hashtbl.remove heap.map loc' in
    [ (heap, path) ]

  let clone h = copy h
end
