Uses Crt,ModeXLib,Gif,var_3d;

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
    ($fee0,4, 0,2,6,4,
     $fec0,4, 0,1,3,2,
     $fec0,4, 4,6,7,5,
     $fee0,4, 1,5,7,3,
     $fec0,4, 2,3,7,6,
     $fec0,4, 0,4,5,1,0,0);
    { $fe = Lichtquelle benutzen, Grundfarbe im Low-Byte}

Var
    i,j:Word;

Procedure Schatt_Pal;           {Palette auf Schattierung vorbereiten}
Begin
  For j:=192 to 223 do Begin    {Farben 192 - 223 und 224 - 255 vorbereiten}
    i:=trunc((j/32)*43);        {Helligkeit ermitteln}
    Fillchar(Palette[j*3],3,i+20);  {Farben 192-223 auf Grauwerte}

    Palette[(j+32)*3]:=i+20;    {Farben 224-255 auf Rotwerte}
    Palette[(j+32)*3+1]:=0;
    Palette[(j+32)*3+2]:=0;
  End;
  Setpal;                       {Diese Palette setzen}
End;

procedure drawworld;external;   {zeichnet die Welt auf akt. Bildschirmseite}
{$l 3dasm.obj}
{$l poly.obj}
{$l bres.obj}
{$l wurzel.obj}

Begin
  vz:=1000;                     {Kîrper befindet sich bei 1000 Einh. Tiefe}
  vpage:=0;                     {mit Seite 0 beginnen}
  LoadGif('logor.gif');         {Hintergrundbild laden}
  init_modex;                   {ModeX einschalten}
  Schatt_Pal;                   {Schattier-Palette berechnen}
  rotx:=0;                      {Startwerte fÅr Rotation}
  roty:=0;
  rotz:=0;
  Fuellen:=true;                {FlÑchenfÅllen ein}
  fl_sort:=true;                {FlÑchensortierung ein}
  fl_ruecken:=true;             {FlÑchenrÅckeunterdrÅckung ein}
  Glas:=false;                  {Glas-OberflÑchen aus}
  p13_2_modex(16000*2,16000);   {Hintergrund auf VGA-Seite 2}
  repeat
    CopyScreen(vpage,16000*2);  {Hintergrundbild auf aktuelle Seite}
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
