function main() {    

    x = new(50000);

    x[5000] = 42;
    x[15000] = 24;
    x[35000] = 100;

    j = symbol_int_c("j", j>=0 && j<12500);
    k = symbol_int_c("k", k>=12500 && k<25000);
    l = symbol_int_c("l", l>=25000 && l<37500);
    m = symbol_int_c("m", m>=37500 && m<50000);
    n = symbol_int_c("n", n>=12500 && n<37500);
    o = symbol_int_c("o", o>=2500  && o<37500);

    a = x[j];
    b = x[k];
    c = x[l];
    d = x[m];
    e = x[n];
    f = x[o];
    
    assert(a == 42 || a == 0);
    assert(b == 24 || b == 0);
    assert(c == 100 || c == 0);
    assert(d == 0);
    assert(e == 24 || e == 100 || e == 0);
    assert(f == 24 || f == 100 || f == 42 || f == 0);
    return x
}