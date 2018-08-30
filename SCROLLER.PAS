Uses Crt;
var sterne : array[0..300] of record
                    x,y,ebene: integer;
                    end;
st_nr,c : word;

procedure putpixel(x,y,col:word) ; assembler;
asm
mov ax, 0a000h
mov es,ax
mov ax,320
mul y
add ax,x
mov di, ax
mov al, byte ptr col
mov es:[di],al
end;

begin
Randomize;
asm mov ax,13h; int 10h end;
repeat
for st_nr := 0 to 300 do begin
 with Sterne[st_nr] do begin
 putpixel (x,y,0);
   dec(x,ebene shr 5+1);
    if x <= 0 then Begin
    x:=319;
    Y:=random(200);
    ebene:=random(256);
    end;
    putpixel (x,y,ebene shr 4 + 16);
   for c := 1 to 2000 do begin end;
   end;
 end;
 until keypressed;
 end.
