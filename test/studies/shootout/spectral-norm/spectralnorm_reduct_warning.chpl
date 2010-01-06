use BlockDist;
config const N = 500 : int(64);

var Dist = distributionValue(new Block(rank=1, idxType=int(64), bbox=[0..#N]));
var Dom : domain(1, int(64)) distributed Dist = [0..#N];

var U : [Dom] real;
var vv = + reduce [(u,j) in (U,0..#N)] (u + u);
writeln(vv);
