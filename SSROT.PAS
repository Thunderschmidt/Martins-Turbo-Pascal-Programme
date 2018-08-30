
uses crt, graph;
type VType = array[ 1..2,0..90] of shortint;
     Sintype=array[0..450] of integer;

var
    x                  :VType;
    y                  :VType;
    z                  :VType;
    no, n,e,b    :                        byte;
    xs                 : array[1..100] of integer;
    ys                 : array[1..100] of integer;

procedure datlese;
var c : array[1..12] of   string;
    er: integer;
    t : text;
    a : string;
    s,l : byte;
begin
c[1]:='h';c[2]:='';c[3]:='d';c[4]:='e';
c[5]:='p';c[6]:='o';c[7]:='h';c[8]:='l';
c[9]:='o';c[10]:='plus';c[11]:='m';
b := 0;
no := 0;
for e :=1 to 8 do begin
assign(t, 'c:\tp\'+c[e]+'.rot');
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
no:=no+n+2;
end;
end;

procedure graf;
var grDriver , grMode :            Integer;
begin
    grDriver := Detect;
  InitGraph(grDriver,grMode,'c:\tp');
end;

procedure editXYZ;
begin;
for e := 1 to b do begin
x[1, e]:=x[1, e]-no div 2;
x[2, e]:=x[2, e]-no div 2;
y[1, e]:=y[1, e]-3;
y[2, e]:=y[2, e]-3;
end;
end;

procedure SinCos(d:word;winkel: Sintype);

const kb   = (Pi/180);
begin
for d := 0 to 449{sizeof(winkel)} do Begin;
winkel[d]:=trunc(Sin(d*kb)*32767);
end;
end;

Procedure Pixel(d:word);
begin
for e:= 1 to 100 do
begin
  putpixel(xs[e]+d-1, ys[e], black);
  putpixel(xs[e]+d, ys[e], white);
  putpixel(xs[e]+d-1-640, ys[e], black);
  putpixel(xs[e]+d-640, ys[e], white);
end;
end;
procedure rotate;
    var
    zp1,srot,crot, zp2,srot2,crot2,srot3,crot3:                     real;
     xp1, xp2, yp1, yp2 : array[1..90] of    Integer;
    rot2, rot3, rot,d: integer;
    winkel : Sintype;


const         zo =0 ;
               kb   = (Pi/180);
                r  = 2;
                 r2 = 1;
                  r3 = 1;
                   g  = 400 ;
                    di = 32;
                     f  = 1.5;
                      xv = 320;
                       yv = 240;
                        um = 32767;
begin
rot:=0;rot2:=0;rot3:=0;d:=0;
{SinCos(d,winkel);}
for d := 0 to 449 do Begin;
winkel[d]:=trunc(Sin(d*kb)*um);
end;

repeat
if d = 640 then d := 0; d := d+1;
if rot = 360 then rot := 0;

Pixel(d);
rot:= rot+r;
rot2:= rot2+r2;
rot3 := rot3+r3;
if rot > 359 then rot := rot-360;
if rot2> 359 then rot2:= rot2-360;
if rot3> 359 then rot3:= rot3-360;

Srot:=winkel[rot] / um;
Crot:=winkel[rot+90] /um;
Srot2:=winkel[rot2] / um;
Crot2:=winkel[rot2+90] / um;
Srot3:=winkel[rot3] / um;
Crot3:=winkel[rot3+90] / um;
for e := 1 to b do begin
setcolor(0);
LINE (xp1[e],yp1[e],xp2[e],yp2[e]);
zp1 := Srot*(x[1, e])-Crot*Crot2*(y[1, e])+di;
xp1[e] := trunc((f/zp1)*(Crot3*(Crot * (x[1, e]) + Srot * (Srot2 * (y[1, e])))-
Srot3*(Crot2 * (y[1, e])))*g)+xv;
yp1[e] :=yv-trunc((f/zp1)*(Crot3*((Crot2 * (y[1, e])))+
Srot3*(Crot * (x[1, e]) + Srot * (Srot2 * (y[1, e]))))*g);
zp2 := Srot*(x[2, e])-Crot*(Crot2*(y[2, e]))+di;
xp2[e] := trunc((f/zp2)*(Crot3*(Crot * (x[2, e]) + Srot * (Srot2 * (y[2, e])))-
Srot3*(Crot2 * (y[2, e])))*g)+xv;
yp2[e] :=yv-trunc((f/zp2)*(Crot3*((Crot2 * (y[2, e])))+
Srot3*(Crot * (x[2, e]) + Srot * (Srot2 * (y[2, e]))))*g);
setcolor(10);
LINE (xp1[e],yp1[e],xp2[e],yp2[e]);
end;
until keypressed;
end;

procedure starfield;
begin
for e:=1 to 100 do begin
xs[e]:=random(640);
ys[e]:=random(480);
end
end;


begin
starfield;
datlese;
graf;
editXYZ;
rotate;
closegraph;
end.