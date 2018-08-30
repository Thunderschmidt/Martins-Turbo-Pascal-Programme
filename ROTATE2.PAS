uses crt, graph;
var t : text;
    a : string;
    c : array[1..10] of string;
    x : array[ 1..2,0..80] of byte;
    y : array[ 1..2,0..80] of byte;
    z : array[ 1..2,0..80] of byte;
    xs       : array[1..100] of integer;
    ys       : array[1..100] of integer;
    b, d : word;
    zo, l, no, n, e, s,f : byte;
    er : integer;
    grDriver : Integer;
    grMode   : Integer;
    ErrCode  : Integer;
     rot, rot2,xp1, xp2, yp1, yp2, zp1, zp2, r, r2  : real;

procedure datlese;
begin
c[1]:='p';c[2]:='a';c[3]:='p';c[4]:='a';c[5]:='c';c[6]:='a';c[7]:='r';c[8]:='o';
b := 0;
no := 0;
for e := 1 to 4 do begin

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
no:=no+n+1;
end;
writeln(b,' ',c[e]);
end;

procedure graf;
begin
  grDriver := Detect;
  InitGraph(grDriver,grMode,'');
  ErrCode := GraphResult;
  IF ErrCode = grOk THEN
for e := 1 to b do line(x[1, e]*15+40, 440-y[1,e]*15, x[2,e]*15+40, 440-y[2, e]*15);
end;



procedure starfield;
begin
randomize;
  for f := 1 to 100 do
begin
  xs[f]:=random(640);
  ys[f]:=random(480);
end;
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
if d = 640 then d := 0;
d := d+1;

for f:= 1 to 100 do
begin

  putpixel(xs[f]+d-1, ys[f], black);
  putpixel(xs[f]+d, ys[f], white);
  putpixel(xs[f]+d-1-640, ys[f], black);
  putpixel(xs[f]+d-640, ys[f], white);

end;

for e := 1 to b do begin
setcolor(0);
zp1 := SIN(rot) * (x[1, e]-no/2) - COS(rot) * (SIN(rot2) * y[1, e] - COS(rot2) * -2{z[1, e]});
zp2 := SIN(rot) * (x[2, e]-no/2) - COS(rot) * (SIN(rot2) * y[2, e] - COS(rot2) * -2{z[2, e]});
xp1 := COS(rot) * (x[1, e]-no/2) + SIN(rot) * (SIN(rot2) * y[1, e] - COS(rot2) * -2{z[1, e]});
xp2 := COS(rot) * (x[2, e]-no/2) + SIN(rot) * (SIN(rot2) * y[2, e] - COS(rot2) * -2{z[2, e]});
yp1 := COS(rot2) * (y[1, e]-2.5) + SIN(rot2) * -2{z[1, e]};
yp2 := COS(rot2) * (y[2, e]-2.5) + SIN(rot2) * -2{z[2, e]};

LINE (trunc((xp1 * (zo / (zo + 1 + zp1)) *  (50-zo)) + 320),trunc((240 - yp1 * (zo / (zo + 1 + zp1)) *  (50-zo))),
     trunc(xp2 * (zo / (zo + 1 + zp2)) *  (50-zo) + 320), trunc(240 - yp2 * (zo / (zo + 1 + zp2)) *  (50-zo)));

zp1 := SIN(rot) * (x[1, e]-no/2) - COS(rot) * (SIN(rot2) * y[1, e] - COS(rot2) * 6{z[1, e]});
zp2 := SIN(rot) * (x[2, e]-no/2) - COS(rot) * (SIN(rot2) * y[2, e] - COS(rot2) * 6{z[2, e]});
xp1 := COS(rot) * (x[1, e]-no/2) + SIN(rot) * (SIN(rot2) * y[1, e] - COS(rot2) * 6{z[1, e]});
xp2 := COS(rot) * (x[2, e]-no/2) + SIN(rot) * (SIN(rot2) * y[2, e] - COS(rot2) * 6{z[2, e]});
yp1 := COS(rot2) * (y[1, e]-2.5) + SIN(rot2) * 6{z[1, e]};
yp2 := COS(rot2) * (y[2, e]-2.5) + SIN(rot2) * 6{z[2, e]};

LINE (trunc((xp1 * (zo / (zo + 1 + zp1)) *  (50-zo)) + 320),trunc((240 - yp1 * (zo / (zo + 1 + zp1)) *  (50-zo))),
     trunc(xp2 * (zo / (zo + 1 + zp2)) *  (50-zo) + 320), trunc(240 - yp2 * (zo / (zo + 1 + zp2)) *  (50-zo)));
setcolor(10);

zp1 := SIN(rot+r) * (x[1, e]-no/2) - COS(rot+r) * (SIN(rot2+r2) * y[1, e] - COS(rot2+r2) * -2{z[1, e]});
zp2 := SIN(rot+r) * (x[2, e]-no/2) - COS(rot+r) * (SIN(rot2+r2) * y[2, e] - COS(rot2+r2) * -2{z[2, e]});
xp1 := COS(rot+r) * (x[1, e]-no/2) + SIN(rot+r) * (SIN(rot2+r2) * y[1, e] - COS(rot2+r2) * -2{z[1, e]});
xp2 := COS(rot+r) * (x[2, e]-no/2) + SIN(rot+r) * (SIN(rot2+r2) * y[2, e] - COS(rot2+r2) * -2{z[2, e]});
yp1 := COS(rot2+r2) * (y[1, e]-2.5) + SIN(rot2+r2) * -2{z[1, e]};
yp2 := COS(rot2+r2) * (y[2, e]-2.5) + SIN(rot2+r2) * -2{z[2, e]};
LINE (trunc((xp1 * (zo / (zo + 1 + zp1)) *  (50-zo)) + 320),trunc((240 - yp1 * (zo / (zo + 1 + zp1)) *  (50-zo))),
     trunc(xp2 * (zo / (zo + 1 + zp2)) *  (50-zo) + 320), trunc(240 - yp2 * (zo / (zo + 1 + zp2)) *  (50-zo)));

zp1 := SIN(rot+r) * (x[1, e]-no/2) - COS(rot+r) * (SIN(rot2+r2) * y[1, e] - COS(rot2+r2) * 6{z[1, e]});
zp2 := SIN(rot+r) * (x[2, e]-no/2) - COS(rot+r) * (SIN(rot2+r2) * y[2, e] - COS(rot2+r2) * 6{z[2, e]});
xp1 := COS(rot+r) * (x[1, e]-no/2) + SIN(rot+r) * (SIN(rot2+r2) * y[1, e] - COS(rot2+r2) * 6{z[1, e]});
xp2 := COS(rot+r) * (x[2, e]-no/2) + SIN(rot+r) * (SIN(rot2+r2) * y[2, e] - COS(rot2+r2) * 6{z[2, e]});
yp1 := COS(rot2+r2) * (y[1, e]-2.5) + SIN(rot2+r2) * 6{z[1, e]};
yp2 := COS(rot2+r2) * (y[2, e]-2.5) + SIN(rot2+r2) * 6{z[2, e]};
LINE (trunc((xp1 * (zo / (zo + 1 + zp1)) *  (50-zo)) + 320),trunc((240 - yp1 * (zo / (zo + 1 + zp1)) *  (50-zo))),
     trunc(xp2 * (zo / (zo + 1 + zp2)) *  (50-zo) + 320), trunc(240 - yp2 * (zo / (zo + 1 + zp2)) *  (50-zo)));

end;
until keypressed;
end;


begin
randomize;
  for f := 1 to 100 do
begin
  xs[f]:=random(640);
  ys[f]:=random(480);
end;
    rot :=20;
    rot2 :=0;
    zo := 28;
    r :=0.06;
    r2:=0.033;
datlese;
{graf;}
rotate;
closegraph;

end.