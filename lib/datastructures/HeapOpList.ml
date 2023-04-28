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
        ^ "\n"
        ^ Int.to_string k
        ^ "-> ("
        ^ Expression.string_of_expression sz
        ^ ", " ^ "("
        ^ String.concat ", "
            (List.map
               (fun (i, v, _) ->
                 Expression.string_of_expression i
                 ^ " "
                 ^ Expression.string_of_expression v)
               ops)
        ^ ")" ^ ")")
      h.map ""

  let malloc (h : t) (sz : vt) (pc : vt PathCondition.t) :
      (t * vt * vt PathCondition.t) list =
    let next = h.next in
    Hashtbl.add h.map next (sz, []);
    h.next <- h.next + 1;
    [ (h, Val (Integer next), pc) ]

  let check_bounds (lower: addr) (upper : addr) (v : addr) : bool =
    ((v >= lower) && (v <= upper))

  let convert_to_int (v : vt) : addr option =
    match v with 
    | Val (Integer i) -> Some i
    | _ -> None


  let update (h : t) (arr : vt) (index : vt) (v : vt) (pc : vt PathCondition.t)
      : (t * vt PathCondition.t) list =
    let lbl = match arr with Val (Integer i) -> i | _ -> assert false in
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
    let lbl = match arr with Val (Integer i) -> i | _ -> assert false in
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
          (Expression.Val (Value.Integer (-1))) ops
      in
      [ (h, v, pc) ]
    | None -> 
      let v =
        List.fold_left
          (fun ac (i, v, _) ->
            Expression.ITE (Expression.BinOp (Expression.Equals, index, i), v, ac))
          (Expression.Val (Value.Integer (-1))) ops
      in
      [ (h, v, pc) ]
      
    (*
    x = new(10)
    x[1] = 1
    x[s] = 3
    z = x[u] + 1
  x[u] = ITE(
    u == s, 
    3 , 
    ITE(u == 1, 1, ????)
  )
*)
  let free h (arr : vt) (pc : vt PathCondition.t) :
      (t * vt PathCondition.t) list =
    let lbl = match arr with Val (Integer i) -> i | _ -> assert false in
    Hashtbl.remove h.map lbl;
    [ (h, pc) ]




  let in_bounds (heap : t) (v : vt) (i : vt) (pc : vt PathCondition.t) : bool = 
    ignore pc;
    ignore heap;
    ignore v;
    ignore i;
    failwith "not implemented"
end
