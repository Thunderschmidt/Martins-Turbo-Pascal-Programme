{$N-}                           {Coprozessor aus}
Uses Crt,Tools;

Var phi,                        {Winkel}
    x,y:Word;                   {Koordinaten}
    Zeichen:Byte;               {benutztes Zeichen}
    Sinus:Array[1..360] of Word;{nimmt die Sinus-Tabelle auf}

Procedure Sinus_Real;                         {zeichnet 26 mal einen Kreis}
Begin
  For Zeichen:=Ord('A') to Ord('Z')do         {26 Durchl„ufe}
    For phi:=1 to 360 do Begin
      x:=Trunc(Round(Sin(phi/180*pi)*20+40)); {x-Koordinate berechnen}
      y:=Trunc(Round(Cos(phi/180*pi)*10+12)); {y-Koordinate berechnen}
      mem[$b800:y*160+x*2]:=Zeichen;          {Zeichen auf den Bildschirm}
    End;
End;
Procedure Sinus_neu;                          {zeichnet 26 mal einen Kreis}
Begin
  For Zeichen:=Ord('A') to Ord('Z')do         {26 Durchl„ufe}
    For phi:=1 to 360 do Begin
      x:=Sinus[phi]+40;                       {x-Koordinate berechnen}
      If phi<=270 Then                        {y-Koordinate berechnen}
        y:=Sinus[phi+90] div 2 + 12 Else      {Kosinus als verschobenen Sinus}
        y:=Sinus[phi-270] div 2 + 12;
      mem[$b800:y*160+x*2]:=Zeichen;          {Zeichen auf den Bildschirm}
    End;
End;

Begin
  Sin_Gen(Sinus,360,20,0);                    {Sinus-Tabelle vorbereiten}
  ClrScr;                                     {Bildschirm l”schen}
  Sinus_real;                                 {Kreise zeichnen}
  ClrScr;                                     {Bildschirm l”schen}
  Sinus_neu;                                  {Kreise zeichnen}
End.
