function main() {    

    i = symbol_int_c("i", i>=0 && i<50000);
    t = symbol_int_c("t", t>=50000 && t<75000);

    s = symbol_int_c("s", s>=100000);

    x = new(s);

    x[i] = 42;
    x[t] = 100;

    a = x[10000];
    b = x[30000];
    c = x[70000];
    d = x[90000];

    assert(a == 42  || a == 0);
    assert(b == 42  || b == 0);
    assert(c == 100 || c == 0);
    assert(d == 0);

    return x
}