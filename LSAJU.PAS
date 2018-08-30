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
  for d:= 1 to 30 do
begin
  x := 0;
  a:=random(20);
  b:=random(20);
  setcolor(trunc(random(15))+1);

  while  x < 360.01 do
  begin
  x := x+1;
  {putpixel (trunc(sin(x-0.01)*150)+320, trunc(cos(x-0.01)*150)+240, black);}
  line (trunc(cos(a*x*kb)*320)+320, trunc(sin(b*x*kb)*240)+240,
  trunc(cos(a*(x*kb+1))*320)+320, trunc(sin(b*(x*kb+1))*240)+240);
  {for c := 1 to 6000 do begin end;}
  end;

  x := 0;

  setcolor(0);

  while x < 360.01 do
  begin
  x := x+1;
    line (trunc(cos(a*x*kb)*320)+320, trunc(sin(b*x*kb)*240)+240,
  trunc(cos(a*(x*kb+1))*320)+320, trunc(sin(b*(x*kb+1))*240)+240);

  end;

  end;
  closegraph;
  end.