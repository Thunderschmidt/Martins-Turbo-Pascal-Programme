uses crt,graph,joystick;
type Startype=array[0..255] of record x,y,z: integer;end;
type JoyType=record Xj,Yj : integer;b1,b2,b3,b4:boolean;END;

var
    sterne : Startype;

    e ,kx,ky   :                        byte;          {Index}
    rot,srot,crot,srotl,crotl :   real;
xs,ys:integer;

procedure center;
var Joy : JoyType;
BEGIN
 clrscr;
  writeln('Bitte zentrieren sie ihren Joystick und drÅcken sie einen Knopf.');
   with joy do BEGIN
    repeat
     JoyButton(b1, b2, b3, b4);
      until not b1 or not b2 or not b3 or not b4;
       JoyKoor(Xj, Yj);
  END;
 kX := Joy.Xj; kY := Joy.Yj;
END;




procedure graf;
var grDriver , grMode :       Integer;    {InitGraph (640*480*16)}
begin
    grDriver := Detect;
  InitGraph(grDriver,grMode,'c:\tp');
end;

procedure starfield;                    {generiert Sternenhintergrund}

begin
randomize;
for e:=0 to 255 do begin
with sterne[e] do begin
z :=random(580)+20;
x := random(2400)-1200;
y := random(1700)-950;
end;
end
end;

Procedure Pixel;                       { Sternenscroller}
var farbe: byte;
joy : joyType;
xv, yv : shortint;
begin
joykoor(joy.xj,joy.yj);
xv :=  (joy.xj-kx) div 2;
yv :=  (joy.yj-ky) div 2;
rot := rot +0.005;
crot:= cos(rot);
srot:= sin(rot);
for e:= 0 to 255 do
with sterne[e] do begin
xs:=trunc((50/z)*x);
ys:=trunc((50/z)*y);
putpixel(xs+320,240-ys, black);

inc(z,-4);
inc(y,-yv);
inc(x,-xv);

{if (((50/z)*x)<-320) or (((50/z)*x) > 320) or (((50/z)*y) > 240) or (((50/z)*y) < -240) then begin}
if z < 30 then     begin
z := 450;
x := (random(4800)-2400);
y := (random(3400)-1700);
end;
if z  < 180 then farbe := 15;
if z  > 180 then farbe := 7;
if z  > 320  then farbe := 8;
xs:=trunc((50/z)*x);
ys:=trunc((50/z)*y);

putpixel(xs+320,240-ys, farbe);
end;
crotl:=crot;
srotl:=srot;

end;

begin
center;
graf;
starfield;
repeat
pixel;
until keypressed;
closegraph;
end.