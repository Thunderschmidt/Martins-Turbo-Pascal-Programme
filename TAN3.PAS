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

Var Sterne:Array[0..500] of Record
                              x,y,Ebene:Integer;
                            End;
  st_nr:Word;

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
begin
asm
mov ax,13h
int 10h
end

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
putpixel(bx[x,z]+180,by[x,z]+100,0);

bz :=srotX*((x)*24)-crotx*(sroty*y[(x),(z+1)]-crotY*((z+1)*24))+1190;
bx[x,z] :=trunc((500/bz)*(crotX*((x)*24)+srotx*(sroty*y[(x),(z+1)]-crotY*((z+1)*24))));
by[x,z] :=trunc((500/bz)*(crotY*y[(x),(z+1)]+sroty*((z+1)*24)));
farbe :=30-(trunc(((bz-1030)/29)));
{writeln(trunc(bz), '  ',farbe);
if farbe > 31 then writeln('Åber 31 !!!!!!!!!');
if farbe < 16 then writeln('unter 16 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');}
putpixel(bx[x,z]+180,by[x,z]+100,farbe);
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
OutTextXY(490, 470, 'by Martin HÅdepohl');*)

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
