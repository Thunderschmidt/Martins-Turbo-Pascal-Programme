uses crt,ModeXLib,Tools;
var i,j:word;
    zielpal:Array[0..767] of Byte;

Procedure Fade_in(ZPal:Array of Byte);
Begin
  For j:=0 to 63 do Begin       {64 Durchl„ufe, um komplett zu faden}
    For i:=0 to 767 do          {768 Farbwerte berechnen}
      If Palette[i] < ZPal[i]   {aktueller Wert noch kleiner als Zielwert ?}
        Then Inc(Palette[i]);   {dann erh”hen}
    WaitRetrace;                {Synchronisation}
    SetPal;                     {berechnete Palette setzen}
  End;
End;

begin
  ClrScr;                       {Bildschirm l”schen}
  GetPal;                       {"Palette" mit aktuelle DAC-Palette laden}
  Move(Palette,Zielpal,768);    {Palette sichern}
  FillChar(Palette,768,0);      {alte Palette l”schen}
  SetPal;                       {und setzen}

  Draw_Ansi('color.ans');       {Hintergrundbild laden}

  ReadLn;
  fade_in(Zielpal);             {Bild auf Zielpal (originale Palette) faden}
  ReadLn;
  TextMode(3);                  {Normalzustand herstellen}
End.
