uses crt,ModeXLib,Tools;
var i:word;
    origpal,
    zielpal:Array[0..767] of Byte;

begin
  ClrScr;
  GetPal;                       {"Palette" mit aktuelle DAC-Palette laden}
  Move(Palette,OrigPal,768);    {Palette sichern}
  Move(Palette,Zielpal,768);    {Ziel-Palette bestimmen}

  Draw_Ansi('color.ans');       {Ansi-Bild laden}

  Make_bw(ZielPal);             {ZielPal auf schwarz/weiá ziehen}
  readkey;
  fade_to(ZielPal,1);           {schwarz/weiáe Palette einblenden}
  ReadKey;
  fade_to(OrigPal,1);           {Original-Palette einblenden}

  ReadLn;
  TextMode(3);                  {Normalzustand herstellen}
End.
