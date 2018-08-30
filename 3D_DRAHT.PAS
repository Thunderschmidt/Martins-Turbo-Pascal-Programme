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
    (0,4, 0,2,6,4,
     0,4, 0,1,3,2,
     0,4, 4,6,7,5,
     0,4, 1,5,7,3,
     0,4, 2,3,7,6,
     0,4, 0,4,5,1,0,0);

Var
    i,j:Word;


procedure drawworld;external;   {zeichnet die Welt auf akt. Bildschirmseite}
{$l 3dasm.obj}
{$l poly.obj}
{$l bres.obj}
{$l wurzel.obj}

Begin
  vz:=1000;                     {Kîrper befindet sich bei 1000 Einh. Tiefe}
  vpage:=0;                     {mit Seite 0 beginnen}
  init_modex;                   {ModeX einschalten}
  rotx:=0;                      {Startwerte fÅr Rotation}
  roty:=0;
  rotz:=0;
  Fuellen:=false;               {FlÑchenfÅllen aus}
  fl_sort:=false;               {FlÑchensortierung aus}
  fl_ruecken:=false;            {FlÑchenrÅckeunterdrÅckung aus}
  Glas:=false;                  {Glas-OberflÑchen aus}
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
