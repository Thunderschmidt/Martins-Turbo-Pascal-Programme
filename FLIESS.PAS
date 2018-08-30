Uses Crt,Gif,ModeXLib;
Procedure Fliess;
var i,
    Old9:Byte;
Begin
  Port[$3d4]:=9;                {CRTC Register 9 (Maximum Row Adress) selekt.}
  Old9:=Port[$3d5] and $80;     {alten Inhalt speichern, }
  for i:=2 to 31 do begin       {erspart st„ndiges auslesen}
    WaitRetrace;                {Synchronisation}
    Port[$3d5]:=old9 or i;      {Wert schreiben}
  End;
End;

Begin
  asm mov ax,13h; int 10h End;  {Mode 13h ein (oder anderer Grafikmodus)}
  LoadGif('beule');             {Hintergrund-Bild laden}
  Move(vscreen^,Ptr($a000,0)^,64000); {und auf Screen}
  ReadLn;
  Fliess;                       {Wegflieáen ausl”sen}
  ReadLn;
  TextMode(3);                  {VGA wieder in Ursprungszustand setzen}
End.
