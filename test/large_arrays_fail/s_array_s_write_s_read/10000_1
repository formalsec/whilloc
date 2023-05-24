function aenima() {    

    i = symbol_int_c("i", i>=0 && i<5000);
    t = symbol_int_c("t", t>=2500 && t<7500);

    s = symbol_int_c("s", s>=10000);

    x = new(s);

    x[i] = 42;
    x[t] = 100;

    j = symbol_int_c("j", j>=0 && j<2500);
    k = symbol_int_c("k", k>=2500 && k<5000);
    l = symbol_int_c("l", l>=2500 && l<7500);
    m = symbol_int_c("m", m>=5000 && m<10000);
    n = symbol_int_c("n", n>=7500 && n<10001);

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