function main() {    

    s = symbol_int_c("s", s>=10000);

    x = new(s);

    x[1000] = 42;
    x[3000] = 24;
    x[7000] = 100;

    j = symbol_int_c("j", j>=0 && j<2500);
    k = symbol_int_c("k", k>=2500 && k<5000);
    l = symbol_int_c("l", l>=5000 && l<7500);
    m = symbol_int_c("m", m>=7500 && m<10000);
    n = symbol_int_c("n", n>=2500 && n<7500);

    a = x[j];
    b = x[k];
    c = x[l];
    d = x[m];
    e = x[n];

    assert(a == 42 || a == 0);
    assert(b == 24 || b == 0);
    assert(c == 100 || c == 0);
    assert(d == 0);
    assert(e == 24 || e == 100 || e == 0);

    return x
}