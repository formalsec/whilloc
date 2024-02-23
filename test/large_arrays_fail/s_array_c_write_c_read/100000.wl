function aenima() {    

    s = symbol_int_c("s", s>=100000);

    x = new(s);

    x[10000] = 42;
    x[30000] = 24;
    x[170000] = 100;

    a = x[10000];
    b = x[30000];
    c = x[70000];
    d = x[90000];

    assert(a == 42);
    assert(b == 24);
    assert(c == 100);
    assert(d == 0);

    return x
}