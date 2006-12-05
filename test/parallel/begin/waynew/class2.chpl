// Test a begin block with a reference to a local class variable

class C {
  var x: int;
}

def jam() {
  var c = C();
  c.x = 7;
  writeln( c);

  begin {
    c.x = 14;
    writeln( c);
  }
}

jam();
