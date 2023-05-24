function aenima() {    

    i = symbol_int_c("i", i>=0 && i<5000);
    v = symbol_int_c("v", v>=5000 && v<10000);
    t = symbol_int_c("t", t>=2500 && t<17500);

    x = new(10000);

    x[i] = 42;
    x[v] = 24;
    x[t] = 100;

    a = x[1000];
    b = x[3000];
    c = x[7000];
    d = x[9000];

    assert(a == 42 || a == 0);
    assert(b == 42 || b == 100 || b == 0);
    assert(c == 24 || c == 100 || c == 0);
    assert(d == 24 || d == 0);

    return x
}