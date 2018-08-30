 Uses Crt,ModeXLib;
var y1,                         {y-Position Copper 1}
    y1_dir,                     {y-Richtung Copper 1}
    Maske:Word;                 {Overlay-Maske, fÅr öberlagerung der Copper}

Procedure MakeCopper(y_pos1,y_pos2,overlay_maske:word);external;
{$l copper}

begin
  TextMode(3);                  {Copper funktioniert in JEDEM Videomodus ! }
  y1:=Port[$3da];               {ATC in Index-Mode schalten}
  Port[$3c0]:=$11 or 32;        {Register 11h wÑhlen}
  Port[$3c0]:=255;              {Rahmenfarbe 255}
  y1:=0;                        {Start am oberen Bildschirmrand}
  y1_dir:=2;                    {Bewegung zunÑchst nach unten}
  Maske:=$00ff;                 {zunÑchst Copper 1 (rot) im Vordergrund}
  Repeat
    Inc(y1,y1_dir);             {Copper-Bewegung}
    If (y1<=0) or (y1>=150)     {am Rand : }
      then Begin
      y1_dir:=-y1_dir;          {Richtung umkehren}
      Maske:=Swap(Maske);       {jew. anderen Copper in Vordergrund}
    End;
    Write('    I c k   S c h n a c k   P l a t t    ');
    MakeCopper(y1,150-y1,Maske);{Copper zeichnen}
  Until KeyPressed;
End.
