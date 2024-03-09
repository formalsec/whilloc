function main() {    

    i = symbol_int_c("i", i>=0 && i<50000);
    v = symbol_int_c("v", v>=50000 && v<100000);
    t = symbol_int_c("t", t>=25000 && t<75000);

    s = symbol_int_c("s", s>=100000);

    x = new(s);

    x[i] = 42;
    x[v] = 24;
    x[t] = 100;

    j = symbol_int_c("j", j>=0 && j<25000);
    k = symbol_int_c("k", k>=-25000 && k<50000);
    l = symbol_int_c("l", l>=50000 && l<75000);
    m = symbol_int_c("m", m>=75000 && m<100000);
    n = symbol_int_c("n", n>=25000 && n<75000);

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