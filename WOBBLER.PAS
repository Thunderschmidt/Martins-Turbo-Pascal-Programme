Uses Crt,Gif,ModeXLib,Tools;
const y=246;                    {Hîhe und Position hier festgelgt}
      hoehe=90;                 {dÅrfen natÅrich auch Variablen sein}

Var Sinus:Array[0..63] of Word; {Sinustabelle, wird spÑter gefÅllt}
    i:Word;                     {temporÑrer ZÑhler}

Procedure Make_Wob(wob_pos,wob_hoehe,wob_offset:word);external;
{$l wobbler}

begin
  TextMode(3);                  {Wobbler funktioniert in JEDEM Videomodus ! }

  Draw_Ansi('db6.ans');         {Ansi-File laden}
  Sin_Gen(Sinus,64,4,83);       {Sinus vorberechnen}
  CRTC_Unprotect;               {horizontales Timing freischalten}
  ReadKey;                      {warten}
  i:=0;
  Repeat
    inc(i);                     {Bewegung erzeugen}
    Make_Wob(y,hoehe,i);        {Wobble zeichnen}
  Until KeyPressed;
  CRTC_Protect;                 {CRTC wieder schÅtzen}
End.
