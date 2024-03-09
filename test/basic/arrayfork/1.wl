function main() {    

    i = symbol_int("i");


    assume(i>=0);
    assume(i<4);

    x = new(4);

    x[i] = 42;
    y = x[3];

    assert(y != 42);


    return x
}