function max(x,y) {
    if (x>y) {
        return x
    }
    else {
        return y
    }
};

function min(x,y) {
    if (x<y) {
        return x
    }
    else {
        return y
    }
};

function multiply(x,y) {
    return x*y
};

function factorial(x) {
    y = 1;
    res = 1;
    while (y<=x) {
        res = res*y;
        y = y+1
    };
    return res
};

function C(n,k) {
    fact        = factorial(n);
    order       = factorial(k);
    overcount   = factorial(n-k);
    return fact / (order * overcount)
};

function aenima() {

    a = 3;
    b = factorial(3);
    print(b);

    c = C(b+2,a*2);
    print(c);

    d = min(c,5);
    e = max(4,d);
    print(d);
    print(e);
    print(d+e);

    f = 3;
    f2 = multiply(f,f);
    print(f2);

    n=4;
    x=1;
    y=1;
    while (x<=n) {
        while (y<=n) {
            print(x,y);
            y=y+1
        };
        x=x+1;
        y=1
    };

    if ( (f*f) == f2) {
        g = true
    }
    else {
        g = false
    };

    if (g) {
        return 0
    }
    else {
        return -1
    }
}