
uses crt, graph,joystick;
type JoyType=record X,Y : integer;b1,b2,b3,b4:boolean;END;

var
    x, y, z                  : array[ 1..2,1..24] of shortint;
    no, e,b,kX,kY    :                        byte;          {Index}
    xp1,xp2,yp1,yp2 :array[1..24] of integer;
const
                   g  = 10 ;         {g=Vergrî·erung}
                    di = 100;           {di=Distanz des Objektes}
                     f  = 44.5;          {Zoom}
                      xv = 320;
                       yv = 240;          {xv, yv : Verschiebung}
(********************************************************************)
procedure center;
var Joy : JoyType;
BEGIN
 clrscr;
  writeln('Bitte zentrieren sie ihren Joystick und drÅcken sie einen Knopf.');
   with joy do BEGIN
    repeat
     JoyButton(b1, b2, b3, b4);
      until not b1 or not b2 or not b3 or not b4;
       JoyKoor(X, Y);
  END;
 kX := Joy.X; kY := Joy.Y;
END;

procedure datlese;
var                    
     er,aha : integer;
      t  : text;
       a  : string;
       s,n,l: byte;
BEGIN
 b:=0;
  assign(t, 'c:\dosprg\tp\cobra2.dat');
   reset(t);readln(t,a);readln(t,a);
repeat
 b := b + 1;
 readln(t, a);
  val(a, aha, er);x[1,b]:=aha div 5;
  readln(t, a);
   val(a, aha, er);y[1,b]:=aha div 5;
   readln(t, a);
    val(a, aha, er);z[1,b]:=aha div 5;
    readln(t, a);
     val(a, aha, er);x[2,b]:=aha div 5;
     readln(t, a);
      val(a, aha, er);y[2,b]:=aha div 5;
      readln(t, a);
       val(a, aha, er);z[2,b]:=aha div 5;
       readln(t, a);
        until eof(t);
END;

procedure grafik;
var grDriver , grMode :       Integer;    {InitGraph (640*480*16)}
BEGIN
    grDriver := Detect;
  InitGraph(grDriver,grMode,'c:\tp');
END;

procedure rotate(rot,rot2,rot3: real);
    var
    zp1, zp2,srot,crot,srot2,crot2,srot3,crot3:                     real;
BEGIN
 Srot:=Sin(rot); Crot:=Cos(rot);
  Srot2:=Sin(rot2); Crot2:=Cos(rot2);
   Srot3:=Sin(rot3); Crot3:=Cos(rot3);     {Sin & Cos-Berechnungen}
for e := 1 to 24 do
BEGIN
 setcolor(0); LINE (xp1[e],yp1[e],xp2[e],yp2[e]);   {Lîschen}
  zp1:=srot*x[1,e]-crot*(srot2*z[1,e]+crot2*y[1,e])+di;
 xp1[e]:=trunc((f/zp1)*(Crot3*(crot*x[1,e]+srot*(srot2*y[1, e]-crot2*z[1, e]))-srot3*(crot2*y[1,e]+srot2*z[1,e]))*g)+xv;
yp1[e]:=yv-trunc((f/zp1)*(Crot3*((crot2*y[1,e]+srot2*z[1, e]))+srot3*(crot*x[1,e]+srot*(srot2*y[1,e]-crot2*z[1,e])))*g);
  zp2:=srot*x[2,e]-crot*(srot2*z[2,e]+crot2*y[2,e])+di;
 xp2[e]:=trunc((f/zp2)*(Crot3*(crot*x[2, e]+srot*(srot2*y[2,e]-crot2*z[2,e]))-srot3*(crot2*(y[2,e])+srot2*z[2,e]))*g)+xv;
yp2[e]:=yv-trunc((f/zp2)*(Crot3*(crot2*y[2, e]+srot2*z[2, e])+srot3*(crot*x[2,e]+srot*(srot2*y[2, e]-crot2*z[2,e])))*g);
setcolor(7);LINE (xp1[e],yp1[e],xp2[e],yp2[e]);    {Zeichnen}
  END;
END;

Procedure JoyAbfrage;
var Joy                : joytype;
    rot, rot2, rot3    : real;
BEGIN
 rot :=0;rot2:=0;
  repeat
   with joy do
BEGIN
 joykoor(x,y);
  if (x - kX < -10) or (x - kX > 10) or (y - kY < -10) or (y - kY > 10) then
BEGIN
 rot2:= rot2+ (y-kY)/1000;
  joybutton(b1,b2,b3,b4);
   if b2 = true then rot := rot + (x-kX)/1000 else rot3 := rot3 + (x-kX)/1000;
    rotate(rot,rot2,rot3);
   END;
  END;
 until keypressed;
END;

BEGIN                                      {Main}
 Datlese;
  Center;
   Grafik;
    JoyAbfrage;
     Closegraph;
END.