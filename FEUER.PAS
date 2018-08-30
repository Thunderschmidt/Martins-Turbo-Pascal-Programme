uses crt;
var col: array[0..200] of byte;
    x,y: integer;
    wait: longint;

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
begin
asm
mov ax,13h
int 10h
end
end;


Procedure  Doit;

var                  Dots:Array[0..320,100..200] of byte;
    i : byte;
    X,Y : integer;


begin
randomize;
for i := 1 to 100 do Dots[random(320),200]:=70;

for Y := 199 downto 101 do begin

for X  := 1 to 319 do begin

dots[X,Y]:=(Dots[X-1,Y+1]+dots[X+1,Y+1]) div 2;
putpixel (x,y,dots[X,Y]);


end;
end;
end;
begin

grafik;
doit;
repeat until keypressed;
textmode(3);
end.
