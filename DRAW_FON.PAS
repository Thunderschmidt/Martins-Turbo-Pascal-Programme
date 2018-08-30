Uses Crt,ModeXLib,Gif,Font;

Var Eingabe:Char;               {gerade eingegebenes Zeichen}

Begin
  Init_ModeX;                   {Mode X ein}
  LoadGif('pfont4');            {Zeichensatz laden}
  p13_2_ModeX(48000,16000);     {und auf Seite 3 kopieren}

  Repeat                        {Schleife zum Ausgeben von Tastatureingaben}
    Eingabe:=ReadKey;           {Zeichen holen}
    Print_Char(Eingabe);        {und auf Monitor bringen}
  Until Eingabe=#27;            {bis Esc gedrÅckt}

  Print_String('hallo, test');  {zum Abschlu· noch einen String ausgeben}
  ReadLn;
  TextMode(3);
End.
