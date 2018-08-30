Uses Crt,Gif,ModeXLib;
Var y:Word;                     {derzeitiger Wert der Linear Start. Adress}
    y_dir:Integer;              {gibt Scroll Richtung an}
Begin
  Init_ModeX;                   {Mode X einschalten}
  Screen_Off;                   {Bildschirm aus}
  LoadGif('320800');            {Bild laden}
  p13_2_ModeX(vram_pos,rest div 4);
  Screen_On;
  y:=600*80;                    {Beginn mit Zeile 1}
  y_dir:=-80;                   {Bewegungsrichtung +80 Byte pro Durchlauf}
  Repeat
    Inc(y,y_dir);               {Bewegung}
    WaitRetrace;                {Auf Retrace warten}
    SetStart(y);                {und neuen Start in Register schreiben}
    if (y >= 600*80)            {Rand erreicht -> Richtung umdrehen}
    or (y <= 80) Then y_dir:=-y_dir;
  Until KeyPressed;             {laufe, bis Taste gedrckt}
  TextMode(3);
End.
