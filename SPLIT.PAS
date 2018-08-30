Uses Crt,Gif,ModeXLib;
Var i:Word;
begin
  Init_ModeX;                   {Mode X initialisieren}
  LoadGif('beule');             {erstes Bild (Hintergrund) laden}
  p13_2_ModeX(16000,16000);
  LoadGif('corner');            {zweites Bild laden}
  p13_2_modex(0,16000);
  SetStart(16000);              {Hintergrund anzeigen}
  Repeat
    For i:=200 downto 0 do Begin{Split-Line nach oben ziehen}
      WaitRetrace;
      Split(i);
      If KeyPressed Then Exit;
    End;
    For i:=0 to 200 do Begin    {Split-Line nach unten}
      WaitRetrace;
      Split(i);
      If KeyPressed Then Exit;
    End;
  Until KeyPressed;
  TextMode(3);
End.
