Uses Crt,Gif,ModeXLib,font;
Var i:Word;
begin
  Init_ModeX;                   {Mode X initialisieren}
          LoadGif('pfont4');            {Zeichensatz laden}
  p13_2_ModeX(16000,16000);     {und auf Seite 3 kopieren}

      LoadGif('corner');            {Zeichensatz laden}
  p13_2_ModeX(0,16000);     {und auf Seite 3 kopieren}

      WaitRetrace;
  SetStart(16000);              {Hintergrund anzeigen}
      Split(20);
      Repeat
    WaitRetrace;                {Synchronisation}
    
    Scrl_Move;                  {sichtbaren Teil nach rechts bewegen}
    Scrl_Append;                {rechts neue Spalte anh„ngen}
  Print_String('MoinA');

  Until KeyPressed;

    Repeat
Until KeyPressed;
  TextMode(3);
End.


