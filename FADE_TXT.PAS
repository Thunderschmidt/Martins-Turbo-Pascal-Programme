Uses Crt,Gif,ModeXLib,Fade;
Var
  Text_Pal:Array[0..767] of Byte;
  i:word;

Begin
  Init_Mode13;                  {Mode 13h benutzen}
  Screen_Off;                   {Bildschirm beim Laden aus}
  LoadGif('vflog210');          {statischen Teil laden}
  Move(Palette[210*3],          {dessen Palettenteil (Farben 210..255)}
    Text_Pal[210*3],46*3);      {eintragen}
  Show_Pic13;                   {statisches Bild in VGA kopieren}

  LoadGif('texte');             {Bild mit Texten laden}
  Move(Palette,Text_Pal,14*3);  {dessen Palettenteil (Farben 0..13)}
                                {eintragen}
  Move(Text_Pal,Palette,768);   {fertige Palette setzen}
  SetPal;

  Move(vscreen^,                {erster Text kann direkt auf Bildschirm}
    Ptr($a000,160*320)^,19*320);{kopiert werden}
  Screen_On;                    {jetzt Bild fertig -> einschalten}
  Colors:=14;                   {in diesem Programm Bilder mit 14 Farben !}

  For i:=1 to 6 do Begin        {nacheinander die 6 weiteren Texte einblenden}
    Delay(500);                 {Zeit zum Lesen}
    Ueberblenden(vscreen,       {n„chstes Bild an alte Position (y=160) faden}
      text_pal,i*20,160,19);
    Fade_ResetPic(160,19);      {und "resetten"}
    If KeyPressed Then Exit;    {wer genug hat, kann hier abbrechen}
  End;

  Readln;
  TextMode(3);
End.
