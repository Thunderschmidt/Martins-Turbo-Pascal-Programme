
uses crt, graph;
type Startype=array[1..150] of record x,y: integer;ebene:byte;end;
var
    x, y, z                  : array[ 1..2,1..12] of shortint;
    no, e,b    :                        byte;          {Index}
    sterne : Startype;


procedure datlese;
var                    
     er : integer;                         {er: Anzahl Vektoren}
      t  : text;
       a  : string;
       s,n,l: byte;
const c  : array[1..1]of char=('e');

begin
b := 0; no := 0;
for e :=1 to 1 do begin
assign(t, 'c:\tp\'+c[e]+'.rot');      {liest Daten aus c:\TP (*.rot)}
reset(t);
 readln(t, a);
val(a, n, er);
readln(t, a);
val(a, l, er);
 readln(t, a);
repeat
b := b + 1;
writeln(b,' ',c[e]);
 readln(t, a);
val(a,s, er);x[1,b]:=s+no;
 readln(t, a);
val(a,y[1,b], er);
 readln(t, a);
val(a,s, er);x[2,b]:=s+no;
 readln(t, a);
val(a,y[2,b], er);
 readln(t, a);
until eof(t);
close(t);
no:=no+n+2;                    { Abstand von Buchstaben}
end;
end;

procedure graf;
var grDriver , grMode :       Integer;    {InitGraph (640*480*16)}
begin
    grDriver := Detect;
  InitGraph(grDriver,grMode,'c:\tp');
end;

procedure editXYZ;                    {Zerrung, Richtung}
begin;
for e := 1 to b do begin
x[1, e]:=x[1, e]-no div 2;            
x[2, e]:=x[2, e]-no div 2;
y[1, e]:=(y[1, e]-3)*1;
y[2, e]:=(y[2, e]-3)*1 ;
end;
end;

procedure starfield;                    {generiert Sternenhintergrund}
begin
randomize;
for e:=1 to 150 do begin
with sterne[e] do begin
x:=random(640);
y:=random(480);
ebene:=random(3)+1;
end;
end
end;

Procedure Pixel;                       { Sternenscroller}
var farbe: byte;
begin
for e:= 1 to 150 do
with sterne[e] do begin
putpixel(x, y, black);
x := x + ebene;
if ebene = 3 then farbe := 15;
if ebene = 2 then farbe := 7;
if ebene = 1 then farbe := 8;
if x >= 640 then begin
x := 0;
y := random(480);
ebene:=random(3)+1;
end;
putpixel(x, y, farbe);
end;
end;





procedure rotate;                      {Rotationsprogramm, Berechnungen}
    var
    rot, rot2, rot3,
    zp1, zp2,srot,crot,srot2,crot2,srot3,crot3:                     real;
    poly : array[1..2] of array[1..12] of Pointtype;
const
                r  = 0.015;
                 r2 = 0.021;
                  r3 = 0.01;         {Rotationsgeschwindigkeiten}
                   g  = 450 ;         {g=Vergr”áerung}
                    di = 38;           {di=Distanz des Objektes}
                     f  = 1.5;          {Auge-Monitor}
                      xv = 320;
                       yv = 240;          {xv, yv : Verschiebung}
begin
  SetFillStyle(1,15);
rot:=0;rot2:=0;rot3:=0;
repeat

rot:= rot+r; rot2:= rot2+r2; rot3 := rot3+r3;
 Srot:=Sin(rot); Crot:=Cos(rot);
  Srot2:=Sin(rot2); Crot2:=Cos(rot2);
   Srot3:=Sin(rot3); Crot3:=Cos(rot3);     {Sin & Cos-Berechnungen}

for e := 1 to b do begin
  zp1 := Srot*x[1, e]-Crot*Crot2*y[1, e]+di;
poly[1,e].x := trunc((f/zp1)*(Crot3*(Crot*x[1,e]+Srot*(Srot2*y[1,e]))-Srot3*(Crot2*y[1,e]))*g)+xv;
poly[1,e].y := yv-trunc((f/zp1)*(Crot3*((Crot2*y[1,e]))+Srot3*(Crot*x[1,e]+Srot*(Srot2*y[1,e])))*g);
end;
  SetFillStyle(1,16);setcolor(16);
fillpoly(12,poly[2]);
  SetFillStyle(1,10);setcolor(5);fillpoly(12,poly[1]);
poly[2]:=poly[1];
for no := 0 to 255 do for e:= 0 to 255 do begin end;
until keypressed;
end;



begin                                      {Main}
datlese;
starfield;
graf;
editXYZ;
rotate;
closegraph;
end.
  SetFillStyle(random(12),   random(16));
fillpoly(3,poly);
