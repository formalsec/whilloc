function aenima() {    

    i = symbol_int_c("i", i>=0 && i<25000);
    v = symbol_int_c("v", v>=25000 && v<501000);
    t = symbol_int_c("t", t>=12500 && t<37500);

    s = symbol_int_c("s", s>=50000);

    x = new(s);

    x[i] = 42;
    x[v] = 24;
    x[t] = 100;

    a = x[5000];
    b = x[15000];
    c = x[35000];
    d = x[45000];

    assert(a == 42 || a == 0);
    assert(b == 42 || b == 100 || b == 0);
    assert(c == 24 || c == 100 || c == 0);
    assert(d == 24 || d == 0);

    return x
}