Tests wasm with SAF:
  $ wl -i wasm.wl -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: wasm.wl
  Execution mode: saf
  
  Outcome: Returned (Val Int 0)
  Outcome: Assertion violated, counter example:
  				$_y : Int 4
  				$_x : Int 1
  Outcome: Returned (Val Int 0)
  Outcome: Returned (Val Int 0)

Tests wasm with SAITE:
  $ wl -i wasm.wl -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: wasm.wl
  Execution mode: saite
  
  Outcome: Returned (Val Int 0)
  Outcome: Assertion violated, counter example:
  				$_y : Int 4
  				$_x : Int 1
  Outcome: Returned (Val Int 0)
  Outcome: Returned (Val Int 0)
