program Astro;
uses graph, crt;
const kb = pi /180;
      r = 8;
var rot : real;
    XE,YE,XM,YM,ZM,Mx,My,Ex,Ey : array[0..359] of integer;


procedure graf;
var grDriver , grMode :       Integer;    {InitGraph (640*480*16)}
begin
    grDriver := Detect;
  InitGraph(grDriver,grMode,'c:\tp');
end;
procedure MakeScape;
var I : integer;
begin
for I := -1 to 359 do begin;

Xe[i]:=trunc(cos(I*kb)*210);
Ye[i]:=trunc(sin(I*kb)*210);
Xm[i]:=trunc(Xe[i]+(cos(I*12*kb)*r));
Ym[i]:=trunc(Ye[i]+(sin(I*12*kb)*r));
Zm[i]:=0;
end;
end;


procedure Ausgabe(rot:real;Cm:byte;Ce:byte);
var I,MZ,EZ: integer;
    srot,crot,lsrot,lcrot : real;
begin
rot :=0;
lsrot:=0;
lcrot:=0;
repeat
rot := rot+0.02;
srot :=sin(rot);
crot :=cos(rot);
for I := 0 to 359 do begin

putpixel(MX[i],MY[i],0);putpixel(EX[i],EY[i],0);

EZ:=trunc(srot*Xe[i])+800;
EX[i]:=trunc(crot*Xe[i]*(800/ez))+320;
EY[i]:=trunc(Ye[i]*(800/ez))+240;
MZ:=trunc(srot*Xm[i]-crot*Zm[i])+800;
MX[i]:=trunc((crot*xm[i]+srot*zm[i])*(800/mz))+320;
MY[i]:=trunc(Ym[i]*(800/mz))+240;
putpixel(MX[i],MY[i],Cm);putpixel(EX[i],EY[i],Ce);

end;
lsrot:=srot;
lcrot:=crot;
until keypressed;
end;

begin
graf;
makescape;
Ausgabe(rot,15,1);
end.