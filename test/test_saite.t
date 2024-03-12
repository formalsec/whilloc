Tests Model ArrayITE:
  $ wl test basic -p --mode saite
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/arrayfork/1.wl
  Execution mode: saite
  
  Returned (Val Loc 0)
  Assertion violated, counter example:
      $_i : Int 3
  Assumption evaluated to false
  Assumption evaluated to false
  Found 1 problems!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/arrayfork/2.wl
  Execution mode: saite
  
  Returned (Val Loc 0)
  Assertion violated, counter example:
      $_i : Int 3
      $_v : Int 3
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Found 1 problems!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/arrayfork/3.wl
  Execution mode: saite
  
  Returned (Val Loc 0)
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/arrayite/1.wl
  Execution mode: saite
  
  Returned (Val Loc 0)
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
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
  
  Returned (Val Int 0)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/10.wl
  Execution mode: saite
  
  >Program Print
  (Val Int 11)
  
  >Program Print
  (Val Int 12)
  
  Returned (Val Int 1)
  Everything Ok!
  
  =====================
  	Whilloc
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
  
  Returned (+ (+ (SymbInt $_descending) (Val Int 3)) (* (Val Int 5) (Val Int 2)))
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/12.wl
  Execution mode: saite
  
  >Program Print
  (* (+ (SymbInt $_ok_computer) (Val Int 1)) (Val Int 2))
  
  Returned (+ (SymbInt $_ok_computer) (Val Int 1))
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/13.wl
  Execution mode: saite
  
  Returned (Val Bool true)
  Returned (Val Bool false)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/14.wl
  Execution mode: saite
  
  Returned (Val Int 10)
  Returned (Val Int 12)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/15.wl
  Execution mode: saite
  
  >Program Print
  (SymbInt $_x)
  
  Returned (Val Int 5)
  Returned (Val Int 4)
  Returned (Val Int 3)
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
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
  
  Returned (* (SymbInt $_nvidia) (SymbInt $_XXXXXXXXXXXXXXXXXX))
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/17.wl
  Execution mode: saite
  
  Returned (Val Bool true)
  Returned (Val Bool false)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/18.wl
  Execution mode: saite
  
  >Program Print
  (Val Bool true)
  
  >Program Print
  (Val Bool false)
  
  Returned (+ (SymbInt $_x) (Val Int 1))
  Returned (+ (SymbInt $_x) (Val Int 1))
  Everything Ok!
  
  =====================
  	Whilloc
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
  
  Returned (Val Int -1)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/3.wl
  Execution mode: saite
  
  Assertion violated, counter example:
      Empty model
  Found 1 problems!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/4.wl
  Execution mode: saite
  
  >Program Print
  (Val Int 6)
  
  >Program Print
  (Val Int 7)
  
  Returned (Val Int 9)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/5.wl
  Execution mode: saite
  
  >Program Print
  (Val Int 24)
  
  Returned (Val Int 12)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/6.wl
  Execution mode: saite
  
  Assertion violated, counter example:
      Empty model
  Found 1 problems!
  
  =====================
  	Whilloc
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
  
  Returned (Val Int 1)
  Everything Ok!
  
  =====================
  	Whilloc
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
  
  Returned (Val Int 73)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/9.wl
  Execution mode: saite
  
  >Program Print
  (Val Int -1)
  
  Returned (Val Int -1)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/array.wl
  Execution mode: saite
  
  >Program Print
  (Val Int 5)
  
  Returned (Val Loc 0)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/factorial.wl
  Execution mode: saite
  
  Returned (Val Int 120)
  Returned (Val Int 24)
  Returned (Val Int 6)
  Returned (Val Int 2)
  Returned (Val Int 1)
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/simple1.wl
  Execution mode: saite
  
  Returned (Val Int 0)
  Assertion violated, counter example:
      $_i : Int 22
  Returned (Val Int 0)
  Assertion violated, counter example:
      $_i : Int -158
  Found 2 problems!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/statements/delete.wl
  Execution mode: saite
  
  >Program Print
  (Val Loc 0)
  
  >Program Print
  (Val Loc 0)
  
  Returned (Val Loc 0)
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/statements/symbol_int_c.wl
  Execution mode: saite
  
  Returned (Val Loc 0)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/tree/1.wl
  Execution mode: saite
  
  Fatal error: exception Failure("Index out of bounds")
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/tree/2.wl
  Execution mode: saite
  
  Fatal error: exception Failure("Index out of bounds")
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/tree/3.wl
  Execution mode: saite
  
  Returned (Val Loc 0)
  Assertion violated, counter example:
      $_i : Int 6
      $_j : Int 0
      $_k : Int 6
      $_v : Int 41
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Found 1 problems!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/tree/4.wl
  Execution mode: saite
  
  Returned (Val Loc 0)
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/tree/5.wl
  Execution mode: saite
  
  Returned (Val Loc 0)
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/wasm.wl
  Execution mode: saite
  
  Returned (Val Int 0)
  Assertion violated, counter example:
      $_x : Int 1
      $_y : Int 4
  Returned (Val Int 0)
  Returned (Val Int 0)
  Found 1 problems!
  Total number of files tested: 33

