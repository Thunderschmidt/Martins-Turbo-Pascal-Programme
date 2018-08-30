  uses joystick, crt, graph;
  var b1, b2, b3, b4,sc : Boolean;
    x, y,cx, cy   : Integer;
    xs        : array[1..100] of integer;
    ys        : array[1..100] of integer;
    xl       : array[1..8, 1..2] of integer;
    yl       : array[1..8, 1..2] of shortint;
    zl       : array[1..8, 1..2] of shortint;
grDriver :                  Integer;
    grMode   :                  Integer;
    ErrCode  :                  Integer;
    a,c      :                     byte;
    b,bl,pos,poso :                  integer;
   d        : real;
  k        : word;
  ze       : real;
  zo       : real;
  m        : real;
  n        : real;

  const sp =35;

procedure shoot;
begin
for a := 1 to 6 do begin
             ze:=22/(zl[a, 1]+d);
             zo:=22/(zl[a, 2]+d);
             setcolor(0);
             line(trunc(xl[a, 1]*ze+320-m*d+poso), trunc(yl[a, 1]*ze)+240,
                  trunc(xl[a, 2]*zo+320-m*d+poso), trunc(yl[a, 2]*zo)+240);

             ze:=22/(zl[a, 1]+d+sp);
             zo:=22/(zl[a, 2]+d+sp);

             setcolor(7);
             line(trunc(xl[a, 1]*ze+320-m*(d+1)+pos), trunc(yl[a, 1]*ze)+240,
                  trunc(xl[a, 2]*zo+320-m*(d+1)+pos), trunc(yl[a, 2]*zo)+240);
end;
end;

procedure kill;
begin
for a := 1 to 6 do begin
             ze:=22/(zl[a, 1]+d+sp);
             zo:=22/(zl[a, 2]+d+sp);
             setcolor(0);
             line(trunc(xl[a, 1]*ze+320-m*(d+1)+pos), trunc(yl[a, 1]*ze)+240,
                  trunc(xl[a, 2]*zo+320-m*(d+1)+pos), trunc(yl[a, 2]*zo)+240);
end;
end;

procedure randomizing;
  begin
  randomize;
  for a := 1 to 100 do
begin
  xs[a]:=random(640);
  ys[a]:=random(480);
end;
end;
   procedure data;
    begin
  xl[1,1]:=-340; yl[1,1]:=-40; zl[1,1]:=-20;   xl[1,2]:=-340; yl[1,2]:=0; zl
  [1,2]:=-20;
  xl[2,1]:=-340; yl[2,1]:=-40; zl[2,1]:=-20;   xl[2,2]:=-340; yl[2,2]:=-20; zl[2,2]:=40;
  xl[3,1]:=-340; yl[3,1]:=0; zl[3,1]:=-20;    xl[3,2]:=-340; yl[3,2]:=-20; zl[3,2]:=40;
  xl[4,1]:=340; yl[4,1]:=-40; zl[4,1]:=-20;  xl[4,2]:=340; yl[4,2]:=0; zl[4,2]:=-20;
  xl[5,1]:=340; yl[5,1]:=-40; zl[5,1]:=-20; xl[5,2]:=340; yl[5,2]:=-20; zl[5,2]:=40;
  xl[6,1]:=340; yl[6,1]:=0; zl[6,1]:=-20;  xl[6,2]:=340; yl[6,2]:=-20; zl[6,2]:=40;
end;

  procedure graf;
  begin
  grDriver := Detect;
  InitGraph(grDriver,grMode,'');
  ErrCode := GraphResult;
  end;

  procedure ausgabe;
begin
bl:=b;
if b > 640 then b:=b-640;
if b < 0 then b:=b+640;
b:=b-trunc((x-cx)/10);
  for a := 1 to 100 do

begin
  putpixel(xs[a]+bl, ys[a], black);
  putpixel(xs[a]+b, ys[a], white);
  putpixel(xs[a]+bl-640, ys[a], black);
  putpixel(xs[a]+b-640, ys[a], white);
end;
end;

procedure centre;
begin
writeln('Bitte zentrieren sie ihren Joystick und drcken sie einen Knopf.');
repeat
JoyButton(b1, b2, b3, b4);
until b4 xor b3=true;
JoyKoor(cx, cy);
writeln(cx,'  ',cy);
end;

  begin
  m:=0;
    d:=10;
    pos:=0;
  ClrScr;
  centre;
  graf;
  randomizing;
  data;
  shoot;
  ausgabe;
  repeat

setcolor(7);circle(320,240,6);
  JoyButton(b1, b2, b3, b4);
    if b3=false then sc:= false;
    if sc=false then begin
    poso:=pos;
    pos:=pos-trunc((x-cx)/10);
    shoot;
    d:=d+sp;
    if d > 600 then begin
    kill;
    d:=10;
    sc:=true;
    pos:=0;
    end;
    end;
    JoyKoor(x, y);
  if (x > (cx+10)) or (x < (cx-10)) or (y < (cy-10)) or (y > (cy+10)) then ausgabe;
  until KeyPressed;

end.