open Expression

module M : Heap.M with type vt = Expression.t = struct
  
  type   t = ((int, Expression.t array) Hashtbl.t * int)
  type  vt = Expression.t

  let init () : t = (Hashtbl.create Parameters.size, 0)

  let to_string (h : t) : string =
    ignore h;
    failwith "Not Implemented"
    
  let malloc (h : t) (sz : vt) (pc : vt PathCondition.t) : (t * vt * vt PathCondition.t) list =
    let tbl, next = h in 
    match sz with
    | Val (Integer i) ->
        Hashtbl.replace tbl next (Array.make i (Val (Integer 0)));
        [ ((tbl, next+1), Val (Loc next), pc) ]
    | _ -> failwith ("InternalError: HeapBlockITE.malloc, size must be an integer")
  
  let update (h : t) (arr : vt) (index : vt) (v : vt) (pc : vt PathCondition.t)  : (t * vt PathCondition.t) list =
    let tbl, _ = h in
    
    match index with
      
    | Val (Integer i) -> (* quando o 'index' tem tipo "value", por exemplo: 5,2,... *)
      (
        match arr with
        | Val (Loc l) ->
          (
            match Hashtbl.find_opt tbl l with 
            | Some arr -> 
                arr.(i) <- v;
                [ (h, pc) ]
            | _ -> failwith ("InternalError: HeapBlockITE, accessed array is not in the heap")          
          )

        | _ -> failwith("InternalError:  HeapBlockITE.update, arr must be a location")
      )

    | _ -> (* quando o 'index' tem tipo "expression", por exemplo: BinOp(+,x_hat,2), SymbVal y_hat,... *)
      (
        match arr with
        | Val (Loc l) ->
          (
            match Hashtbl.find_opt tbl l with 
            | Some arr ->
                let _ = Array.mapi (fun j old_expr -> Expression.ITE (BinOp(Equals,index,Val (Integer j)), v, old_expr )) arr in
                [ (h, pc) ]
            | _ -> failwith ("InternalError: HeapBlockITE, accessed array is not in the heap")          
          )
        | _ -> failwith("InternalError:  HeapBlockITE.update, arr must be a location")
      )

  let lookup (h : t) (arr : vt) (index : vt) (pc : vt PathCondition.t) : (t * vt * vt PathCondition.t) list =
    let tbl, _ = h in
    
    match index with
      
    | Val (Integer i) -> (* quando o 'index' tem tipo "value", por exemplo: 5,2,... *)
      (
        match arr with
        | Val (Loc l) ->
          (
            match Hashtbl.find_opt tbl l with 
            | Some arr ->
                [ (h, arr.(i), pc) ]
            | _ -> failwith ("InternalError: HeapBlockITE, accessed array is not in the heap")          
          )

        | _ -> failwith("InternalError:  HeapBlockITE.update, arr must be a location")
      )

    | _ -> (* quando o 'index' tem tipo "expression", por exemplo: BinOp(+,x_hat,2), SymbVal y_hat,... *)
      (
        match arr with
        | Val (Loc l) ->
          (
            match Hashtbl.find_opt tbl l with 
            | Some arr ->

              let aux = Array.mapi (fun j e -> (BinOp(Equals,index,Val (Integer j)), e)) arr in

              let f = fun (bop,e) l -> ITE (bop, e, l) in
              let expr = Array.fold_right f aux (Val Error) in
              [ (h,expr,pc) ]

            | _ -> failwith ("InternalError: HeapBlockITE, accessed array is not in the heap")          
          )
        | _ -> failwith("InternalError:  HeapBlockITE.update, arr must be a location")
      )
    
    (*

    a = [2,1,2*#a,4]
    
    z = a[#i]

    /*
    A variável z tem contém a expressão:
    aux  = [(#i=0,2); (#i=1,1); (#i=2,2*#a); (#i=3,4)]
        
    expr = ITE (#i=0, 2, ITE(#i=1, 1, ITE(#i=2,2*#a, ITE(#i=3,4,ERROR) ) ) )
    (h, expr, pc)
    */

    *)
    
  let free (h : t) (arr : vt) (pc : vt PathCondition.t) : (t * vt PathCondition.t) list =
    let tbl, _ = h in 
    match arr with 
    | Val (Loc l) -> 
      (match Hashtbl.find_opt tbl l with 
      | Some _ ->
         Hashtbl.remove tbl l; 
         [ h, pc ]
      | _ -> failwith ("InternalError: HeapBlockITE.free, illegal free"))
    | _ -> failwith ("InternalError: HeapBlockITE.free, arr must be location")


  let in_bounds (heap : t) (v : vt) (i : vt) (pc : vt PathCondition.t) : bool = 
    ignore pc;
    ignore heap;
    ignore v;
    ignore i;
    failwith "not implemented"
end

(*
x := new (5); 
---- 
heap = { 1 -> { 0 -> 0, 1 -> 0, 2 -> 0, 3 -> 0, 4 -> 0} }
store = { x -> Loc 1 }
x[1] := 3; 
----
heap = { 1 -> { 0 -> 0, 1 -> 3, 2 -> 0, 3 -> 0, 4 -> 0} }
store = { x -> Loc 1 }
---
y := x[0]
---
heap = { 1 -> { 0 -> 0, 1 -> 3, 2 -> 0, 3 -> 0, 4 -> 0} }
store = { x -> Loc 1, y -> Int 0 }
---
delete (x)
---
heap = { }
store = { x -> Loc 1, y -> Int 0 }

*)
