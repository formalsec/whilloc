Tests array fork 1-3:
  $ wl -i 1 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 1
  Execution mode: saf
  
  Outcome: Returned (Val Loc 0)
  Outcome: Returned (Val Loc 0)
  Outcome: Returned (Val Loc 0)
  Outcome: Assertion violated, counter example:
  				$_i : Int 3
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false

  $ wl -i 2 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 2
  Execution mode: saf
  
  Fatal error: exception File "lib/interpreter.ml", line 257, characters 8-14: Assertion failed
  [2]

  $ wl -i 3 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 3
  Execution mode: saf
  
  Fatal error: exception File "lib/interpreter.ml", line 257, characters 8-14: Assertion failed
  [2]
