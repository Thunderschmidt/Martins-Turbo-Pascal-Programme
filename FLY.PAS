
uses crt, graph;
type Startype=array[1..150] of record x,y: integer;ebene:byte;end;
var
    x, y, z                  : array[ 1..2,1..24] of shortint;
    no, e,b    :                        byte;          {Index}
    sterne : Startype;


procedure datlese;
var                    
     er,aha : integer;
      t  : text;
       a  : string;
       s,n,l: byte;
begin
b:=0;
assign(t, 'cobra2.dat');
reset(t);
readln(t,a);
readln(t,a);

repeat
b := b + 1;
readln(t, a);
val(a, aha, er);x[1,b]:=aha div 5;
readln(t, a);
val(a, aha, er);y[1,b]:=aha div 5;
readln(t, a);
val(a, aha, er);z[1,b]:=aha div 5;
readln(t, a);
val(a, aha, er);x[2,b]:=aha div 5;
readln(t, a);
val(a, aha, er);y[2,b]:=aha div 5;
readln(t, a);
val(a, aha, er);z[2,b]:=aha div 5;
readln(t, a);
until eof(t);
end;

procedure graf;
var grDriver , grMode :       Integer;    {InitGraph (640*480*16)}
begin
    grDriver := Detect;
  InitGraph(grDriver,grMode,'c:\tp');
end;

procedure starfield;                    {generiert Sternenhintergrund}
begin
randomize;
for e:=1 to 150 do begin
with sterne[e] do begin
x:=random(640);
y:=random(450)+30;
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
y := random(450)+30;
ebene:=random(3)+1;
end;
putpixel(x, y, farbe);
end;
end;





procedure rotate;                      {Rotationsprogramm, Berechnungen}
    var
    i,yi,di : integer;
    rot, rot2, rot3,
    zp1, zp2,srot,crot,srot3,crot3:                     real;
    xp1, xp2, yp1, yp2 : array[1..24] of    Integer;
const          
                r  = 0.01;
                 r2 = 0.02;
                  r3 = 0.01;         {Rotationsgeschwindigkeiten}
                   g  = 30 ;         {g=Vergr”áerung}
                     f  = 17;          {Zoom}
                      xv = 320;
                       yv = 280;          {xv, yv : Verschiebung}
                        kb = pi /180;
begin
rot:=0;rot3:=0;i := -1000;
repeat
pixel;
if i=500 then i:=-800; i:=i+1;yi:=i div 3; di:=trunc(0.01*i*i)+90;
rot:= arctan(0.02*i)-90*kb; rot3 :=(kb*90-abs(arctan(0.02*i)))-0.004*(abs(i)+i);
 Srot:=Sin(rot); Crot:=Cos(rot);
   Srot3:=Sin(rot3); Crot3:=Cos(rot3);     {Sin & Cos-Berechnungen}

for e := 1 to 24 do begin

setcolor(0); LINE (xp1[e],yp1[e],xp2[e],yp2[e]);   {L”schen}

  zp1:=crot*z[1,e]-srot*x[1,e]+di;
 yp1[e]:=yv-trunc((f/zp1)*(yi+Crot3*y[1,e]-srot3*x[1, e])*g);
   xp1[e]:=xv+trunc((f/zp1)*(i+Crot*(crot3*x[1,e]+srot3*y[1, e])+srot3*z[1,e])*g);
  zp2:=crot*z[2,e]-srot*x[2,e]+di;
 yp2[e]:=yv-trunc((f/zp2)*(yi+Crot3*y[2,e]-srot3*x[2, e])*g);
xp2[e]:=xv+trunc((f/zp2)*(i+Crot*(crot3*x[2,e]+srot3*y[2, e])+srot3*z[2,e])*g);


setcolor(7);LINE (xp1[e],yp1[e],xp2[e],yp2[e]);    {Zeichnen}
end;
until keypressed;
end;



begin                                      {Main}
datlese;
starfield;
graf;
rotate;
closegraph;
end.

