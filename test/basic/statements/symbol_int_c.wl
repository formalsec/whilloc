function aenima() {    

    x = new(10000);

    x[1000] = 42;
    x[3000] = 24;
    x[7000] = 100;

    j = symbol_int_c("j", j>=0 && j<2500);

    a = x[j];

    assert(a == 42 || a == 0);

    return x
}