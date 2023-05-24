function aenima() {    

    i = symbol_int_c("i", i>=0 && i<25000);
    t = symbol_int_c("t", t>=12500 && t<37500);

    s = symbol_int_c("s", s>=50000);

    x = new(s);

    x[i] = 42;
    x[t] = 100;

    j = symbol_int_c("j", j>=0 && j<12500);
    k = symbol_int_c("k", k>=12500 && k<25000);
    l = symbol_int_c("l", l>=12500 && l<37500);
    m = symbol_int_c("m", m>=25000 && m<50000);
    n = symbol_int_c("n", n>=37500 && n<50000);

    a = x[j];
    b = x[k];
    c = x[l];
    d = x[m];
    e = x[n];

    assert(a == 42  || a == 0);
    assert(b == 42  || b == 100 || b == 0);
    assert(c == 42  || c == 100 || c == 0);
    assert(d == 100 || d == 0);
    assert(e == 0);

    return x
}