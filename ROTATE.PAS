uses crt, graph;
var t                  :                       text;
    a                  :                     string;
    c                  : array[1..12] of     string;
    x                  : array[ 1..2,0..132] of byte;
    y                  : array[ 1..2,0..132] of byte;
    z                  : array[ 1..2,0..132] of byte;
    l, no, n, e,s    :                        byte;
    xs                 : array[1..100] of integer;
    ys                 : array[1..100] of integer;
    grDriver           :                  Integer;
    grMode             :                  Integer;
    ErrCode            :                  Integer;
    er                 :                  Integer;
    b, d               :                     word;
    rot, rot2, xp1, xp2, rot3, h,
    yp1, yp2, zp1, zp2 :                     real;

const                zo =0 ;
       r  = 0.01;
                     r2 = 0.02;
                     r3 = 0.015;
                                   g  = 250;
                     di = 34;
                     f  = 1.5;
procedure datlese;
begin
c[1]:='h';c[2]:='e';c[3]:='l';c[4]:='l';
c[5]:='m';c[6]:='u';c[7]:='t';c[8]:='b';
c[9]:='e';c[10]:='r';c[11]:='t';
b := 0;
no := 0;
for e := 1 to 7 do begin

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
h:=no/2;
end;

procedure rotate;
begin

  grDriver := Detect;
  InitGraph(grDriver,grMode,'');
  ErrCode := GraphResult;
  IF ErrCode = grOk THEN


repeat
rot2:= rot2+r2;
rot:= rot+r;
rot3 := rot3+r3;
if d = 3 then begin
for s:=1 to 100 do begin
putpixel(xs[s],ys[s],white);
end;
d := 0;
end;
d := d+1;


for e := 1 to b do begin
xp1 := cos(rot3)*(COS(rot) * (x[1, e]-h) + SIN(rot) * (SIN(rot2) * (y[1, e]-2.5)))-
sin(rot3)*(COS(rot2) * (y[1, e]-2.5));
xp2 := cos(rot3)*(COS(rot) * (x[2, e]-h) + SIN(rot) * (SIN(rot2) * (y[2, e]-2.5)))-
sin(rot3)*(COS(rot2) * (y[2, e]-2.5));

yp1 := cos(rot3)*((COS(rot2) * (y[1, e]-2.5)))+
sin(rot3)*(COS(rot) * (x[1, e]-h) + SIN(rot) * (SIN(rot2) * (y[1, e]-2.5)));
yp2 := cos(rot3)*((COS(rot2) * (y[2, e]-2.5)))+
sin(rot3)*(COS(rot) * (x[2, e]-h) + SIN(rot) * (SIN(rot2) * (y[2, e]-2.5)));
zp1 := Sin(rot)*(x[1, e]-h)-Cos(rot)*(Cos(rot2)*(y[1, e])-2.5)+di;
zp2 := Sin(rot)*(x[2, e]-h)-Cos(rot)*(Cos(rot2)*(y[2, e])-2.5)+di;

setcolor(0);
LINE (trunc((f/zp1)*xp1*g)+320,240-trunc((f/zp1)*yp1*g),trunc((f/zp2)*xp2*g)+320,240-trunc((f/zp2)*yp2*g));

xp1 := cos(rot3+r3)*(COS(rot+r) * (x[1, e]-h) + SIN(rot+r) * (SIN(rot2+r2) * (y[1, e]-2.5)))-
sin(rot3+r3)*(COS(rot2+r2) * (y[1, e]-2.5));
xp2 := cos(rot3+r3)*(COS(rot+r) * (x[2, e]-h) + SIN(rot+r) * (SIN(rot2+r2) * (y[2, e]-2.5)))-
sin(rot3+r3)*(COS(rot2+r2) * (y[2, e]-2.5));
yp1 := cos(rot3+r3)*((COS(rot2+r2) * (y[1, e]-2.5)))+
sin(rot3+r3)*(COS(rot+r) * (x[1, e]-h) + SIN(rot+r) * (SIN(rot2+r2) * (y[1, e]-2.5)));
yp2 := cos(rot3+r3)*((COS(rot2+r2) * (y[2, e]-2.5)))+
sin(rot3+r3)*(COS(rot+r) * (x[2, e]-h) + SIN(rot+r) * (SIN(rot2+r2) * (y[2, e]-2.5)));
zp1 := Sin(rot+r)*(x[1, e]-h)-Cos(rot+r)*(Cos(rot2+r2)*(y[1, e])-2.5)+di;
zp2 := Sin(rot+r)*(x[2, e]-h)-Cos(rot+r)*(Cos(rot2+r2)*(y[2, e])-2.5)+di;

setcolor(10);
LINE (trunc((f/zp1)*xp1*g)+320,240-trunc((f/zp1)*yp1*g),trunc((f/zp2)*xp2*g)+320,240-trunc((f/zp2)*yp2*g));
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
rot:=0;rot2:=0;rot3:=0;
datlese;
rotate;
closegraph;
end.