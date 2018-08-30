uses crt,graph;




var
y : array[-6..8,-6..8] of integer;
RK   :Char;
rotX,rotY,w,land:word;
sinus: array[0..449] of shortint;
welle,color : byte;
bx,by: array[-6..8,-6..8] of integer;

Procedure PutPixel(x,y,col:word);assembler;
{setzt Punkt (x/y) auf Farbe col (Mode 13h)}
asm
  mov ax,0a000h                 {Segment laden}
  mov es,ax
  mov ax,320                    {Offset = Y*320 + X}
  mul y
  add ax,x
  mov di,ax                     {Offset laden}
  mov al,byte ptr col           {Farbe laden}
  mov es:[di],al                {und Punkt setzen}
End;
procedure grafik ;

var grDriver, grMode : Integer;
BEGIN
asm
mov ax,13h
int 10h
end

end;



procedure makesin;
var i : word;
const
kb   = (Pi/180);

BEGIN
for i := 0 to 449 do BEGIN
sinus[i] := round(sin(i*kb)*120);
end;
end;









procedure Landscape;
var a : integer;
    x: shortint;z: shortint;
BEGIN
for x := -6 to 8 do BEGIN
for z := -6 to 8 do BEGIN
y[x, z] := trunc(sinus[(x+6)*24+welle]*sinus[land div 2]-sinus[(z+6)*24]*sinus[(land+89)div 2]+120) div 210;
end;
end;
end;

procedure Rotation;
const Zoom = 500;
      dis  = 1190;
var a,rz,rx : integer;
    x,z,farbe: shortint;
    crotX,crotY,srotX,srotY,bz: real;

BEGIN
crotX:=sinus[rotX+90]/120;srotX:=sinus[rotX]/120;
crotY:=sinus[rotY+90]/120;srotY:=sinus[rotY]/120;

for x := -6 to 8 do BEGIN
 for z := -6 to 7 do BEGIN
  putpixel(bx[x,z],by[x,z],0);
   rz:=(Z+1)*24;rx:=X*24;
    bz :=srotX*rx-crotx*(sroty*y[x,z+1]-crotY*rz)+dis;
    bx[x,z] :=trunc((zoom/bz)*(crotX*rx+srotx*(sroty*y[x,z+1]-crotY*rz)))+180;
   by[x,z] :=trunc((zoom/bz)*(crotY*y[x,z+1]+sroty*rz))+100;
  farbe :=30-trunc((bz-1030) / 29);
 putpixel(bx[x,z],by[x,z],farbe);
end;
 end;
  end;


BEGIN
land:=0;rotX := 0;rotY := 0;w:=0;

makesin;
landscape;
    grafik;

(*SetTextStyle(defaultfont, HorizDir,4);
OutTextXY(10, 2, '3D-Sinus-Funktion');
SetTextStyle(defaultfont, HorizDir,1);
OutTextXY(490, 470, 'by Martin Hdepohl');*)

Landscape;

repeat
inc(w);
inc(rotX);

inc(rotY,1);
inc(land);
welle := trunc(sinus[rotY]/2.8)+45 ;
if rotx >= 360 then rotx := 0;
if roty >= 360 then roty := 0;
if land = 719 then land := 0;
Landscape;
rotation;
until keypressed;
  TextMode(3);

end.


