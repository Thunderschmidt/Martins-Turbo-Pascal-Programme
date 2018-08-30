
uses crt, graph,joystick;
type JoyType=record X,Y : integer;b1,b2,b3,b4:boolean;END;

var
    x, y, z                  : array[ 1..2,1..24] of shortint;
    no, e,b,kX,kY    :                        byte;          {Index}
    xp1,xp2,yp1,yp2 :array[1..24] of integer;
const
                   g  = 15 ;         {g=Vergrî·erung}
                    di = 120;           {di=Distanz des Objektes}
                     f  = 50;          {Zoom}
                      xv = 320;
                       yv = 240;          {xv, yv : Verschiebung}
                        kb = pi/180;
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
  assign(t, 'c:\tp\cobra2.dat');
   reset(t);readln(t,a);readln(t,a);
repeat
 inc(b);
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

procedure rotate(rotX,rotY,rotZ: real);
    var
    zp1, zp2,srotY,crotY,srotX,crotX,srotZ,crotZ:                     real;
BEGIN
 SrotY:=Sin(rotY); CrotY:=Cos(rotY);
  SrotX:=Sin(rotX); CrotX:=Cos(rotX);
   SrotZ:=Sin(rotZ); CrotZ:=Cos(rotZ);     {Sin & Cos-Berechnungen}
for e := 1 to 24 do
BEGIN
 setcolor(0); LINE (xp1[e],yp1[e],xp2[e],yp2[e]);   {Lîschen}
  zp1:=srotY*x[1,e]-crotY*(srotX*z[1,e]+crotX*y[1,e])+di;
 xp1[e]:=trunc((f/zp1)*(CrotZ*(crotY*x[1,e]+srotY*(srotX*y[1, e]-crotX*z[1, e]))-srotZ*(crotX*y[1,e]+srotX*z[1,e]))*g)+xv;
yp1[e]:=yv-trunc((f/zp1)*(CrotZ*((crotX*y[1,e]+srotX*z[1, e]))+srotZ*(crotY*x[1,e]+srotY*(srotX*y[1,e]-crotX*z[1,e])))*g);
  zp2:=srotY*x[2,e]-crotY*(srotX*z[2,e]+crotX*y[2,e])+di;
 xp2[e]:=trunc((f/zp2)*(CrotZ*(crotY*x[2, e]+srotY*(srotX*y[2,e]-crotX*z[2,e]))-srotZ*(crotX*(y[2,e])+srotX*z[2,e]))*g)+xv;
yp2[e]:=yv-trunc((f/zp2)*(CrotZ*(crotX*y[2, e]+srotX*z[2, e])+srotZ*(crotY*x[2,e]+srotY*(srotX*y[2, e]-crotX*z[2,e])))*g);
setcolor(7);LINE (xp1[e],yp1[e],xp2[e],yp2[e]);    {Zeichnen}
  END;
END;

Procedure JoyAbfrage;
var Joy                : joytype;
    rotY, rotX, rotZ    : real;
    xt,yt : shortint;
BEGIN
 rotY :=0;rotX:=0;rotZ:=0;
  repeat
   with joy do
BEGIN
 joykoor(x,y);
  xt :=x-kx;yt :=y-ky;
  if (xt < -10) or (xt > 10) or (yt< -10) or (yt > 10) then
BEGIN
 rotX:= rotX+ yt/1000;
  joybutton(b1,b2,b3,b4);
   if b3 = true then begin
   rotY :=rotY+sin(rotX)*(xt/1000);
   rotZ :=rotZ+cos(rotX)*(xt/1000);
   end
   else begin
   rotY :=rotY+cos(rotZ)*(xt/1000);
   rotZ :=rotZ+sin(rotZ)*(xt/1000);
    end;

    rotate(rotX,rotY,rotZ);
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