uses crt,graph,Gif,ModeXLib,font;




var
y : array[-6..8,-6..8] of integer;
RK   :Char;
rotX,rotY,w:word;
sinus: array[0..449] of shortint;
const
kb   = (Pi/180);

procedure grafik ;

var grDriver, grMode,ErrCode  : Integer;
begin
  grDriver := Detect;
  InitGraph(grDriver,grMode,'');
  ErrCode := GraphResult;
end;
procedure makesin;
var i : word;
begin
for i := 0 to 449 do begin
sinus[i] := round(sin(i*kb)*120);
end;
end;


procedure scroll;
Var i:Word;
Begin
LoadGif('pfont4');            {Zeichensatz laden}
  p13_2_ModeX(48000,16000);     {und auf Seite 3 kopieren}
      CopyScreen(vpage,16000*2);

  switch;

  Repeat
    WaitRetrace;                {Synchronisation}
    Scrl_Move;                  {sichtbaren Teil nach rechts bewegen}
    Scrl_Append;                {rechts neue Spalte anh„ngen}
  Until KeyPressed;
  TextMode(3);
End;





procedure Landscape;
var a : integer;
    x: shortint;
    z: shortint;
begin
for x := -6 to 8 do begin
for z := -6 to 8 do begin
Y[x, z] := trunc(sinus[(x+6)*24]*sinus[rotY]-sinus[(z+6)*24]*sinus[rotX]+120) div 180;
end;
end;
end;

procedure Rotation;
var a : integer;
    x,z: shortint;
    bx: integer;
    by: integer;
    bx2: integer;
    by2: integer;
    crotX,crotY,srotX,srotY: real;
begin
crotX:=sinus[rotX+90]/120;srotX:=sinus[rotX]/120;
crotY:=sinus[rotY+90]/120;srotY:=sinus[rotY]/120;
for x := -6 to 8 do begin
for z := -6 to 7 do begin
bx :=trunc(crotX*((x)*24)+srotx*(sroty*y[(x),(z+1)]-crotY*((z+1)*24)));
by :=trunc(crotY*y[(x),(z+1)]+sroty*((z+1)*24));
bx2 :=trunc(crotX*((x)*24)+srotx*(sroty*y[(x),(z)]-crotY*((z)*24)));
by2 :=trunc(crotY*y[(x),(z)]+sroty*((z)*24));
line (bx+320,by+260,bx2+320,by2+260);
bx :=trunc(crotX*((z+1)*24)+srotx*(sroty*y[z+1,(x)]-crotY*(x*24)));
by :=trunc(crotY*y[(z+1),x]+sroty*(x*24));
bx2 :=trunc(crotX*(z*24)+srotx*(sroty*y[z,x]-crotY*(x*24)));
by2 :=trunc(crotY*y[z,x]+sroty*(x*24));
line (bx+320,by+260,bx2+320,by2+260);
end;
end;
end;


begin
rotX := 0;rotY := 0;w:=0;

makesin;
landscape;
  Init_ModeX;                   {Mode X initialisieren}
  LoadGif('fract001');             {erstes Bild (Hintergrund) laden}
  p13_2_modex(16000*2,16000);   {Hintergrund auf VGA-Seite 2}
  SetStart(16000*2);              {Hintergrund anzeigen}
  readln;
  scroll;
    grafik;

SetTextStyle(defaultfont, HorizDir,4);
OutTextXY(10, 2, '3D-Sinus-Funktion');
SetTextStyle(defaultfont, HorizDir,1);
OutTextXY(490, 470, 'by Martin Hdepohl');

Landscape;

repeat
setcolor(black);
inc(w);
rotation;
inc(rotX,4);
inc(rotY,1);
if rotx = 360 then rotx := 0;
if roty = 360 then roty := 0;

Landscape;
setcolor(13);
rotation;
until (w > 400);
end.
