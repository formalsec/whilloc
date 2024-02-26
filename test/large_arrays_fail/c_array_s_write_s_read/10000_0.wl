function aenima() {    

    i = symbol_int_c("i", i>=0 && i<5000);
    t = symbol_int_c("t", t>=5000 && t<7500);

    x = new(10000);

    x[i] = 42;
    x[t] = 100;

    j = symbol_int_c("j", j>=0 && j<5000);
    k = symbol_int_c("k", k>=0 && k<7500);
    l = symbol_int_c("l", l>=5000 && l<7500);
    m = symbol_int_c("m", m>=7500 && m<100000);

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