function fibonacci (n) {
    if (n<1) {
        return 0
    }
    else {
        if (n==1) {
            return 1
        }
        else {
            two = 2;
            one = 1;
            x = fibonacci(n-two);
            y = fibonacci(n-one);
            return x+y
        }
    }
};
/* 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144. */
function aenima() {
    n = symbol("n");
    result = fibonacci(n);
    print(result);
    if (n<8 || result>=34) {
        return 0
    }
    else { /* n>=8 && result<34: there exists n>=8 such that F_n<34 (F_7=13, F_8=21, F_9=34) */
        assert(false)
    };
    return true
}