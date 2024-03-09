function main() {    

    i = symbol_int_c("i", i>=0 && i<5000);
    t = symbol_int_c("t", t>=2500 && t<7500);

    s = symbol_int_c("s", s>=10000);

    x = new(s);

    x[i] = 42;
    x[t] = 100;

    a = x[1000];
    b = x[3000];
    c = x[7000];
    d = x[9000];

    assert(a == 42 || a == 0);
    assert(b == 42 || b == 100 || b == 0);
    assert(c == 100 || c == 0);
    assert(d == 0);

    return x
}