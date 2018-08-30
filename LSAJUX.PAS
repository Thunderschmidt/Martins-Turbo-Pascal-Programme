uses crt, graph;

var
  x        : real;
  a        : real;
  b        : real;
  d        : byte;
  grDriver : Integer;
  grMode   : Integer;
  ErrCode  : Integer;
  c        : word;
const kb = pi/180;
begin
  clrscr;
  grDriver := Detect;
  InitGraph(grDriver,grMode,'C:\DOSPRG\TP\BGI');
  ErrCode := GraphResult;
  randomize;

  x := 0;
  for d:= 1 to 50
   do
begin
  x := 0;
  a:=random(20);
  b:=random(20);
  setcolor(trunc(random(15))+1);

  while  x < 360.01 do
  begin
  x := x+0.5;
  line (trunc(cos(a*x*kb)*320)+320, trunc(sin(b*x*kb)*240)+240,
  trunc(cos(a*((x+0.5)*kb))*320)+320, trunc(sin(b*((x+0.5)*kb))*240)+240);
  end;

  x := 0;

  setcolor(0);

  while x < 360.01 do
  begin
  x := x+0.5;
  line (trunc(cos(a*x*kb)*320)+320, trunc(sin(b*x*kb)*240)+240,
  trunc(cos(a*((x+0.5)*kb))*320)+320, trunc(sin(b*((x+0.5)*kb))*240)+240);

  end;

  end;
  closegraph;
  end.