function aenima() {
    a = 4;
    b = 2;
    x = symbol_int("x");
    y = symbol_int("y");
    if (x > 0) {
        b = a + 2;
        if (x < y) {
            a = (x * 2) + y
        }
        else {
            skip
        }
    }
    else {
        skip
    };
    assert(!(a == b));
    return 0
}
