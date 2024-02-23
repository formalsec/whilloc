function aenima() {    

    i = symbol_int_c("i", i>=0 && i<25000);
    t = symbol_int_c("t", t>=25000 && t<37500);

    s = symbol_int_c("s", s>=50000);

    x = new(s);

    x[i] = 42;
    x[t] = 100;

    j = symbol_int_c("j", j>=0 && j<25000);
    k = symbol_int_c("k", k>=0 && k<37500);
    l = symbol_int_c("l", l>=25000 && l<37500);
    m = symbol_int_c("m", m>=37500 && m<50010);

    a = x[j];
    b = x[k];
    c = x[l];
    d = x[m];

    assert(a == 42  || a == 0);
    assert(b == 42  || b == 100 || b == 0);
    assert(c == 100 || c == 0);
    assert(d == 0);

    return x
}