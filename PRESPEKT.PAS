
program Perspektive;

uses Graph, Crt;

var x        : array[0..8, 1..2] of integer;
    y        : array[0..8, 1..2] of integer;
    z        : array[0..8,1..2] of integer;
    a        : byte;
    b        : real;
    ze       : real;
    zo       : real;
    c        : longint;
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
  setbkcolor(0);
  x[1,1]:=-1; y[1,1]:=-1; z[1,1]:=-1;  x[1,2]:=-1; y[1,2]:=1; z[1,2]:=-1;
  x[2,1]:=1; y[2,1]:=-1; z[2,1]:=-1;  x[2,2]:=1; y[2,2]:=1; z[2,2]:=-1;
  x[3,1]:=-1; y[3,1]:=-1; z[3,1]:=-1;  x[3,2]:=1; y[3,2]:=-1; z[3,2]:=-1;
  x[4,1]:=-1; y[4,1]:=1; z[4,1]:=-1;  x[4,2]:=1; y[4,2]:=1; z[4,2]:=-1;
  x[5,1]:=-1; y[5,1]:=-1; z[5,1]:=-1;  x[5,2]:=0; y[5,2]:=0; z[5,2]:=1;
  x[6,1]:=-1; y[6,1]:=1; z[6,1]:=-1;  x[6,2]:=0; y[6,2]:=0; z[6,2]:=1;
  x[7,1]:=1; y[7,1]:=-1; z[7,1]:=-1;  x[7,2]:=0; y[7,2]:=0; z[7,2]:=1;
  x[8,1]:=1; y[8,1]:=1; z[8,1]:=-1;  x[8,2]:=0; y[8,2]:=0; z[8,2]:=1;


    repeat

  b:=b + 0.01;

  for a:= 1 to 8 do

begin
ze:=1/(cos(b-0.02)*x[a,1]-sin(b-0.02)*z[a,1]+e);
zo:=1/(cos(b-0.02)*x[a,2]-sin(b-0.02)*z[a,2]+e);


 setcolor(0);
  line(trunc((sin(b-0.02)*x[a,1]*m+cos(b-0.02)*z[a,1]*m)*ze+320), trunc(y[a,1]*m*ze)+240,
       trunc((sin(b-0.02)*x[a,2]*m+cos(b-0.02)*z[a,2]*m)*zo+320), trunc(y[a,2]*m*zo)+240);

ze:=1/(cos(b)*x[a,1]-sin(b)*z[a,1]+e);
zo:=1/(cos(b)*x[a,2]-sin(b)*z[a,2]+e);

 setcolor(1);
  line(trunc((sin(b)*x[a,1]*m+cos(b)*z[a,1]*m)*ze+320), trunc(y[a,1]*m*ze)+240,
       trunc((sin(b)*x[a,2]*m+cos(b)*z[a,2]*m)*zo+320), trunc(y[a,2]*m*zo)+240);

  end;

  for c := 1 to 2000 do begin end;
  until keypressed;
end.
