function main() {
    x = symbol_int("x");
    assume(x>=1);
    assume(x<=3);
    y=1;
    print(x);
    while (x<=4) {
        x=x+1;
        y=y+1
    };
    return y
}