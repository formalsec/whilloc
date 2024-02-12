Tests common 11:
  $ wl -i 11 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 11
  Execution mode: saf
  
  >Program Print
  (Val Int 6)
  
  >Program Print
  (SymbInt $_descending)
  
  >Program Print
  (+ (+ (SymbInt $_descending) (Val Int 3)) (* (Val Int 5) (Val Int 2)))
  
  >Program Print
  (+ (+ (+ (SymbInt $_descending) (Val Int 3)) (* (Val Int 5) (Val Int 2))) (Val Int 1))
  
  Outcome: Returned (+ (+ (SymbInt $_descending) (Val Int 3)) (* (Val Int 5) (Val Int 2)))
