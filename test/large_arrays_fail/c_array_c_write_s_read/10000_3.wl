function main() {    

    x = new(10000);

    x[1000] = 42;
    x[3000] = 24;
    x[7000] = 100;

    j = symbol_int_c("j", j>=0 && j<2500);
    k = symbol_int_c("k", k>=2500 && k<5000);
    l = symbol_int_c("l", l>=5000 && l<7500);
    m = symbol_int_c("m", m>=7500 && m<11000);
    n = symbol_int_c("n", n>=2500 && n<7500);
    o = symbol_int_c("o", o>=500  && o<7500);
    p = symbol_int_c("p", p>=500  && p<3500);


    a = x[j];
    b = x[k];
    c = x[l];
    d = x[m];
    e = x[n];
    f = x[o];
    g = x[p];

    assert(a == 42 || a == 0);
    assert(b == 24 || b == 0);
    assert(c == 100 || c == 0);
    assert(d == 0);
    assert(e == 24 || e == 100 || e == 0);
    assert(f == 24 || f == 100 || f == 42 || f == 0);
    assert(g == 24 || g == 42  || g == 0);
    return x
}