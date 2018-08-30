Uses Crt,ModeXLib,var_3d;

Const
    worldlen=8*3;               {Punkte-Array}
    Worldconst:Array[0..worldlen-1] of Integer =
    (-200,-200,-200,
    -200,-200,200,
    -200,200,-200,
    -200,200,200,
    200,-200,-200,
    200,-200,200,
    200,200,-200,
    200,200,200);
    surfclen=38;                {FlÑchen-Array}
    surfcconst:Array[0..surfclen-1] of Word=
    (01,4, 0,2,6,4,
     02,4, 0,1,3,2,
     04,4, 4,6,7,5,
     08,4, 1,5,7,3,
     16,4, 2,3,7,6,
     32,4, 0,4,5,1,0,0);

Var
    i,j:Word;

Procedure Glas_Pal;
{bereitet die Palette auf Glas-Kîrper vor}
Begin
  FillChar(Palette[3],765,63);  {zunÑchst alle Farben wei·}
  For i:=1 to 255 do Begin      {255 Mischfarben bestimmen}
    If i and 1 = 1 Then Dec(Palette[i*3],16);
    If i and 2 = 2 Then Dec(Palette[i*3+1],16);
    If i and 4 = 4 Then Dec(Palette[i*3+2],16);
    If i and 8 = 8 Then Begin
                          Dec(Palette[i*3],16);
                          Dec(Palette[i*3+1],16);
                        End;
    If i and 16 = 16 Then Begin
                          Dec(Palette[i*3],16);
                          Dec(Palette[i*3+2],16);
                        End;
    If i and 32 = 32 Then Begin
                          Dec(Palette[i*3+1],16);
                          Dec(Palette[i*3+2],16);
                        End;
  End;
  SetPal;
End;

procedure drawworld;external;   {zeichnet die Welt auf akt. Bildschirmseite}
{$l 3dasm.obj}
{$l poly.obj}
{$l bres.obj}
{$l wurzel.obj}

Begin
  vz:=1000;                     {Kîrper befindet sich bei 1000 Einh. Tiefe}
  vpage:=0;                     {mit Seite 0 beginnen}
  init_modex;                   {ModeX einschalten}
  Glas_Pal;
  rotx:=0;                      {Startwerte fÅr Rotation}
  roty:=0;
  rotz:=0;
  Fuellen:=true;                {FlÑchenfÅllen ein}
  fl_sort:=false;               {FlÑchensortierung aus}
  fl_ruecken:=false;            {FlÑchenrÅckeunterdrÅckung aus}
  Glas:=true;                   {Glas-OberflÑchen ein}
  repeat
    clrx($0f);                  {Bildschirm lîschen}
    DrawWorld;                  {Welt zeichnen}
    switch;                     {auf fertiges Bild schalten}
    WaitRetrace;                {nÑchsten Retrace abwarten}
    Inc(rotx);                  {weiterrotieren ... }
    If rotx=120 Then rotx:=0;
    Inc(rotz);
    If rotz=120 Then rotz:=0;
    inc(roty);
    if roty=120 Then roty:=0;
  Until KeyPressed;             { ... bis Taste}
  TextMode(3);
End.
