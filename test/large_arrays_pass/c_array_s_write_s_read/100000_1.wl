function main() {    

    i = symbol_int_c("i", i>=0 && i<50000);
    t = symbol_int_c("t", t>=25000 && t<75000);

    x = new(100000);

    x[i] = 42;
    x[t] = 100;

    j = symbol_int_c("j", j>=0 && j<25000);
    k = symbol_int_c("k", k>=25000 && k<50000);
    l = symbol_int_c("l", l>=25000 && l<75000);
    m = symbol_int_c("m", m>=50000 && m<100000);
    n = symbol_int_c("n", n>=75000 && n<100000);

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