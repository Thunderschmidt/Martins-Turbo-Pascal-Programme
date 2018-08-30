uses Crt,ModeXLib,Gif;
Begin
  Init_ModeX;                   {Einschalten des Mode X}
  LoadGif('squeeze');           {Laden des Bilds}
  p13_2_ModeX(vram_pos,rest div 4);
  ReadLn;                       {Warten auf Enter}
  Squeeze;                      {Zusammenschieben des Bilds}
  ReadLn;
  TextMode(3);
End.
