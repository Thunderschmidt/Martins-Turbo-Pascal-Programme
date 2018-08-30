uses crt,modexlib,Tools;
var i:word;

Begin
  GetPal;                       {"Palette" mit aktuelle DAC-Palette laden}
  Draw_Ansi('color.ans');       {Bild laden}
  Setpal;
  ReadLn;
  Fade_out;                     {Bild ausblenden}
  ReadLn;
  TextMode(3);                  {wieder normales Bild}
End.