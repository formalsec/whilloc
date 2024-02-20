Tests simple1 with SAF:
  $ wl -i simple1.wl -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: simple1.wl
  Execution mode: saf
  
  Outcome: Returned (Val Int 0)
  Outcome: Assertion violated, counter example:
  				$_i : Int 22
  Outcome: Returned (Val Int 0)
  Outcome: Assertion violated, counter example:
  				$_i : Int -158

Tests simple1 with SAITE:
  $ wl -i simple1.wl -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: simple1.wl
  Execution mode: saite
  
  Outcome: Returned (Val Int 0)
  Outcome: Assertion violated, counter example:
  				$_i : Int 22
  Outcome: Returned (Val Int 0)
  Outcome: Assertion violated, counter example:
  				$_i : Int -158
