Tests Large Arrays Fail -> c_array c_write c_read:
  $ wl -i 10000 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 10000
  Execution mode: saf
  
  Fatal error: exception Failure("Index out of bounds")
  [2]
  $ wl -i 50000 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 50000
  Execution mode: saf
  
  Fatal error: exception Failure("Index out of bounds")
  [2]
  $ wl -i 100000 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 100000
  Execution mode: saf
  
  Fatal error: exception Failure("Index out of bounds")
  [2]
