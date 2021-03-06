class C {
  iter foo(n: int) {
    for i in 1..n do
      yield i;
    for i in 1..n by -1 do
      yield i;
  }
}

class D: C {
  iter foo(n: int) {
    for i in 1..n do
      yield i;
  }
}

var c = new C();

for i in c.foo(4) do
  writeln(i);
writeln();

delete c;

c = new D();

for i in c.foo(4) do
  writeln(i);
writeln();

delete c;
