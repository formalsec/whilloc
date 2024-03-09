function main() {    

    i = symbol_int("i");
    j = symbol_int("j");

    assume(i>=0);
    assume(i<6);

    assume(j>=2);
    assume(j<8);


    x = new(8);


    x[i] = 42;
    x[j] = 24;
    
    a = x[0];
    b = x[3];
    c = x[7];
    
    assert(a == 0 || a == 42);
    assert(b == 0 || b == 24 || b == 42);
    assert(c == 0 || c == 24);


    return x
}