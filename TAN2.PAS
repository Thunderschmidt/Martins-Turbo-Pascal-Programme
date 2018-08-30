uses crt,graph;




var
y : array[-6..8,-6..8] of integer;
RK   :Char;
rotX,rotY,w,land:word;
sinus: array[0..449] of shortint;
welle,color : byte;
    bx,by: array[-6..8,-6..8] of integer;


const
kb   = (Pi/180);

procedure grafik ;

var grDriver, grMode : Integer;
begin
  grDriver := Detect;
  InitGraph(grDriver,grMode,'C:\DOSPRG\TP\BGI');
end;
procedure makesin;
var i : word;
begin
for i := 0 to 449 do begin
sinus[i] := round(sin(i*kb)*120);
end;
end;









procedure Landscape;
var a : integer;
    x: shortint;
    z: shortint;
begin
for x := -6 to 8 do begin
for z := -6 to 8 do begin
y[x, z] := trunc(sinus[(x+6)*24+welle]*sinus[land div 2]-sinus[(z+6)*24]*sinus[(land+89)div 2]+120) div 210;
end;
end;
end;

procedure Rotation;
var a : integer;
    x,z,farbe: shortint;
    crotX,crotY,srotX,srotY,bz: real;

begin
crotX:=sinus[rotX+90]/120;srotX:=sinus[rotX]/120;
crotY:=sinus[rotY+90]/120;srotY:=sinus[rotY]/120;
for x := -6 to 8 do begin
for z := -6 to 7 do begin
putpixel(bx[x,z]+320,by[x,z]+260,black);
putpixel(bx[x,z]+321,by[x,z]+260,black);

bz :=srotX*((x)*24)-crotx*(sroty*y[(x),(z+1)]-crotY*((z+1)*24))+500;
bx[x,z] :=trunc((500/bz)*(crotX*((x)*24)+srotx*(sroty*y[(x),(z+1)]-crotY*((z+1)*24))));
by[x,z] :=trunc((500/bz)*(crotY*y[(x),(z+1)]+sroty*((z+1)*24)));
if bz  < 500 then farbe := 15;
if bz  > 500 then farbe := 7;
if bz  > 600  then farbe := 8;
putpixel(bx[x,z]+320,by[x,z]+260,farbe);
putpixel(bx[x,z]+321,by[x,z]+260,farbe);
end;
end;
end;


begin
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
closegraph;
end.
