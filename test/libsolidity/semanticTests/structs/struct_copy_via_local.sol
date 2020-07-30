contract c {
    struct Struct {
        uint256 a;
        uint256 b;
    }
    Struct data1;
    Struct data2;

    function test() public returns (bool) {
        data1.a = 1;
        data1.b = 2;
        Struct memory x = data1;
        data2 = x;
        return data2.a == data1.a && data2.b == data1.b;
    }
}

// ====
// compileViaYul: also
// ----
// test() -> true
