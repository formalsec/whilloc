open Expression

module M : Heap.M with type vt = Expression.t = struct
  
  type  bt = Expression.t array
  type   t = (int, bt) Hashtbl.t * int
  type  vt = Expression.t

  let init () : t = (Hashtbl.create Parameters.size, 0)


  let block_str (block : bt) : string =
    let blockList = Array.to_list block in
    String.concat ", " (List.map (fun el -> Expression.string_of_expression el) blockList)


  let to_string (heap: t) : string =
    let (heap', _) = heap in 
    Hashtbl.fold (fun _ b acc -> (block_str b) ^ "\n" ^ acc) heap' ""
  
  
  let is_within (sz : int) (index : vt) (pc : vt PathCondition.t) : bool = 
    let e1 = Expression.BinOp (Lt, index, Val (Value.Integer (0))) in
    let e2 = Expression.BinOp (Gte, index, Val (Value.Integer (sz))) in
    let e3 = Expression.BinOp (Or, e1, e2) in

    not (Translator.is_sat ([e3] @ pc))


  let in_bounds (heap : t) (arr : vt) (i : vt) (pc : vt PathCondition.t) : bool = 
    let (h, _) = heap in 
      match arr with  
      |  Val Loc l -> 
        (match Hashtbl.find_opt h l with 
        | Some a -> is_within (Array.length a) i pc
        | _ -> failwith ("InternalError: HeapArrayITE.in_bounds, accessed array is not in the heap"))
      | _ -> failwith ("InternalError: HeapArrayITE.in_bounds, arr must be location")


  let find_block (heap : t) (loc : vt) : int * bt = 
    let (heap', _) = heap in
    match loc with
    | Val Loc loc' ->
      let block = Hashtbl.find_opt heap' loc' in ( 
        match block with 
        | Some block' -> (loc', block')
        | None -> failwith "Block does not exist"
      )
    | _ -> failwith "Location needs to be a concrete value"


  let malloc (h : t) (sz : vt) (pc : vt PathCondition.t) : (t * vt * vt PathCondition.t) list =
    let tbl, next = h in 
    match sz with
    | Val (Integer i) ->
        Hashtbl.replace tbl next (Array.make i (Val (Integer 0)));
        [ ((tbl, next+1), Val (Loc next), pc) ]
    | _ -> failwith ("InternalError: HeapArrayITE.malloc, size must be an integer")


  let update (heap : t) (loc : vt) (index : vt) (v : vt) (path : vt PathCondition.t)  : (t * vt PathCondition.t) list =
  let (heap', curr) = heap in
  let (loc, block) = find_block heap loc in
  match index with
  | Val Integer index' -> 
      let _ = Array.set block index' v in
      let _ = Hashtbl.replace heap' loc block in
      [((heap', curr), path)]
  | SymbVal _ -> (* SymbInt ?? *)
      let block' = Array.mapi (fun j old_expr -> 
        let e = BinOp(Equals,index,Val (Integer j)) in 
        if Translator.is_sat ([e] @ path) then Expression.ITE(e, v, old_expr)
        else old_expr) block in
      let _ = Hashtbl.replace heap' loc block' in
      [((heap', curr), path)]
  | _ -> failwith "Invalid index"

  let lookup (h : t) (arr : vt) (index : vt) (pc : vt PathCondition.t) : (t * vt * vt PathCondition.t) list =
    let tbl, _ = h in
    match index with
    | Val (Integer i) -> (* quando o 'index' tem tipo "value", por exemplo: 5,2,... *)
      (match arr with
        | Val (Loc l) ->
          (match Hashtbl.find_opt tbl l with 
            | Some arr -> [(h, arr.(i), pc)]
            | _ -> failwith ("InternalError: HeapArrayITE, accessed array is not in the heap"))
        | _ -> failwith("InternalError:  HeapArrayITE.update, arr must be a location"))
    | _ -> (* quando o 'index' tem tipo "expression", por exemplo: BinOp(+,x_hat,2), SymbVal y_hat,... *)
      (match arr with
        | Val (Loc l) ->
          (match Hashtbl.find_opt tbl l with 
            | Some arr ->
              let aux = Array.mapi (fun j e -> (BinOp(Equals,index,Val (Integer j)), e)) arr in
              let f = fun (bop,e) l -> ITE (bop, e, l) in
              let expr = Array.fold_right f aux (Val Error) in  (* Error ??? *)
              [(h,expr,pc)]

            | _ -> failwith ("InternalError: HeapArrayITE, accessed array is not in the heap"))
        | _ -> failwith("InternalError:  HeapArrayITE.update, arr must be a location"))
    

  let free (h : t) (arr : vt) (pc : vt PathCondition.t) : (t * vt PathCondition.t) list =
    let tbl, _ = h in 
    match arr with 
    | Val (Loc l) -> 
      (match Hashtbl.find_opt tbl l with 
      | Some _ ->
         Hashtbl.remove tbl l; 
         [ h, pc ]
      | _ -> failwith ("InternalError: HeapArrayITE.free, illegal free"))
    | _ -> failwith ("InternalError: HeapArrayITE.free, arr must be location")



end
