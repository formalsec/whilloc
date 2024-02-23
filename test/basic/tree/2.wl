function aenima() {    

    i = symbol_int("i");
    v = symbol_int("v");

    assume(i>=0);
    assume(i<2);

    x = new(8);

    x[i] = 42;
    y = x[v];

    assert(y == 0 || y == 42);

    delete x;
    return x
}