  uses joystick, crt, graph;
  var b1, b2, b3, b4: Boolean;
  sc  :array[-1..1] of boolean;
      x, y,cx, cy   : Integer;
    xs        : array[1..100] of integer;
    ys        : array[1..100] of integer;
    xl       : array[1..8, 1..2] of integer;
    yl       : array[1..8, 1..2] of shortint;
    zl       : array[1..8, 1..2] of shortint;
    f        : array[-1..1] of byte;
grDriver :                  Integer;
    grMode   :                  Integer;
    ErrCode  :                  Integer;
    a,c    :                    byte;
    w,v    :  shortint;
    bx,bxl,by,byl     :                  integer;
   posX,posoX,posY,posoY  : array[-1..1] of integer;
   d       : array[-1..1] of integer;
  k        : word;
  ze       : real;
  zo       : real;
  m        : real;

  const sp =110;
        yz =0;
procedure shoot;
begin
{for a := (1+f[w]) to (3+f[w]) do begin}
for a := 1 to 6 do begin
             ze:=22/(zl[a,1] +d[w]);
             zo:=22/(zl[a, 2]+d[w]);
             setcolor(0);
             line(trunc(xl[a, 1]*ze+320-m*d[w]+posoX[w]), trunc((yl[a, 1]+yz*w)*ze)+240+posoY[w],
                  trunc(xl[a, 2]*zo+320-m*d[w]+posoX[w]), trunc((yl[a, 2]+yz*w)*zo)+240+posoY[w]);

             ze:=22/(zl[a, 1]+d[w]+sp);
             zo:=22/(zl[a, 2]+d[w]+sp);

             setcolor(7);
             line(trunc(xl[a, 1]*ze+320-m*(d[w])+posX[w]), trunc((yl[a, 1]+yz*w)*ze)+240+posY[w],
                  trunc(xl[a, 2]*zo+320-m*(d[w])+posX[w]), trunc((yl[a, 2]+yz*w)*zo)+240+posY[w]);
end;
end;

procedure kill;
begin
for a := 1 to 6 do begin
{for a := (1+f[w]) to (3+f[w]) do begin}

             ze:=22/(zl[a, 1]+d[w]);
             zo:=22/(zl[a, 2]+d[w]);
             setcolor(0);
             line(trunc(xl[a, 1]*ze+320-m*(d[w])+posX[w]), trunc((yl[a, 1]+yz*w)*ze)+240+posY[w],
                  trunc(xl[a, 2]*zo+320-m*(d[w])+posX[w]), trunc((yl[a, 2]+yz*w)*zo)+240+posY[w]);

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
bxl:=bx;
if bx > 640 then bx:=bx-640;
if bx < 0 then bx:=bx+640;
bx:=bx-trunc((x-cx)/10);
byl:=by;
if by > 480 then by:=by-480;
if by < 0 then by:=by+480;
by:=by+trunc((y-cy)/10);
  for a := 1 to 100 do

begin
  putpixel(xs[a]+bxl, ys[a]+byl, black);
  putpixel(xs[a]+bx, ys[a]+by, white);
  putpixel(xs[a]+bxl-640, ys[a]+byl, black);
  putpixel(xs[a]+bx-640, ys[a]+by, white);
  putpixel(xs[a]+bxl, ys[a]+byl-480, black);
  putpixel(xs[a]+bx, ys[a]+by-480, white);
  putpixel(xs[a]+bxl-640, ys[a]+byl-480, black);
  putpixel(xs[a]+bx-640, ys[a]+by-480, white);
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
  m:=0;d[1]:=24;w:=1;posX[1]:=0;d[-1]:=24;posX[-1]:=0;f[1]:=3;
  sc[-1]:=true;sc[1]:=true;posY[-1]:=0;posY[1]:=0;f[-1]:=0;
  ClrScr;
  centre;
  graf;
  randomizing;
  data;
  shoot;
  ausgabe;
  repeat

setcolor(7);circle(320,240,6);putpixel(320,240,white);

  JoyButton(b1, b2, b3, b4);
    if (sc[-1]=false) and (sc[1]=false) then w:= -w;
    if b3=false then sc[w]:= false;
    if sc[w]=false then begin (**)
    if d[w] >= 250 then  if b3=false then sc[-w]:= false;
    posoX[w]:=posX[w];
    posoY[w]:=posY[w];
    if sc[-w]=false then v:= 2 else v:=1;
    posX[w]:=posX[w]-v*(trunc((x-cx)/10));
    posY[w]:=posY[w]+v*(trunc((y-cy)/10));
    shoot;
    d[w]:=d[w]+sp;
    if d[w] >= 1800 then begin
    kill;
    d[w]:=24-sp;
    sc[w]:=true;
    posX[w]:=0;
    posY[w]:=0;
    w:=-w;
    end;
    {end;}
    end;
    JoyKoor(x, y);
  if (x > (cx+10)) or (x < (cx-10)) or (y < (cy-10)) or (y > (cy+10)) then ausgabe;
  until KeyPressed;

end.