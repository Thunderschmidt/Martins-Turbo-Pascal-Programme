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
    ($ff00,4, 0,2,6,4,
     $ff01,4, 0,1,3,2,
     $ff02,4, 4,6,7,5,
     $ff00,4, 1,5,7,3,
     $ff03,4, 2,3,7,6,
     $ff04,4, 0,4,5,1,0,0);

    { $ff = Texturen benutzen, Nummer im Low-Byte}

Var
    i,j:Word;

Procedure Prep_Texturen;
{Variablen der Texturen laden}
Begin
  LoadGif('Textur');            {Textur-Bild laden}
  GetMem(Txt_Pic,64000);        {Speicher dafÅr holen}
  Move(VScreen^,Txt_Pic^,64000);{und dorthin kopieren}
  For i:=0 to Txt_Anzahl-1 do Begin
    Txt_Daten[i]:=Txt_Pic;      {Zeiger auf Daten laden}
    Txt_Offs[i]:=i*64;          {Offset bestimmen}
  End;
End;

procedure drawworld;external;   {zeichnet die Welt auf akt. Bildschirmseite}
{$l 3dasm.obj}
{$l poly.obj}
{$l bres.obj}
{$l wurzel.obj}

Begin
  vz:=800;                     {Kîrper befindet sich bei 1000 Einh. Tiefe}
  vpage:=0;                     {mit Seite 0 beginnen}
  init_modex;                   {ModeX einschalten}
  Prep_Texturen;
  LoadGif('logo.gif');          {Hintergrundbild laden}
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
