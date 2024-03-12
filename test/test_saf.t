Tests Model ArrayFork:
  $ wl test basic -p --mode saf
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/arrayfork/1.wl
  Execution mode: saf
  
  Returned 0
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 3
  Assumption evaluated to false
  Assumption evaluated to false
  Found 1 problems!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/arrayfork/2.wl
  Execution mode: saf
  
  Assertion violated, counter example:
      $_i : Int 0
      $_v : Int 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 1
      $_v : Int 1
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 2
      $_v : Int 2
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 3
      $_v : Int 3
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Found 4 problems!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/arrayfork/3.wl
  Execution mode: saf
  
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/arrayite/1.wl
  Execution mode: saf
  
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/1.wl
  Execution mode: saf
  
  >Program Print
  (int.mul (int.mul (int.mul 1 1) (int.add 1 1)) (int.add (int.add 1 1) 1))
  
  >Program Print
  (int.div (int.mul (int.mul (int.mul (int.mul (int.mul (int.mul (int.mul (int.mul 1 1) (int.add 1 1)) (int.add (int.add 1 1) 1)) (int.add (int.add (int.add 1 1) 1) 1)) (int.add (int.add (int.add (int.add 1 1) 1) 1) 1)) (int.add (int.add (int.add (int.add (int.add 1 1) 1) 1) 1) 1)) (int.add (int.add (int.add (int.add (int.add (int.add 1 1) 1) 1) 1) 1) 1)) (int.add (int.add (int.add (int.add (int.add (int.add (int.add 1 1) 1) 1) 1) 1) 1) 1)) (int.mul (int.mul (int.mul (int.mul (int.mul (int.mul (int.mul 1 1) (int.add 1 1)) (int.add (int.add 1 1) 1)) (int.add (int.add (int.add 1 1) 1) 1)) (int.add (int.add (int.add (int.add 1 1) 1) 1) 1)) (int.add (int.add (int.add (int.add (int.add 1 1) 1) 1) 1) 1)) (int.mul (int.mul 1 1) (int.add 1 1))))
  
  >Program Print
  5
  
  >Program Print
  5
  
  >Program Print
  (int.add 5 5)
  
  >Program Print
  (int.mul 3 3)
  
  >Program Print
  1
  1
  
  >Program Print
  1
  (int.add 1 1)
  
  >Program Print
  1
  (int.add (int.add 1 1) 1)
  
  >Program Print
  1
  (int.add (int.add (int.add 1 1) 1) 1)
  
  >Program Print
  (int.add 1 1)
  1
  
  >Program Print
  (int.add 1 1)
  (int.add 1 1)
  
  >Program Print
  (int.add 1 1)
  (int.add (int.add 1 1) 1)
  
  >Program Print
  (int.add 1 1)
  (int.add (int.add (int.add 1 1) 1) 1)
  
  >Program Print
  (int.add (int.add 1 1) 1)
  1
  
  >Program Print
  (int.add (int.add 1 1) 1)
  (int.add 1 1)
  
  >Program Print
  (int.add (int.add 1 1) 1)
  (int.add (int.add 1 1) 1)
  
  >Program Print
  (int.add (int.add 1 1) 1)
  (int.add (int.add (int.add 1 1) 1) 1)
  
  >Program Print
  (int.add (int.add (int.add 1 1) 1) 1)
  1
  
  >Program Print
  (int.add (int.add (int.add 1 1) 1) 1)
  (int.add 1 1)
  
  >Program Print
  (int.add (int.add (int.add 1 1) 1) 1)
  (int.add (int.add 1 1) 1)
  
  >Program Print
  (int.add (int.add (int.add 1 1) 1) 1)
  (int.add (int.add (int.add 1 1) 1) 1)
  
  Returned 0
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/10.wl
  Execution mode: saf
  
  >Program Print
  (int.add 10 1)
  
  >Program Print
  (int.add (int.add 10 1) 1)
  
  Returned 1
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/11.wl
  Execution mode: saf
  
  >Program Print
  (int.add 5 1)
  
  >Program Print
  $_descending
  
  >Program Print
  (int.add (int.add $_descending 3) (int.mul 5 2))
  
  >Program Print
  (int.add (int.add (int.add $_descending 3) (int.mul 5 2)) 1)
  
  Returned (int.add (int.add $_descending 3) (int.mul 5 2))
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/12.wl
  Execution mode: saf
  
  >Program Print
  (int.mul (int.add $_ok_computer 1) 2)
  
  Returned (int.add $_ok_computer 1)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/13.wl
  Execution mode: saf
  
  Returned true
  Returned false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/14.wl
  Execution mode: saf
  
  Returned (int.add 9 1)
  Returned (int.add 11 1)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/15.wl
  Execution mode: saf
  
  >Program Print
  $_x
  
  Returned (int.add (int.add (int.add (int.add 1 1) 1) 1) 1)
  Returned (int.add (int.add (int.add 1 1) 1) 1)
  Returned (int.add (int.add 1 1) 1)
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/16.wl
  Execution mode: saf
  
  >Program Print
  $_miguel
  $_rita
  $_XXXXXXXXXXXXXXXXXX
  
  >Program Print
  (int.add (int.add $_miguel 1) $_rita)
  $_rita
  $_XXXXXXXXXXXXXXXXXX
  
  >Program Print
  $_nvidia
  $_rita
  $_XXXXXXXXXXXXXXXXXX
  
  Returned (int.mul $_nvidia $_XXXXXXXXXXXXXXXXXX)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/17.wl
  Execution mode: saf
  
  Returned true
  Returned false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/18.wl
  Execution mode: saf
  
  >Program Print
  true
  
  >Program Print
  false
  
  Returned (int.add $_x 1)
  Returned (int.add $_x 1)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/2.wl
  Execution mode: saf
  
  >Program Print
  (int.mul 3 2)
  
  >Program Print
  false
  
  >Program Print
  (int.add 2 1)
  
  >Program Print
  2
  
  Returned -1
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/3.wl
  Execution mode: saf
  
  Assertion violated, counter example:
      Empty model
  Found 1 problems!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/4.wl
  Execution mode: saf
  
  >Program Print
  (int.add 5 1)
  
  >Program Print
  (int.add (int.add 5 1) 1)
  
  Returned (int.mul 3 3)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/5.wl
  Execution mode: saf
  
  >Program Print
  (int.mul (int.mul (int.mul (int.mul 1 1) (int.add 1 1)) (int.add (int.add 1 1) 1)) (int.add (int.add (int.add 1 1) 1) 1))
  
  Returned 12
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/6.wl
  Execution mode: saf
  
  Assertion violated, counter example:
      Empty model
  Found 1 problems!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/7.wl
  Execution mode: saf
  
  >Program Print
  true
  
  >Program Print
  1
  
  >Program Print
  0
  
  >Program Print
  1
  
  Returned 1
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/8.wl
  Execution mode: saf
  
  >Program Print
  true
  true
  
  >Program Print
  false
  true
  (int.add 3 2)
  
  >Program Print
  (int.mul 73 2)
  
  Returned 73
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/9.wl
  Execution mode: saf
  
  >Program Print
  (int.sub 5 6)
  
  Returned (int.sub 5 6)
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/common/array.wl
  Execution mode: saf
  
  >Program Print
  5
  
  Returned 0
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/factorial.wl
  Execution mode: saf
  
  Returned (int.mul (int.mul (int.mul (int.mul (int.mul 1 1) (int.add 1 1)) (int.add (int.add 1 1) 1)) (int.add (int.add (int.add 1 1) 1) 1)) (int.add (int.add (int.add (int.add 1 1) 1) 1) 1))
  Returned (int.mul (int.mul (int.mul (int.mul 1 1) (int.add 1 1)) (int.add (int.add 1 1) 1)) (int.add (int.add (int.add 1 1) 1) 1))
  Returned (int.mul (int.mul (int.mul 1 1) (int.add 1 1)) (int.add (int.add 1 1) 1))
  Returned (int.mul (int.mul 1 1) (int.add 1 1))
  Returned (int.mul 1 1)
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/simple1.wl
  Execution mode: saf
  
  Returned 0
  Assertion violated, counter example:
      $_i : Int 22
  Returned 0
  Assertion violated, counter example:
      $_i : Int -158
  Found 2 problems!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/statements/delete.wl
  Execution mode: saf
  
  >Program Print
  0
  
  >Program Print
  0
  
  >Program Print
  0
  
  >Program Print
  0
  
  >Program Print
  0
  
  >Program Print
  0
  
  >Program Print
  0
  
  >Program Print
  0
  
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/statements/symbol_int_c.wl
  Execution mode: saf
  
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/tree/1.wl
  Execution mode: saf
  
  Fatal error: exception Failure("Index out of bounds")
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/tree/2.wl
  Execution mode: saf
  
  Fatal error: exception Failure("Index out of bounds")
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/tree/3.wl
  Execution mode: saf
  
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 5
      $_j : Int 0
      $_k : Int 5
      $_v : Int 2
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 5
      $_j : Int 1
      $_k : Int 5
      $_v : Int 2
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 5
      $_j : Int 2
      $_k : Int 5
      $_v : Int 3
  Returned 0
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 6
      $_j : Int 0
      $_k : Int 6
      $_v : Int 2
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 6
      $_j : Int 1
      $_k : Int 6
      $_v : Int 2
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 6
      $_j : Int 2
      $_k : Int 6
      $_v : Int 3
  Returned 0
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 7
      $_j : Int 0
      $_k : Int 7
      $_v : Int 2
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 7
      $_j : Int 1
      $_k : Int 7
      $_v : Int 2
  Returned 0
  Returned 0
  Assertion violated, counter example:
      $_i : Int 7
      $_j : Int 2
      $_k : Int 7
      $_v : Int 3
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Assumption evaluated to false
  Found 9 problems!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/tree/4.wl
  Execution mode: saf
  
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
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
  Execution mode: saf
  
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Returned 0
  Assumption evaluated to false
  Assumption evaluated to false
  Everything Ok!
  
  =====================
  	Whilloc
  =====================
  
  Input file: basic/wasm.wl
  Execution mode: saf
  
  Returned 0
  Assertion violated, counter example:
      $_x : Int 1
      $_y : Int 4
  Returned 0
  Returned 0
  Found 1 problems!
  Total number of files tested: 33
