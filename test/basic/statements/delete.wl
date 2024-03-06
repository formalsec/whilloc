function main() {    

    i = symbol_int("i");

    assume(i>=0);
    assume(i<4);

    x = new(4);

    x[i] = 42;
    print(x);

    delete x;
    print(x);

    return x
}