Program stars;
uses crt, graph;

var
    x        : array[1..200] of integer;
    y        : array[1..200] of integer;
    grDriver :                  Integer;
    grMode   :                  Integer;
    ErrCode  :                  Integer;
    a        :                     byte;
    b        :                  integer;
  procedure graf;
  begin
  grDriver := Detect;
  InitGraph(grDriver,grMode,'');
  ErrCode := GraphResult;
  end;

  procedure randomizing;
  begin
  randomize;
  for a := 1 to 200 do
begin
  x[a]:=random(640);
  y[a]:=random(480);
end;
end;
procedure ausgabe;
begin
repeat
if b=640 then b:=0;
b:=b+1;
  for a := 1 to 200 do
begin
  putpixel(x[a]+b-1, y[a], black);
  putpixel(x[a]+b, y[a], white);
  putpixel(x[a]+b-1-640, y[a], black);
  putpixel(x[a]+b-640, y[a], white);
end;
until keypressed;
end;

begin
graf;
randomizing;
ausgabe;

end.