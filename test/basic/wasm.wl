function aenima() {
    a = 4;
    b = 2;
    x = symbol("x");
    y = symbol("y");
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
