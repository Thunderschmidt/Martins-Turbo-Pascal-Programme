uses crt,graph;
var t : text;
    a : string;
    c : string;
    x : array[1..2,1..50] of integer;
    y : array[1..2,1..50] of integer;
    z : array[1..2,1..50] of integer;
    zp1,zp2,xp1,xp2,yp1,yp2,rot2,rot3,rot:real;

grDriver : Integer;
grMode   : Integer;
ErrCode  : Integer;

   er,e : integer;
    b : byte;

     const zo = 49.80; r=0.005;r2=0.01 ;r3 = 0.02;d=500;f=10;g=50;

    begin
rot := 0;
rot2 :=0 ;
rot3 := 0;
b := 0;
clrscr;assign(t, 'c:\tp\cobra2.dat');
reset(t);
readln(t,a);
readln(t,a);

repeat
b := b + 1;
readln(t, a);
val(a, x[1,b], er);
readln(t, a);
val(a, y[1,b], er);
readln(t, a);
val(a, z[1,b], er);
readln(t, a);
val(a, x[2,b], er);
readln(t, a);
val(a, y[2,b], er);
readln(t, a);
val(a, z[2,b], er);
readln(t, a);

until eof(t);


grDriver := Detect;
InitGraph(grDriver,grMode,'');
ErrCode := GraphResult;

repeat
rot := rot+r;
rot2 := rot2+r2;
rot3 := rot3+r3;

for e:= 1 to 24 do begin;
setcolor(0);
xp1 := cos(rot3)*(COS(rot) * (x[1, e]) + SIN(rot) * (SIN(rot2) * y[1, e] - COS(rot2) * z[1, e]))-
sin(rot3)*(COS(rot2) * (y[1, e]) + SIN(rot2) * z[1, e]);
xp2 := cos(rot3)*(COS(rot) * (x[2, e]) + SIN(rot) * (SIN(rot2) * y[2, e] - COS(rot2) * z[2, e]))-
sin(rot3)*(COS(rot2) * (y[2, e]) + SIN(rot2) * z[2, e]);
yp1 := cos(rot3)*((COS(rot2) * (y[1, e]) + SIN(rot2) * z[1, e]))+
sin(rot3)*(COS(rot) * (x[1, e]) + SIN(rot) * (SIN(rot2) * y[1, e] - COS(rot2) * z[1, e]));
yp2 := cos(rot3)*(COS(rot2) * (y[2, e]) + SIN(rot2) * z[2, e])+
sin(rot3)*(COS(rot) * (x[2, e]) + SIN(rot) * (SIN(rot2) * y[2, e] - COS(rot2) * z[2, e]));

zp1 := Sin(rot)*(x[1, e])-Cos(rot)*(Sin(rot2)*z[1, e]+Cos(rot2)*y[1, e])+d;
zp2 := Sin(rot)*(x[2, e])-Cos(rot)*(Sin(rot2)*z[2, e]+Cos(rot2)*y[2, e])+d;

LINE (trunc((f/zp1)*xp1*g)+320,240-trunc((f/zp1)*yp1*g),trunc((f/zp2)*xp2*g)+320,240-trunc((f/zp2)*yp2*g));

setcolor(7);
xp1 := cos(rot3+r3)*(COS(rot+r) * (x[1, e]) + SIN(rot+r) * (SIN(rot2+r2) * y[1, e] - COS(rot2+r2) * z[1, e]))-
sin(rot3+r3)*(COS(rot2+r2) * (y[1, e]) + SIN(rot2+r2) * z[1, e]);
xp2 := cos(rot3+r3)*(COS(rot+r) * (x[2, e]) + SIN(rot+r) * (SIN(rot2+r2) * y[2, e] - COS(rot2+r2) * z[2, e]))-
sin(rot3+r3)*(COS(rot2+r2) * (y[2, e]) + SIN(rot2+r2) * z[2, e]);
yp1 := cos(rot3+r3)*((COS(rot2+r2) * (y[1, e]) + SIN(rot2+r2) * z[1, e]))+
sin(rot3+r3)*(COS(rot+r) * (x[1, e]) + SIN(rot+r) * (SIN(rot2+r2) * y[1, e] - COS(rot2+r2) * z[1, e]));
yp2 := cos(rot3+r3)*(COS(rot2+r2) * (y[2, e]) + SIN(rot2+r2) * z[2, e])+
sin(rot3+r3)*(COS(rot+r) * (x[2, e]) + SIN(rot+r) * (SIN(rot2+r2) * y[2, e] - COS(rot2+r2) * z[2, e]));
zp1 := Sin(rot+r)*(x[1, e])-Cos(rot+r)*(Sin(rot2+r2)*z[1, e]+Cos(rot2+r2)*y[1, e])+d;
zp2 := Sin(rot+r)*(x[2, e])-Cos(rot+r)*(Sin(rot2+r2)*z[2, e]+Cos(rot2+r2)*y[2, e])+d;

LINE (trunc((f/zp1)*xp1*g)+320,240-trunc((f/ zp1)*yp1*g),trunc((f/zp2)*xp2*g)+320,240-trunc((f/zp2)*yp2*g));

end;
until keypressed;
end.

