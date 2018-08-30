Uses Crt,ModeXLib,Gif,Font;

Var Sinus:Array[0..127] of Word;{Sinus-Tabelle fÅr vertikale Schwingung}
    t:Word;                     {"Zeit", Position innerhalb des Sinus}
Var i:Word;

Begin
  Init_ModeX;                   {Mode X ein}
  LoadGif('pfont4');            {Zeichensatz laden}
  p13_2_ModeX(48000,16000);     {und auf Seite 3 kopieren}
Begin
  for i:=0 to 127 do
    sinus[i]:=round(sin(i*2*pi/128)*50);
End;

                                {Sinus-Tabelle fÅr vert. Bewegung vorbereiten}
  t:=0;                         {Zeit startet bei 0}
  Repeat
    WaitRetrace;                {Synchronisation}
    Scrl_Move;                  {sichtbaren Teil nach rechts bewegen}
    Scrl_Append;                {rechts neue Spalte anhÑngen}
    SetStart(Sinus[t and 127]*80);  {fÅr vert. Bewegung sorgen}
    Inc(t,2);                     {weiter in Sinus-Tabelle}
  Until KeyPressed;
  TextMode(3);
End.
