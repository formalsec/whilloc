function aenima() {    

    i = symbol_int_c("i", i>=0 && i<50000);
    t = symbol_int_c("t", t>=50000 && t<75000);

    x = new(100000);

    x[i] = 42;
    x[t] = 100;

    j = symbol_int_c("j", j>=0 && j<50000);
    k = symbol_int_c("k", k>=0 && k<75000);
    l = symbol_int_c("l", l>=50000 && l<75000);
    m = symbol_int_c("m", m>=75000 && m<1000000);

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