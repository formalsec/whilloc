function main() {    

    s = symbol_int_c("s", s>=100000);

    x = new(s);

    x[10000] = 42;
    x[30000] = 24;
    x[70000] = 100;

    j = symbol_int_c("j", j>=0 && j<25000);
    k = symbol_int_c("k", k>=25000 && k<50000);
    l = symbol_int_c("l", l>=50000 && l<75000);
    m = symbol_int_c("m", m>=75000 && m<100000);
    n = symbol_int_c("n", n>=25000 && n<75000);
    o = symbol_int_c("o", o>=5000  && o<75000);

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