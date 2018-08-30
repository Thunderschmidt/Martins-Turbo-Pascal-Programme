program spirale;
uses crt, graph;
var a : word;

const kb = pi /180;

procedure grafik ;

var grDriver, grMode,ErrCode  : Integer;
begin
  grDriver := Detect;
  InitGraph(grDriver,grMode,'C:\DOSPRG\TP\BGI');
  ErrCode := GraphResult;
end;

procedure ausgabe;
var i : byte;
    Alpha : real;
    drehe: integer;
x,xo,y,yo,x2,xo2,y2,yo2  : real;
begin
x := 0;y := 0;xo := 0;yo := 0;
x2 := 0;y2 := 0;xo2 := 0;yo2 := 0;

drehe := trunc(cos(a*kb/2)*8000);

for i := 20 to 120 do begin
alpha := (drehe /i) *1.5* kb  ;
x :=cos(alpha)*5 + xo;
y :=sin(alpha)*5 + yo;
line(trunc(x+320),trunc(y+240),trunc(xo+320),trunc(yo+240));
x2 :=cos(alpha)*(-5) + xo2;
y2 :=sin(alpha)*(-5) + yo2;
line(trunc(x2+320),trunc(y2+240),trunc(xo2+320),trunc(yo2+240));
xo2 := x2;
yo2 := y2;
xo := x;
yo := y;
end;
end;

begin
grafik;
repeat
setcolor(black);
ausgabe;
a:=a+1;
setcolor(white);
ausgabe;
 until keypressed;
closegraph;
end.
