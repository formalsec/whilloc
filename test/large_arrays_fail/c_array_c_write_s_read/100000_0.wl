function aenima() {    

    x = new(100000);

    x[10000] = 42;
    x[30000] = 24;
    x[70000] = 100;

    j = symbol_int_c("j", j>=0 && j<25000);
    k = symbol_int_c("k", k>=25000 && k<50000);
    l = symbol_int_c("l", l>=50000 && l<75000);
    m = symbol_int_c("m", m>=75000 && m<100001);

    a = x[j];
    b = x[k];
    c = x[l];
    d = x[m];

    assert(a == 42 || a == 0);
    assert(b == 24 || b == 0);
    assert(c == 100 || c == 0);
    assert(d == 0);

    return x
}