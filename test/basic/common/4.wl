function multiply(x,y) {
    return x*y
};

function increment_twice(x) {
    x = increment(x);
    y = x;
    print(y);
    x = increment(x);
    return x
};

function increment(x) {
    return x+1
};

function main() {
    x = increment_twice(5);
    print(x);
    f2 = multiply(3,3);
    return f2
}