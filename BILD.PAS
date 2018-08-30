uses crt;
var col: array[0..200] of byte;
    x,y: integer;
    wait: longint;
Farbe : array[0..255] of byte;




procedure Farbtabelle;
var
{Farbe : array[0..255] of byte;}
    i,f : byte;
begin
I:=0;
f:=0;

repeat
  farbe[i]:=32+f;
farbe[i+1]:=104+f;
farbe[i+2]:=176+f;
I:=I+3;
f:=f+1;
until i = 213;
for i:=214 to 229 do farbe[i]:=i-198;
for I:=229 to 255 do farbe[i]:=i-197;
end;





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
begin;
randomize;
grafik;
farbtabelle;
(*repeat*)
for Y:=0 to 200 do begin
col[y]:=random(255);
putpixel(x,y,col[y]);
end;
for x:= 1 to 319 do begin
for Y:=1 to 199 do begin

{col[y]:=trunc(x*0.75+sin(Y/10)*20+sin(x*y/1000)*15);}
{col[y]:=trunc(0.08*(x*(0.01*x/2)*(x+2))+Y*(y-100));}
{col[y]:=trunc(sin(x/200)*64+sin(Y/200)*(sin(x/100)*32+32)) +128;}
{col[y]:=trunc(sin((Y+sin(x*y/400))/400)*128+128);}
{col[y]:=trunc(cos(x*cos(y)*0.01)*sin(x*x*0.001+y*y*0.01)*127+127);}
col[y]:=farbe[trunc(x*0.8+sin(Y/10)*20+sin(x*y/800)*19)];
{col[y]:=(col[y+1]+col[y-1]+random(2)-1) div 2;}

{col[y]:=trunc(x*0.8+sin(x*y/1000)*15);}

putpixel(x,y,col[y]);
end;
end;
 for wait := 1 to 4000000 do begin end;
repeat until keypressed;
textmode(3);
end.
