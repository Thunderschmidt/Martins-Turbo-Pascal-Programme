
program Perspektive;

uses Graph, Crt;

var x        : array[0..8, 1..2] of integer;
    y        : array[0..8, 1..2] of integer;
    z        : array[0..8,1..2] of integer;
    a        : byte;
    f        : byte;
    b        : real;
    ze       : real;
    zo       : real;
    g        : integer;
    d        : integer;
    c        : longint;
    xs       : array[1..200] of integer;
    ys       : array[1..200] of integer;
     grDriver : Integer;
    grMode   : Integer;
    ErrCode  : Integer;

const e=12;
const m=600;

begin

  grDriver := Detect;
  InitGraph(grDriver,grMode,'');
  ErrCode := GraphResult;
  if ErrCode = grOk then
  d:=0;
    randomize;

  for a := 1 to 200 do
begin
  xs[a]:=random(640);
  ys[a]:=random(480);
end;

  setbkcolor(0);

  x[1,1]:=-1; y[1,1]:=-1; z[1,1]:=-1;  x[1,2]:=-1; y[1,2]:=1; z[1,2]:=-1;
  x[2,1]:=1; y[2,1]:=-1; z[2,1]:=-1;  x[2,2]:=1; y[2,2]:=1; z[2,2]:=-1;
  x[3,1]:=-1; y[3,1]:=-1; z[3,1]:=-1;  x[3,2]:=1; y[3,2]:=-1; z[3,2]:=-1;
  x[4,1]:=-1; y[4,1]:=1; z[4,1]:=-1;  x[4,2]:=1; y[4,2]:=1; z[4,2]:=-1;
  x[5,1]:=-1; y[5,1]:=-1; z[5,1]:=-1;  x[5,2]:=0; y[5,2]:=0; z[5,2]:=2;
  x[6,1]:=-1; y[6,1]:=1; z[6,1]:=-1;  x[6,2]:=0; y[6,2]:=0; z[6,2]:=2;
  x[7,1]:=1; y[7,1]:=-1; z[7,1]:=-1;  x[7,2]:=0; y[7,2]:=0; z[7,2]:=2;
  x[8,1]:=1; y[8,1]:=1; z[8,1]:=-1;  x[8,2]:=0; y[8,2]:=0; z[8,2]:=2;

  g:=-70;
    repeat
  if b=360 then b:=0;
  b:=b + 0.04;
  if d=640 then d:=0;
  d:=d+1;
  if g=740 then g:=-90;
   g:=g+2;

  for f := 1 to 200 do
begin

  putpixel(xs[f]+d-1, ys[f], black);
  putpixel(xs[f]+d, ys[f], white);
  putpixel(xs[f]+d-1-640, ys[f], black);
  putpixel(xs[f]+d-640, ys[f], white);

end;


  for a:= 1 to 8 do
begin
ze:=1/(cos(b-0.04)*x[a,1]-sin(b-0.04)*z[a,1]+e);
zo:=1/(cos(b-0.04)*x[a,2]-sin(b-0.04)*z[a,2]+e);


 setcolor(0);

  line(trunc((sin(b-0.04)*x[a,1]*m+cos(b-0.04)*z[a,1]*m)*ze+g), trunc(y[a,1]*m*ze)+240,
       trunc((sin(b-0.04)*x[a,2]*m+cos(b-0.04)*z[a,2]*m)*zo+g), trunc(y[a,2]*m*zo)+240);

ze:=1/(cos(b)*x[a,1]-sin(b)*z[a,1]+e);
zo:=1/(cos(b)*x[a,2]-sin(b)*z[a,2]+e);

 setcolor(1);
  line(trunc((sin(b)*x[a,1]*m+cos(b)*z[a,1]*m)*ze+g+2), trunc(y[a,1]*m*ze)+240,
      trunc((sin(b)*x[a,2]*m+cos(b)*z[a,2]*m)*zo+g+2), trunc(y[a,2]*m*zo)+240);
end;
  {for c := 1 to 2000 do begin end;}
  until keypressed;
end.



  randomize;
  for a := 1 to 200 do
begin
  x[a]:=random(640);
  y[a]:=random(480);
end;
repeat
if b=640 then b:=0;
b:=b+1;
  for a := 1 to 200 do
begin

  putpixel(x[a]+b-1, y[a], black);
  putpixel(x[a]+b, y[a], white);
  putpixel(x[a]+b-1-640, y[a], black);
  putpixel(x[a]+b-640, y[a], white);

end;
until keypressed;
closegraph;
end.
