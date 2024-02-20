Tests array fork 1-3 with SAF:
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
  
  Loc: (Val Loc 0)
  Fatal error: exception Failure("Some Loc")
  [2]

  $ wl -i 3 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 3
  Execution mode: saf
  
  Loc: (Val Loc 0)
  Fatal error: exception Failure("Some Loc")
  [2]

Tests array fork 1-3 with SAITE:
  $ wl -i 1 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 1
  Execution mode: saite
  
  Outcome: Returned (Val Loc 0)
  Outcome: Assertion violated, counter example:
  				$_i : Int 3
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false

  $ wl -i 2 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 2
  Execution mode: saite
  
  Loc: (Val Loc 0)
  Fatal error: exception Failure("Some Loc")
  [2]

  $ wl -i 3 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 3
  Execution mode: saite
  
  Loc: (Val Loc 0)
  Fatal error: exception Failure("Some Loc")
  [2]
