program Astro;
uses graph, crt;
const kb = pi /180;
      radius = 30;
      zoom = 600;
      dept = 800;
var rot : real;
    XE,YE,XM,YM,ZM,Mx,My,Ex,Ey : array[0..359] of integer;
    papa,ende : boolean;
    ch : char;
    pm : byte;
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
Xm[i]:=trunc(sin(pm*kb)*(Xe[i]+cos(I*kb)*(sin(I*12*kb)*radius))+cos(pm*kb)*(Xe[i]+(cos(I*13*kb)*30)));
Ym[i]:=trunc(sin(pm*kb)*(Ye[i]+sin(I*kb)*(sin(I*12*kb)*radius))+cos(pm*kb)*(Ye[i]+(sin(I*13*kb)*30)));
Zm[i]:=trunc(sin(PM*kb)*(cos(I*12*kb)*radius));
end;
end;

procedure Ausgabe(rot:real;Cm:byte;Ce:byte);
var I,MZ,EZ: integer;
    srot,crot,lsrot,lcrot : real;
begin
randomize;
ende:=false;
papa := true;
rot :=0;
lsrot:=0;
lcrot:=0;
repeat
rot := rot+0.02;
srot :=sin(rot);
crot :=cos(rot);
for I := 0 to 359 do begin

putpixel(MX[i],MY[i],0);putpixel(EX[i],EY[i],0);

EZ:=trunc(srot*Xe[i])+dept;
EX[i]:=trunc(crot*Xe[i]*(zoom/ez))+320;
EY[i]:=trunc(Ye[i]*(zoom/ez))+240;
MZ:=trunc(srot*Xm[i]-crot*Zm[i])+dept;
MX[i]:=trunc((crot*xm[i]+srot*zm[i])*(zoom/mz))+320;
MY[i]:=trunc(Ym[i]*(zoom/mz))+240;
putpixel(MX[i],MY[i],Cm);putpixel(EX[i],EY[i],Ce);
putpixel(320,240,yellow);
end;
lsrot:=srot;
lcrot:=crot;
if papa then begin
if keypressed then begin
PM:=90;
Makescape;
papa:=false;
end;
end;
until ende;
end;

begin
pm :=0;
graf;
makescape;
Ausgabe(rot,15,1);
end.