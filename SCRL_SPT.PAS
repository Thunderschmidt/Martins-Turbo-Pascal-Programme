uses crt,Gif,ModeXLib;
Var x,                          {derzeitiger Offset in x-Richtung}
    x_dir,                      {gibt Scroll Richtung fr x-an}
    y,                          {derzeitiger Offset fr y-Richtung}
    y_dir:word;                 {gibt Scroll Richtung fr y an}
    split_line:word;            {derzeitige Position der Split-Line}
    split_dir:word;             {gibt Bewegungsrichtung der Split-Line an}
Begin
  Init_ModeX;                   {Mode X einschalten}
  double;                       {160-Byte Modus einschalten}
  Screen_Off;                   {Bildschirm aus}
  LoadGif_Pos('640400',160*50);{groáes Bild an Position (0/50) laden}
  p13_2_ModeX(vram_pos,rest div 4); {Rest in VGA-Speicher kopieren}
  LoadGif('corner');            {kleines Bild an Position (0/0) laden}
  p13_2_ModeX(0,160*50);        {und auf Bildschirm kopieren}
  Screen_On;                    {Bildschirm ein}

  split_line:=150;              {Split zun„chst auf Zeile 150 setzen}
  split_dir:=1;                 {Split-Line zun„chst nach unten verschieben}
  x:=1;                         {x-Beginn mit Spalte 1}
  x_dir:=1;                     {x-Richtung 1 Byte pro Durchlauf}
  y:=160;                       {y-Beginn mit Zeile 1}
  y_dir:=160;                   {y-Richtung +160 Byte pro Durchlauf}
  Repeat
    Inc(x,x_dir);               {x-Bewegung}
    Inc(y,y_dir);               {y-Bewegung}
    Inc(Split_line,Split_dir);  {Split Line bewegen}
    WaitRetrace;                {Auf Retrace warten}
    SetStart(50*160+y+x);       {und neuen Start in Register schreiben,}
                                {dabei ersten 50 Zeilen berspringen}
    Split(Split_line);          {Bildschirm an Split Line splitten}
    if (x >= 80)                {x-Rand erreicht -> x-Richtung umdrehen}
    or (x <= 1) Then x_dir:=-x_dir;
    if (y >= 200*160)           {y-Rand erreicht -> y-Richtung umdrehen}
    or (y <= 160) Then y_dir:=-y_dir;
    if (split_line >= 200)      {hat Split Rand erreicht -> Richtung wechseln}
    or (split_line <= 150) then split_dir:=-split_dir
  Until KeyPressed;             {laufe, bis Taste gedrckt}
  TextMode(3);
End.
