
uses crt, graph;
type Startype=array[1..128] of record x,y,z: integer;end;
var
    sterne : Startype;
    x, y, z                  : array[ 1..2,0..80] of shortint;
    no, e,b    :                        byte;          {Index}
const
                r  = 0.02;
                 r2 = 0.015;
                  r3 = 0.01;         {Rotationsgeschwindigkeiten}
                   g  = 450 ;         {g=Vergr”áerung}
                    dis = 110;
                     f  = 1.5;          {Auge-Monitor}
                       yv = 240;          {xv, yv : Verschiebung}
                        dep = 70;


procedure datlese;
var                    
     er : integer;                         {er: Anzahl Vektoren}
      t  : text;
       a  : string;
       s,n,l: byte;
const c  : array[1..8]of char=('d','e','m','o','l','i','n','e');

begin
b := 0; no := 0;
for e :=1 to 8 do begin
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
closegraph;
    grDriver := Detect;
  InitGraph(grDriver,grMode,'');
end;

procedure editXYZ;                    {Zerrung, Richtung}
begin;
for e := 1 to b do begin
x[1, e]:=(x[1, e]-no div 2);
x[2, e]:=(x[2, e]-no div 2);
y[1, e]:=(y[1, e]-3)*1;
y[2, e]:=(y[2, e]-3)*1 ;
end;
end;

procedure starfield;                    {generiert Sternenhintergrund}

begin
randomize;
for e:=1 to 128 do begin
with sterne[e] do begin
z:=random(380)+20;
x := random(2400)-1200;
y := random(1700)-950;
end;
end
end;

Procedure Pixel;                       { Sternenscroller}
var farbe: byte;
    zet: real;
begin
for e:= 1 to 128 do
with sterne[e] do begin
zet:=50 / z;
putpixel(trunc(zet*x)+320,240-trunc(zet*y), black);
z := z - 2;
if z < 30 then     begin
z := 400;
x := random(4800)-2400;
y := random(3400)-1700;
end;
if z  > 300 then farbe := 8 else farbe := 7;
if z  < 150 then farbe := 15;
zet:=50 / z;
putpixel(trunc(zet*x)+320,240-trunc(zet*y), farbe);
end;
end;





procedure rotate;                      {Rotationsprogramm, Berechnungen}
    var

    rot, rot2, rot3, di,
    zp1, zp2,srot,crot,srot2,crot2,srot3,crot3:                     real;
    xp1, xp2, yp1, yp2 : array[1..80] of    Integer;
xv : integer;
begin
rot:=0;rot2:=0;rot3:=0;
repeat

Pixel;

rot:= rot+r; rot2:= rot2+r2; rot3 := rot3+r3;
 Srot:=Sin(rot); Crot:=Cos(rot);
  Srot2:=Sin(rot2); Crot2:=Cos(rot2);
   Srot3:=Sin(rot3); Crot3:=Cos(rot3);     {Sin & Cos-Berechnungen}
    di := sin(rot2 *0.82)*dep+dis;
    xv := trunc(cos(rot2 *0.8)*70)+320;

for e := 1 to b do begin

setcolor(0); LINE (xp1[e],yp1[e],xp2[e],yp2[e]);   {L”schen}

  zp1 := Srot*x[1, e]-Crot*Crot2*y[1, e]+di;
 xp1[e] := trunc((f/zp1)*(Crot3*(Crot*x[1,e]+Srot*(Srot2*y[1,e]))-Srot3*(Crot2*y[1,e]))*g)+xv;
yp1[e] := yv-trunc((f/zp1)*(Crot3*((Crot2*y[1,e]))+Srot3*(Crot*x[1,e]+Srot*(Srot2*y[1,e])))*g);

  zp2 := Srot*x[2, e]-Crot*Crot2*y[2, e]+di;
 xp2[e] := trunc((f/zp2)*(Crot3*(Crot*x[2,e]+Srot*(Srot2*y[2,e]))-Srot3*(Crot2*y[2, e]))*g)+xv;
yp2[e] := yv-trunc((f/zp2)*(Crot3*((Crot2*y[2,e]))+Srot3*(Crot*x[2,e]+Srot*(Srot2*y[2, e])))*g);
setcolor(3);LINE (xp1[e],yp1[e],xp2[e],yp2[e]);    {Zeichnen}
end;
until keypressed;
end;

procedure vektorgrafx;
var wait : longint;
begin
settextstyle(defaultfont, horizdir,5);
setcolor(15);
outtextxy(20,100,'-Vektorgrafix-');
for wait := 1 to 22000000 do begin end;
setcolor(16);
outtextxy(20,100,'-Vektorgrafix-');
end;



begin                                      {Main}
datlese;
starfield;
graf;
vektorgrafx;
editXYZ;
rotate;
closegraph;
end.
