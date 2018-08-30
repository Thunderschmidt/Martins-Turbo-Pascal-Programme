uses crt,graph;
type Startype=array[0..255] of record x,y,z: integer;end;
var
    sterne : Startype;

    e    :                        byte;          {Index}

procedure graf;
var grDriver , grMode :       Integer;    {InitGraph (640*480*16)}
begin
    grDriver := Detect;
  InitGraph(grDriver,grMode,'c:\dosprg\tp\bgi');

end;

procedure starfield;                    {generiert Sternenhintergrund}

begin
randomize;
for e:=0 to 255 do begin
with sterne[e] do begin
z:=random(380)+20;
x := random(2400)-1200;
y := random(1700)-950;
end;
end
end;

Procedure Pixel;                       { Sternenscroller}
var farbe: byte;
begin
for e:= 0 to 255 do
with sterne[e] do begin
putpixel(trunc((50/z)*x)+320,240-trunc((50/z)* y), black);

z := z - 2;
{if (((50/z)*x)<-320) or (((50/z)*x) > 320) or (((50/z)*y) > 240) or (((50/z)*y) < -240) then begin}
if z < 30 then     begin
z := 400;
x := random(4800)-2400;
y := random(3400)-1700;
end;
if z  < 150 then farbe := 15;
if z  > 150 then farbe := 7;
if z  > 300  then farbe := 8;

putpixel(trunc((50/z)*x)+320,240-trunc((50/z)* y), farbe);
end;
end;

begin
graf;
starfield;
repeat
pixel;
until keypressed;
closegraph;
end.