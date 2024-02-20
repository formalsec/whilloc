Tests Large Arrays Fail -> s_array c_write c_read:
  $ wl -i 10000 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 10000
  Execution mode: saite
  
  Fatal error: exception Failure("InternalError: HeapArrayIte.malloc, size must be an integer")
  [2]
  $ wl -i 50000 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 50000
  Execution mode: saite
  
  Fatal error: exception Failure("InternalError: HeapArrayIte.malloc, size must be an integer")
  [2]
  $ wl -i 100000 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 100000
  Execution mode: saite
  
  Fatal error: exception Failure("InternalError: HeapArrayIte.malloc, size must be an integer")
  [2]
