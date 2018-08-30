

uses graph,crt;
type Polytype = record X, Y : integer; end;
const Poly
 : array[1..3] of PolyType =
 ((x:  50; y: 100),
  (x: 100; y: 100),
  (x: 150; y: 150));

procedure InitGr;
var  grDriver : Integer;
  grMode   : Integer;
begin
  grDriver := Detect;
  InitGraph(grDriver,grMode,'');
end;

begin
randomize;
Initgr;
repeat
  SetFillStyle(random(12),   random(16));
fillpoly(3,poly);
until keypressed;
readln;
end.

