Uses Crt,Gif,ModeXLib;
Var x,                          {derzeitiger Offset in x-Richtung}
    x_dir,                      {gibt Scroll Richtung fr x-an}
    y,                          {derzeitiger Offset fr y-Richtung}
    y_dir:word;                 {gibt Scroll Richtung fr y an}
Begin
  Init_ModeX;                   {Mode X einschalten}
  double;                       {160-Byte Modus ein (640*400 Punkte gesamt}
  LoadGif('640400');            {Bild laden}
  p13_2_ModeX(vram_pos,rest div 4); {Rest des Bildes in Bildschirmspeicher}
  x:=1;                         {x-Beginn mit Spalte 1}
  x_dir:=1;                     {x-Richtung 1 Byte pro Durchlauf}
  y:=160;                       {y-Beginn mit Zeile 1}
  y_dir:=160;                   {y-Richtung +160 Byte pro Durchlauf}
  Repeat
    Inc(x,x_dir);               {x-Bewegung}
    Inc(y,y_dir);               {y-Bewegung}
    WaitRetrace;                {Auf Retrace warten}
    SetStart(y+x);              {und neuen Start in Register schreiben}
    if (x >= 80)                {x-Rand erreicht -> x-Richtung umdrehen}
    or (x <= 1) Then x_dir:=-x_dir;
    if (y >= 200*160)           {y-Rand erreicht -> y-Richtung umdrehen}
    or (y <= 160) Then y_dir:=-y_dir;
  Until KeyPressed;             {laufe, bis Taste gedrckt}
  TextMode(3);
End.
