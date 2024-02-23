function aenima() {    

    i = symbol_int("i");
    v = symbol_int("v");

    assume(i>=0);
    assume(i<4);

    assume(v>=0);
    assume(v<4);

    x = new(4);

    x[i] = 42;
    y = x[v];

    assert(y != 42);

    delete x;
    return x
}