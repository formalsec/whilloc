Tests Model ArrayITE:
  $ test_wl saite basic
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/arrayfork/1.wl
  Execution mode: saite
  
  Outcome: Returned (Val Loc 0)
  Outcome: Assertion violated, counter example:
  				$_i : Int 3
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/arrayfork/2.wl
  Execution mode: saite
  
  Outcome: Returned (Val Loc 0)
  Outcome: Assertion violated, counter example:
  				$_i : Int 0
  				$_v : Int 0
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/arrayfork/3.wl
  Execution mode: saite
  
  Outcome: Returned (Val Loc 0)
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/arrayite/1.wl
  Execution mode: saite
  
  Outcome: Returned (Val Loc 0)
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/1.wl
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
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/10.wl
  Execution mode: saite
  
  >Program Print
  (Val Int 11)
  
  >Program Print
  (Val Int 12)
  
  Outcome: Returned (Val Int 1)
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/11.wl
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
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/12.wl
  Execution mode: saite
  
  >Program Print
  (* (+ (SymbInt $_ok_computer) (Val Int 1)) (Val Int 2))
  
  Outcome: Returned (+ (SymbInt $_ok_computer) (Val Int 1))
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/13.wl
  Execution mode: saite
  
  Outcome: Returned (Val Bool true)
  Outcome: Returned (Val Bool false)
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/14.wl
  Execution mode: saite
  
  Outcome: Returned (Val Int 10)
  Outcome: Returned (Val Int 12)
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/15.wl
  Execution mode: saite
  
  >Program Print
  (SymbInt $_x)
  
  Outcome: Returned (Val Int 5)
  Outcome: Returned (Val Int 4)
  Outcome: Returned (Val Int 3)
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/16.wl
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
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/17.wl
  Execution mode: saite
  
  Outcome: Returned (Val Bool true)
  Outcome: Returned (Val Bool false)
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/18.wl
  Execution mode: saite
  
  >Program Print
  (Val Bool true)
  
  >Program Print
  (Val Bool false)
  
  Outcome: Returned (+ (SymbInt $_x) (Val Int 1))
  Outcome: Returned (+ (SymbInt $_x) (Val Int 1))
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/2.wl
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
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/3.wl
  Execution mode: saite
  
  Outcome: Assertion violated, counter example:Empty model
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/4.wl
  Execution mode: saite
  
  >Program Print
  (Val Int 6)
  
  >Program Print
  (Val Int 7)
  
  Outcome: Returned (Val Int 9)
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/5.wl
  Execution mode: saite
  
  >Program Print
  (Val Int 24)
  
  Outcome: Returned (Val Int 12)
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/6.wl
  Execution mode: saite
  
  Outcome: Assertion violated, counter example:Empty model
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/7.wl
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
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/8.wl
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
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/9.wl
  Execution mode: saite
  
  >Program Print
  (Val Int -1)
  
  Outcome: Returned (Val Int -1)
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/common/array.wl
  Execution mode: saite
  
  >Program Print
  (Val Int 5)
  
  Outcome: Returned (Val Loc 0)
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/factorial.wl
  Execution mode: saite
  
  Outcome: Returned (Val Int 120)
  Outcome: Returned (Val Int 24)
  Outcome: Returned (Val Int 6)
  Outcome: Returned (Val Int 2)
  Outcome: Returned (Val Int 1)
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/simple1.wl
  Execution mode: saite
  
  Outcome: Returned (Val Int 0)
  Outcome: Assertion violated, counter example:
  				$_i : Int 22
  Outcome: Returned (Val Int 0)
  Outcome: Assertion violated, counter example:
  				$_i : Int -158
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/statements/delete.wl
  Execution mode: saite
  
  >Program Print
  (Val Loc 0)
  
  >Program Print
  (Val Loc 0)
  
  Outcome: Returned (Val Loc 0)
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/statements/symbol_int_c.wl
  Execution mode: saite
  
  Outcome: Returned (Val Loc 0)
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/tree/1.wl
  Execution mode: saite
  
  Fatal error: exception Failure("Index out of bounds")
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/tree/2.wl
  Execution mode: saite
  
  Fatal error: exception Failure("Index out of bounds")
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/tree/3.wl
  Execution mode: saite
  
  Outcome: Returned (Val Loc 0)
  Outcome: Assertion violated, counter example:
  				$_i : Int 5
  				$_j : Int 0
  				$_v : Int 2
  				$_k : Int 5
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/tree/4.wl
  Execution mode: saite
  
  Outcome: Returned (Val Loc 0)
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/tree/5.wl
  Execution mode: saite
  
  Outcome: Returned (Val Loc 0)
  Outcome: Assumption evaluated to false
  Outcome: Assumption evaluated to false
  
  =====================
  	Ænima
  =====================
  
  Input file: basic/wasm.wl
  Execution mode: saite
  
  Outcome: Returned (Val Int 0)
  Outcome: Assertion violated, counter example:
  				$_y : Int 4
  				$_x : Int 1
  Outcome: Returned (Val Int 0)
  Outcome: Returned (Val Int 0)
  Total number of files tested: 33
