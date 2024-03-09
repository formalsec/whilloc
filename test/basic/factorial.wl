function factorial(n) {
    aux = 1;
    res = 1;
    while (aux<=n) {
        res = res*aux;
        aux = aux+1
    };
    return res
};

function main() {
    x = symbol_int("x");
    assume(x>=1);
    assume(x<=5);
    f = factorial(x);
    assert(f<121);
    return f
}
