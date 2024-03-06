function main() {    

    s = symbol_int_c("s", s>=10000);

    x = new(s);

    x[1000] = 42;
    x[3000] = 24;
    x[17000] = 100;

    a = x[1000];
    b = x[3000];
    c = x[7000];
    d = x[9000];

    assert(a == 42);
    assert(b == 24);
    assert(c == 100);
    assert(d == 0);

    return x
}