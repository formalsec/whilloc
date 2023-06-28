function aenima() {
  x = symbol_int("i");

  if (x > 10) {
    y = x + 20 
  } else {
    y = x + 200
  }; 
  assert (y != 42);
  return 0
}
