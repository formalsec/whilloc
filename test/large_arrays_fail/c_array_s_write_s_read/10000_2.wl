function main() {    

    i = symbol_int_c("i", i>=0 && i<5000);
    v = symbol_int_c("v", v>=5000 && v<10000);
    t = symbol_int_c("t", t>=2500 && t<7500);

    x = new(10000);

    x[i] = 42;
    x[v] = 24;
    x[t] = 100;

    j = symbol_int_c("j", j>=0 && j<2500);
    k = symbol_int_c("k", k>=2500 && k<5000);
    l = symbol_int_c("l", l>=5000 && l<7500);
    m = symbol_int_c("m", m>=7500 && m<100000);
    n = symbol_int_c("n", n>=2500 && n<7500);

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