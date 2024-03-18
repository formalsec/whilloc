exception BlockNotInHeap

module M (Heap : Heap_intf.M) : Heap_intf.M with type value = Heap.value =
struct
  type value = Heap.value
  type block = Heap.block
  type h = Heap.t

  type t =
    { map : h
    ; parent : t option
    ; mutable next : int
    }

    
  let init ?(next = 0) () = { map = Heap.init (); parent = None; next }

  let rec pp (fmt : Fmt.t) (hh : t) : unit =
    match hh.parent with
    | None -> Fmt.fprintf fmt "%a" Heap.pp hh.map
    | Some hh' -> Fmt.fprintf fmt "%a@\n=>@\n%a" Heap.pp hh.map pp hh'

  let to_string (hh : t) = Fmt.asprintf "%a" pp hh

  let malloc (hh : t) (sz : value) (pc : value Pc.t) :
    (t * value * value Pc.t) list =
    hh.next <- hh.next + 1;
    List.map
      (fun (h, v, pc) -> ({ hh with map = h }, v, pc))
      (Heap.malloc hh.map sz pc)

  let update (hh : t) (addr : value) (index : value) (v : value)
    (pc : value Pc.t) : (t * value Pc.t) list =
    let rec update (hh' : t) =
      match Heap.get_block hh'.map addr with
      | Some block ->
        let new_h = Heap.set_block hh.map addr block in
        List.map
          (fun (h, pc) -> ({ hh' with map = h }, pc))
          (Heap.update new_h addr index v pc)
      | None -> (
        match hh'.parent with
        | Some parent -> update parent
        | None -> failwith "Block not found in" )
    in
    update hh

  let lookup (hh : t) (addr : value) (index : value) (pc : value Pc.t) :
    (t * value * value Pc.t) list =
    let rec lookup (hh' : t) =
      match Heap.get_block hh'.map addr with
      | Some _ ->
        List.map
          (fun (h, v, pc) -> ({ hh' with map = h }, v, pc))
          (Heap.lookup hh'.map addr index pc)
      | None -> (
        match hh'.parent with
        | Some parent -> lookup parent
        | None -> failwith "Block not found in" )
    in
    lookup hh

  let free (hh : t) (addr : value) (pc : value Pc.t) : (t * value Pc.t) list =
    let rec free (hh' : t) =
      match Heap.get_block hh'.map addr with
      | Some _ ->
        List.map
          (fun (h, pc) -> ({ hh' with map = h }, pc))
          (Heap.free hh'.map addr pc)
      | None -> (
        match hh'.parent with
        | Some parent -> free parent
        | None -> failwith "Block not found in" )
    in
    free hh

  let in_bounds (hh : t) (addr : value) (index : value) (pc : value Pc.t) : bool
      =
    let rec in_bounds (hh' : t) : bool =
      try Heap.in_bounds hh.map addr index pc
      with BlockNotInHeap -> (
        match hh'.parent with Some hh' -> in_bounds hh' | None -> false )
    in
    in_bounds hh

  let clone hh =
    { map = Heap.init () ~next:hh.next; parent = Some hh; next = hh.next }

  let get_block (hh : t) (addr : value) : block option =
    Heap.get_block hh.map addr

  let set_block (hh : t) (addr : value) (block : block) : t =
    Heap.set_block hh.map addr block |> fun map -> { hh with map }
end
