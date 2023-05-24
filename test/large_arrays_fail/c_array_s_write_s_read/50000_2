function aenima() {    

    i = symbol_int_c("i", i>=0 && i<25000);
    v = symbol_int_c("v", v>=25000 && v<50000);
    t = symbol_int_c("t", t>=12500 && t<37500);

    x = new(50000);

    x[i] = 42;
    x[v] = 24;
    x[t] = 100;

    j = symbol_int_c("j", j>=0 && j<12500);
    k = symbol_int_c("k", k>=12500 && k<25000);
    l = symbol_int_c("l", l>=25000 && l<37500);
    m = symbol_int_c("m", m>=37500 && m<500000);
    n = symbol_int_c("n", n>=12500 && n<37500);

    a = x[j];
    b = x[k];
    c = x[l];
    d = x[m];
    e = x[n];

    assert(a == 42 || a == 0);
    assert(b == 42 || b == 100 || b == 0);
    assert(c == 24 || c == 100 || c == 0);
    assert(d == 24 || d == 0);
    assert(e == 24 || e == 100 || e == 42 || e == 0);

    return x
}