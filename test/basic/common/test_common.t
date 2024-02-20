Tests common 1-10 array with SAF:
  $ wl -i 1 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 1
  Execution mode: saf
  
  >Program Print
  (Val Int 6)
  
  >Program Print
  (Val Int 28)
  
  >Program Print
  (Val Int 5)
  
  >Program Print
  (Val Int 5)
  
  >Program Print
  (Val Int 10)
  
  >Program Print
  (Val Int 9)
  
  >Program Print
  (Val Int 1)
  (Val Int 1)
  
  >Program Print
  (Val Int 1)
  (Val Int 2)
  
  >Program Print
  (Val Int 1)
  (Val Int 3)
  
  >Program Print
  (Val Int 1)
  (Val Int 4)
  
  >Program Print
  (Val Int 2)
  (Val Int 1)
  
  >Program Print
  (Val Int 2)
  (Val Int 2)
  
  >Program Print
  (Val Int 2)
  (Val Int 3)
  
  >Program Print
  (Val Int 2)
  (Val Int 4)
  
  >Program Print
  (Val Int 3)
  (Val Int 1)
  
  >Program Print
  (Val Int 3)
  (Val Int 2)
  
  >Program Print
  (Val Int 3)
  (Val Int 3)
  
  >Program Print
  (Val Int 3)
  (Val Int 4)
  
  >Program Print
  (Val Int 4)
  (Val Int 1)
  
  >Program Print
  (Val Int 4)
  (Val Int 2)
  
  >Program Print
  (Val Int 4)
  (Val Int 3)
  
  >Program Print
  (Val Int 4)
  (Val Int 4)
  
  Outcome: Returned (Val Int 0)
  $ wl -i 2 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 2
  Execution mode: saf
  
  >Program Print
  (Val Int 6)
  
  >Program Print
  (Val Bool false)
  
  >Program Print
  (Val Int 3)
  
  >Program Print
  (Val Int 2)
  
  Outcome: Returned (Val Int -1)
  $ wl -i 3 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 3
  Execution mode: saf
  
  Outcome: Assertion violated, counter example:Empty model
  $ wl -i 4 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 4
  Execution mode: saf
  
  >Program Print
  (Val Int 6)
  
  >Program Print
  (Val Int 7)
  
  Outcome: Returned (Val Int 9)
  $ wl -i 5 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 5
  Execution mode: saf
  
  >Program Print
  (Val Int 24)
  
  Outcome: Returned (Val Int 12)
  $ wl -i 6 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 6
  Execution mode: saf
  
  Outcome: Assertion violated, counter example:Empty model
  $ wl -i 7 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 7
  Execution mode: saf
  
  >Program Print
  (Val Bool true)
  
  >Program Print
  (Val Int 1)
  
  >Program Print
  (Val Int 0)
  
  >Program Print
  (Val Int 1)
  
  Outcome: Returned (Val Int 1)
  $ wl -i 8 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 8
  Execution mode: saf
  
  >Program Print
  (Val Bool true)
  (Val Bool true)
  
  >Program Print
  (Val Bool false)
  (Val Bool true)
  (Val Int 5)
  
  >Program Print
  (Val Int 146)
  
  Outcome: Returned (Val Int 73)
  $ wl -i 9 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 9
  Execution mode: saf
  
  >Program Print
  (Val Int -1)
  
  Outcome: Returned (Val Int -1)
  $ wl -i 10 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 10
  Execution mode: saf
  
  >Program Print
  (Val Int 11)
  
  >Program Print
  (Val Int 12)
  
  Outcome: Returned (Val Int 1)
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
  $ wl -i 12 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 12
  Execution mode: saf
  
  >Program Print
  (* (+ (SymbInt $_ok_computer) (Val Int 1)) (Val Int 2))
  
  Outcome: Returned (+ (SymbInt $_ok_computer) (Val Int 1))
  $ wl -i 13 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 13
  Execution mode: saf
  
  Outcome: Returned (Val Bool true)
  Outcome: Returned (Val Bool false)
  $ wl -i 14 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 14
  Execution mode: saf
  
  Outcome: Returned (Val Int 10)
  Outcome: Returned (Val Int 12)
  $ wl -i 15 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 15
  Execution mode: saf
  
  >Program Print
  (SymbInt $_x)
  
  Outcome: Returned (Val Int 5)
  Outcome: Returned (Val Int 4)
  Outcome: Returned (Val Int 3)
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
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
  $ wl -i 17 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 17
  Execution mode: saf
  
  Outcome: Returned (Val Bool true)
  Outcome: Returned (Val Bool false)
  $ wl -i 18 -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: 18
  Execution mode: saf
  
  >Program Print
  (Val Bool true)
  
  >Program Print
  (Val Bool false)
  
  Outcome: Returned (+ (SymbInt $_x) (Val Int 1))
  Outcome: Returned (+ (SymbInt $_x) (Val Int 1))
  $ wl -i array -m saf
  
  =====================
  	Ænima
  =====================
  
  Input file: array
  Execution mode: saf
  
  >Program Print
  (Val Int 5)
  
  Loc: (Val Loc 0)
  Fatal error: exception Failure("Some Loc")
  [2]


Tests common 1-10 array with SAITE:
  $ wl -i 1 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 1
  Execution mode: saite
  
  >Program Print
  (Val Int 6)
  
  >Program Print
  (Val Int 28)
  
  >Program Print
  (Val Int 5)
  
  >Program Print
  (Val Int 5)
  
  >Program Print
  (Val Int 10)
  
  >Program Print
  (Val Int 9)
  
  >Program Print
  (Val Int 1)
  (Val Int 1)
  
  >Program Print
  (Val Int 1)
  (Val Int 2)
  
  >Program Print
  (Val Int 1)
  (Val Int 3)
  
  >Program Print
  (Val Int 1)
  (Val Int 4)
  
  >Program Print
  (Val Int 2)
  (Val Int 1)
  
  >Program Print
  (Val Int 2)
  (Val Int 2)
  
  >Program Print
  (Val Int 2)
  (Val Int 3)
  
  >Program Print
  (Val Int 2)
  (Val Int 4)
  
  >Program Print
  (Val Int 3)
  (Val Int 1)
  
  >Program Print
  (Val Int 3)
  (Val Int 2)
  
  >Program Print
  (Val Int 3)
  (Val Int 3)
  
  >Program Print
  (Val Int 3)
  (Val Int 4)
  
  >Program Print
  (Val Int 4)
  (Val Int 1)
  
  >Program Print
  (Val Int 4)
  (Val Int 2)
  
  >Program Print
  (Val Int 4)
  (Val Int 3)
  
  >Program Print
  (Val Int 4)
  (Val Int 4)
  
  Outcome: Returned (Val Int 0)
  $ wl -i 2 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 2
  Execution mode: saite
  
  >Program Print
  (Val Int 6)
  
  >Program Print
  (Val Bool false)
  
  >Program Print
  (Val Int 3)
  
  >Program Print
  (Val Int 2)
  
  Outcome: Returned (Val Int -1)
  $ wl -i 3 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 3
  Execution mode: saite
  
  Outcome: Assertion violated, counter example:Empty model
  $ wl -i 4 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 4
  Execution mode: saite
  
  >Program Print
  (Val Int 6)
  
  >Program Print
  (Val Int 7)
  
  Outcome: Returned (Val Int 9)
  $ wl -i 5 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 5
  Execution mode: saite
  
  >Program Print
  (Val Int 24)
  
  Outcome: Returned (Val Int 12)
  $ wl -i 6 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 6
  Execution mode: saite
  
  Outcome: Assertion violated, counter example:Empty model
  $ wl -i 7 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 7
  Execution mode: saite
  
  >Program Print
  (Val Bool true)
  
  >Program Print
  (Val Int 1)
  
  >Program Print
  (Val Int 0)
  
  >Program Print
  (Val Int 1)
  
  Outcome: Returned (Val Int 1)
  $ wl -i 8 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 8
  Execution mode: saite
  
  >Program Print
  (Val Bool true)
  (Val Bool true)
  
  >Program Print
  (Val Bool false)
  (Val Bool true)
  (Val Int 5)
  
  >Program Print
  (Val Int 146)
  
  Outcome: Returned (Val Int 73)
  $ wl -i 9 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 9
  Execution mode: saite
  
  >Program Print
  (Val Int -1)
  
  Outcome: Returned (Val Int -1)
  $ wl -i 10 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 10
  Execution mode: saite
  
  >Program Print
  (Val Int 11)
  
  >Program Print
  (Val Int 12)
  
  Outcome: Returned (Val Int 1)
  $ wl -i 11 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 11
  Execution mode: saite
  
  >Program Print
  (Val Int 6)
  
  >Program Print
  (SymbInt $_descending)
  
  >Program Print
  (+ (+ (SymbInt $_descending) (Val Int 3)) (* (Val Int 5) (Val Int 2)))
  
  >Program Print
  (+ (+ (+ (SymbInt $_descending) (Val Int 3)) (* (Val Int 5) (Val Int 2))) (Val Int 1))
  
  Outcome: Returned (+ (+ (SymbInt $_descending) (Val Int 3)) (* (Val Int 5) (Val Int 2)))
  $ wl -i 12 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 12
  Execution mode: saite
  
  >Program Print
  (* (+ (SymbInt $_ok_computer) (Val Int 1)) (Val Int 2))
  
  Outcome: Returned (+ (SymbInt $_ok_computer) (Val Int 1))
  $ wl -i 13 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 13
  Execution mode: saite
  
  Outcome: Returned (Val Bool true)
  Outcome: Returned (Val Bool false)
  $ wl -i 14 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 14
  Execution mode: saite
  
  Outcome: Returned (Val Int 10)
  Outcome: Returned (Val Int 12)
  $ wl -i 15 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 15
  Execution mode: saite
  
  >Program Print
  (SymbInt $_x)
  
  Outcome: Returned (Val Int 5)
  Outcome: Returned (Val Int 4)
  Outcome: Returned (Val Int 3)
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  $ wl -i 16 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 16
  Execution mode: saite
  
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
  $ wl -i 17 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 17
  Execution mode: saite
  
  Outcome: Returned (Val Bool true)
  Outcome: Returned (Val Bool false)
  $ wl -i 18 -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: 18
  Execution mode: saite
  
  >Program Print
  (Val Bool true)
  
  >Program Print
  (Val Bool false)
  
  Outcome: Returned (+ (SymbInt $_x) (Val Int 1))
  Outcome: Returned (+ (SymbInt $_x) (Val Int 1))
  $ wl -i array -m saite
  
  =====================
  	Ænima
  =====================
  
  Input file: array
  Execution mode: saite
  
  >Program Print
  (Val Int 5)
  
  Loc: (Val Loc 0)
  Fatal error: exception Failure("Some Loc")
  [2]
