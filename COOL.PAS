program cool;
uses crt, graph, joystick;
var

  grDriver : Integer;
  grMode   : Integer;
  ErrCode  : Integer;
  x        : array[1..8, 1..2] of integer;
  y        : array[1..8, 1..2] of integer;
  z        : array[1..8, 1..2] of integer;
  xs       : array[1..100] of integer;
  ys       : array[1..100] of integer;
  a        : real;
  k        : word;
  b        : integer;
  c        : longint;
  ze       : real;
  zo       : real;
  m        : real;
  n        : real;
  begin
  grDriver := Detect;
  InitGraph(grDriver,grMode,'');
  ErrCode := GraphResult;
  if ErrCode = grOk then

    begin
  randomize;
  x[1,1]:=-340; y[1,1]:=-40; z[1,1]:=-20;  x[1,2]:=-340; y[1,2]:=0; z[1,2]:=-20;
  x[2,1]:=-340; y[2,1]:=-40; z[2,1]:=-20;  x[2,2]:=-340; y[2,2]:=-20; z[2,2]:=40;
  x[3,1]:=-340; y[3,1]:=0; z[3,1]:=-20;  x[3,2]:=-340; y[3,2]:=-20; z[3,2]:=40;

  x[4,1]:=340; y[4,1]:=-40; z[4,1]:=-20;  x[4,2]:=340; y[4,2]:=0; z[4,2]:=-20;
  x[5,1]:=340; y[5,1]:=-40; z[5,1]:=-20;  x[5,2]:=340; y[5,2]:=-20; z[5,2]:=40;
  x[6,1]:=340; y[6,1]:=0; z[6,1]:=-20;  x[6,2]:=340; y[6,2]:=-20; z[6,2]:=40;

end;
k:=0;
  for b := 1 to 100 do
begin
  xs[b]:=random(640);
  ys[b]:=random(480);
end;
             setcolor(1);
repeat
             a := 20;
             m :=0{random(100)/50-1;};

while a < 1000 do begin
k := k + 1;
if k=2*640 then k:=0;
  for b := 1 to 100 do
begin
  putpixel(trunc(xs[b]+0.5*k-1), ys[b], black);
  putpixel(trunc(xs[b]+0.5*k), ys[b], white);
  putpixel(trunc(xs[b]+0.5*k-1-640), ys[b], black);
  putpixel(trunc(xs[b]+0.5*k-640), ys[b], white);

end;

circle(320, 240, 10);
{line(308,228, 314, 234);}
             a := a+5;
for b := 1 to 6 do begin
             ze:=22/(z[b, 1]+a);
             zo:=22/(z[b, 2]+a);
             setcolor(0);
             line(trunc(x[b, 1]*ze+330-m*a+0.1*a), trunc(y[b, 1]*ze)+240,
                  trunc(x[b, 2]*zo+330-m*a+0.1*a), trunc(y[b, 2]*zo)+240);
             ze:=22/(z[b, 1]+a+5);
             zo:=22/(z[b, 2]+a+5);
             
             setcolor(7);
             line(trunc(x[b, 1]*ze+330-m*(a+1)+0.1*a+0.5), trunc(y[b, 1]*ze)+240,
                  trunc(x[b, 2]*zo+330-m*(a+1)+0.1*a+0.5), trunc(y[b, 2]*zo)+240);
            { for c := 1 to 2000
             do begin end;     }
end;
end;

for b := 1 to 6 do begin
             ze:=22/(z[b, 1]+a+5);
             zo:=22/(z[b, 2]+a+5);
             setcolor(0);
             line(trunc(x[b, 1]*ze+330-m*(a+1)+0.1*a+0.5), trunc(y[b, 1]*ze)+240,
                  trunc(x[b, 2]*zo+330-m*(a+1)+0.1*a+0.5), trunc(y[b, 2]*zo)+240);
             ze:=22/(z[b, 1]+a+0.5);
end;

            a := 20;
while a < 1000 do begin
  k:=k+1;
if k=2*640 then k:=0;
  for b := 1 to 100 do
begin
  putpixel(trunc(xs[b]+0.5*k-1), ys[b], black);
  putpixel(trunc(xs[b]+0.5*k), ys[b], white);
  putpixel(trunc(xs[b]+0.5*k-1-640), ys[b], black);
  putpixel(trunc(xs[b]+0.5*k-640), ys[b], white);

end;
             setcolor(7);
circle(320, 240, 10);
             a := a+5;
for b := 1 to 6 do begin
             ze:=22/(z[b, 1]+a);
             zo:=22/(z[b, 2]+a);
             setcolor(0);
             line(trunc(x[b, 1]*ze+310-m*a+0.1*a), trunc(y[b, 1]*ze)+240,
                  trunc(x[b, 2]*zo+310-m*a+0.1*a), trunc(y[b, 2]*zo)+240);
             ze:=22/(z[b, 1]+a+5);
             zo:=22/(z[b, 2]+a+5);
             setcolor(7);
             line(trunc(x[b, 1]*ze+310-m*(a+1)+0.1*a+0.5), trunc(y[b, 1]*ze)+240,
                  trunc(x[b, 2]*zo+310-m*(a+1)+0.1*a+0.5), trunc(y[b, 2]*zo)+240);
             {for c := 1 to 2000
             do begin end;  }
end;
end;
for b := 1 to 6 do begin
             ze:=22/(z[b, 1]+a+5);
             zo:=22/(z[b, 2]+a+5);
             setcolor(0);
             line(trunc(x[b, 1]*ze+310-m*(a+1)+0.1*a+0.5), trunc(y[b, 1]*ze)+240,
                  trunc(x[b, 2]*zo+310-m*(a+1)+0.1*a+0.5), trunc(y[b, 2]*zo)+240);
             ze:=22/(z[b, 1]+a+0.5);
end;

 
 until keypressed;

end.