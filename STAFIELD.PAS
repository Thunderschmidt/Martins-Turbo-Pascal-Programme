Program Starfield;                

uses  Graph, crt;          {ôffnen der Units Graph und Crt}

var                                       {Variablendefinition}
  grDriver : Integer;                     {Grafikvariablen}
  grMode   : Integer;
  ErrCode,e  : Integer;
  b        : byte;                        {b=Punkt Nr....}
  a        : real;                        {a=Gradzahl}
  c        : longint;                     {c=Variable fÅr Wartschleife}
  x        : array[0..100]  of integer;   {Feldvariablen fÅr X, Y, Z}
  y        : array[0..100]  of integer;
  z        : array[0..100]  of integer;

begin
  grDriver := Detect;                  {Grafikinitialisierung}
  InitGraph(grDriver,grMode,'');
  ErrCode := GraphResult;
  if ErrCode = grOk then

    randomize;                       {Aktivierung des Zufallgenerators}

    for b := 1 to 100 do
    begin
    x[b] := (random(600)+1-300);    {Positionen der Punkte werden erfunden}
    y[b] := (random(480));
    z[b] := (random(600)+1-300);
   end;

    a := 0;    e := 0;

    repeat
    if a = 360 then  a:= 0;              {Rotation 0..360}
    if e = 480 then  e:= 0;              {Rotation 0..360}

    a := a + 0.01;                      {ZÑhler}
    e:=e+2;
    for b := 1 to 100 do
    begin
                              {Punktradierung}

    putpixel(trunc(sin(a-0.01)*x[b]+cos(a-0.01)*z[b])+320, y[b]+e-2-480, black);

    putpixel(trunc(sin(a)*x[b]+cos(a)*z[b])+320, y[b]+e-480, white);
    putpixel(trunc(sin(a-0.01)*x[b]+cos(a-0.01)*z[b])+320, y[b]+e-2, black);

    putpixel(trunc(sin(a)*x[b]+cos(a)*z[b])+320, y[b]+e, white);

   end;
   for c := 1 to 2000 do begin end;     {Warteschleife}

   until keypressed;

repeat until keypressed;

     CloseGraph;

end.
