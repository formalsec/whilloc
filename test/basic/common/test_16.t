Tests common 16:
  $ wl -i 16 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 16
  Execution mode: saf
  
  >Program Print
  (SymbInt $_miguel)
  (SymbInt $_rita)
  (SymbInt $_XXXXXXXXXXXXXXXXXX)
  
  >Program Print
  (+ (+ (SymbInt $_miguel) (Val Int 1)) (SymbInt $_rita))
  (SymbInt $_rita)
  (SymbInt $_XXXXXXXXXXXXXXXXXX)
  
  >Program Print
  (SymbInt $_nvidia)
  (SymbInt $_rita)
  (SymbInt $_XXXXXXXXXXXXXXXXXX)
  
  Outcome: Returned (* (SymbInt $_nvidia) (SymbInt $_XXXXXXXXXXXXXXXXXX))
