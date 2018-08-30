Uses Crt,Gif,ModeXLib,Sprites;

Const Sprite_Anzahl=3;          {Anzahl im Programm verwendeter Sprites}

Var Sprite:Array[1..Sprite_Anzahl] of SpriteTyp;
                                {Daten-Records der Sprites}
    i:Word;                     {ZÑhler}

Begin
  Init_ModeX;                   {Mode X einschalten}
  LoadGif('sprites');           {Bild mit den drei Sprites laden}
  GetSprite(62 +114*320,58,48,Sprite[1]);  {Koordinaten (62/114), Breite 58*48}
  GetSprite(133+114*320,58,48,Sprite[2]); {(133/114), 58*48}
  GetSprite(203+114*320,58,48,Sprite[3]); {(203/114), 58*48}
                                {die drei Sprites laden}
  LoadGif('phint');             {Hintergrundbild laden}
  p13_2_ModeX(48000,16000);     {und auf Hintergrundseite kopieren}
  With Sprite[1] do Begin       {Koordinaten und Geschwindigkeiten}
    px:=160;py:=100;            {aller drei Sprites auf (willkÅrliche Werte)}
    sx:=1;sy:=2;
  End;
  With Sprite[2] do Begin
    px:=0;py:=0;
    sx:=1;sy:=-1;
  End;
  With Sprite[3] do Begin
    px:=250;py:=150;
    sx:=-2;sy:=-1;
  End;
  Repeat
    CopyScreen(vpage,48000);    {Hintergrundbild auf aktuelle Seite}
    For i:=1 to Sprite_Anzahl do{fÅr alle 3 Sprites durchlaufen}
      With Sprite[i] do Begin
        Inc(px,sx); Inc(py,sy); {Bewegung}
        If (px < -dtx div 2)    {am linken oder rechten Rand ? -> umkehren}
          or (px > 320-dtx div 2) Then sx:=-sx;
        If (py < -dty div 2)    {am oberen oder unteren Rand ? -> umkehren}
          or (py > 200-dty div 2) Then sy:=-sy;
        PutSprite(vpage,px,py,Sprite[i]);
                                {Sprite zeichnen}
      End;
    switch;                     {auf berechnete Seite umschalten}
    WaitRetrace;                {Bildschirm darf erst nach nÑchstem Retrace}
  Until KeyPressed;             {wieder verÑndert werden}
  ReadLn;
  TextMode(3);
End.
