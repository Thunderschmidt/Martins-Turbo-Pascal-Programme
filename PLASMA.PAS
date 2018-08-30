Uses Crt,ModeXLib,Gif;

Var slow_flag:Boolean;          {zu Steuerung der langsamen Verl„ufe}

Begin
  Init_Mode13;                  {Mode 13h ein}
  LoadGif('fract003');            {Bild laden und anzeigen}
  Show_Pic13;
  Repeat
    Pal_Rot(1,255);
        If slow_flag Then Begin     {bei jedem 2. Durchlauf:}

    End;
    slow_flag:=not slow_flag;   {abwechselnd "Springbrunnen" und "Radar"}
                                {erm”glichen und sperren}
    WaitRetrace;                {Synchronisation}

    SetPal;                     {die rotierte Palette setzen}
  Until KeyPressed;             {bis Tastendruck}
  TextMode(3);
End.
