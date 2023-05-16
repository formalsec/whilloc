module M : Heap.M with type vt = Expression.t = struct

  type addr = int
  type size = Expression.t
  type op = Expression.t * Expression.t * Expression.t PathCondition.t
  type t = { map : (addr, size * op list) Hashtbl.t; mutable next : int }
  type vt = Expression.t

  let init () : t = { map = Hashtbl.create Parameters.size; next = 0 }

  let to_string (h : t) : string =
    Hashtbl.fold
      (fun k (sz, ops) accum -> 
        accum 
        ^ Int.to_string k
        ^ " -> ("
        ^ Expression.string_of_expression sz
        ^ ", " ^ "["
        ^ String.concat ", "
            (List.map
               (fun (i, v, _) ->
                 Expression.string_of_expression i
                 ^ " "
                 ^ Expression.string_of_expression v)
               ops)
        ^ "]" ^ ")")
      h.map ""


  let is_within (sz : int) (index : vt) (pc : vt PathCondition.t) : bool = 
    let e1 = Expression.BinOp (Lt, index, Val (Value.Integer (0))) in
    let e2 = Expression.BinOp (Gte, index, Val (Value.Integer (sz))) in
    let e3 = Expression.BinOp (Or, e1, e2) in

    not (Translator.is_sat ([e3] @ pc))


  let in_bounds (heap : t) (v : vt) (i : vt) (pc : vt PathCondition.t) : bool = 
    match v with  
    | Val Loc l -> 
      (match Hashtbl.find_opt heap.map l with 
      | Some (sz, _)  -> 
          (match sz with
          | Val (Integer (sz')) -> is_within sz' i pc
          | _ -> failwith ("InternalError: HeapOpList.in_bounds, size not an integer"))
      | _ -> failwith ("InternalError: HeapOpList.in_bounds, accessed OpList is not in the heap"))
    | _ -> failwith ("InternalError: HeapOpList.in_bounds, v must be location")


  let malloc (h : t) (sz : vt) (pc : vt PathCondition.t) :
      (t * vt * vt PathCondition.t) list =
    let next = h.next in
    Hashtbl.add h.map next (sz, []);
    h.next <- h.next + 1;
    [ (h, Val (Loc next), pc) ]


  let check_bounds (lower: addr) (upper : addr) (v : addr) : bool =
    ((v >= lower) && (v <= upper))


  let convert_to_int (v : vt) : addr option =
    match v with 
    | Val (Integer i) -> Some i
    | Val (Loc i)     -> Some i
    | _ -> None


  let update (h : t) (arr : vt) (index : vt) (v : vt) (pc : vt PathCondition.t)
      : (t * vt PathCondition.t) list =
    let lbl = match arr with Val (Loc i) -> i | _ -> assert false in
    let arr' = Hashtbl.find_opt h.map lbl in
    let size, _ = Option.get arr' in
    let size' = Option.get(convert_to_int size) in

    match (convert_to_int index) with
    | Some i ->  
      if not (check_bounds 0 size' i) then failwith "out of bounds";
      let f ((sz, oplist) : size * op list) : unit =
        Hashtbl.replace h.map lbl (sz, (index, v, pc) :: oplist)
      in
      Option.fold ~none:() ~some:f arr';
      [ (h, pc) ]
    | None -> 
      let f ((sz, oplist) : size * op list) : unit =
        Hashtbl.replace h.map lbl (sz, (index, v, pc) :: oplist)
      in
      Option.fold ~none:() ~some:f arr';
      [ (h, pc) ]


  let lookup h (arr : vt) (index : vt) (pc : vt PathCondition.t) :
      (t * vt * vt PathCondition.t) list =
    let lbl = match arr with Val (Loc i) -> i | _ -> assert false in
    let arr' = Hashtbl.find h.map lbl in
    let size, ops = arr' in
    let size' = Option.get(convert_to_int size) in
    match (convert_to_int index) with
    | Some i ->  
      if not (check_bounds 0 size' i) then failwith "out of bounds";
      let v =
        List.fold_left
          (fun ac (i, v, _) ->
            Expression.ITE (Expression.BinOp (Expression.Equals, index, i), v, ac))
          (Expression.Val (Value.Integer (0))) ops
      in
      [ (h, v, pc) ]
    | None -> 
      let v =
        List.fold_left
          (fun ac (i, v, _) ->
            Expression.ITE (Expression.BinOp (Expression.Equals, index, i), v, ac))
          (Expression.Val (Value.Integer (0))) ops
      in
      [ (h, v, pc) ]
      

  let free h (arr : vt) (pc : vt PathCondition.t) :
      (t * vt PathCondition.t) list =
    let lbl = match arr with Val (Integer i) -> i | _ -> assert false in
    Hashtbl.remove h.map lbl;
    [ (h, pc) ]

end
