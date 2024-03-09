function main() {    

    s = symbol_int_c("s", s>=50000);

    x = new(s);

    x[5000] = 42;
    x[15000] = 24;
    x[35000] = 100;

    a = x[5000];
    b = x[15000];
    c = x[35000];
    d = x[45000];

    assert(a == 42);
    assert(b == 24);
    assert(c == 100);
    assert(d == 0);

    return x
}