Unit Var_3d;

Interface
Uses Tools;
Const Txt_Anzahl=5;             {Anzahl benutzter Texturen}
      Txt_Groesse:              {Grî·enangaben der Texturen}
        Array[0..Txt_Anzahl-1] of Word=
        ($0a0a,$0a0a,$0a0a,$0a0a,$0a0a);

Var  vz:Word;                   {Verschiebung in den Bildschirm hinein}
    Var i:Word;

    rotx,                       {Rotationswinkel}
    roty,
    rotz:word;                  {3 Grad-Schritte}
    fl_sort:Boolean;            {FlÑchen sortieren ?}
    Fuellen:Boolean;            {true: FÅllen / false:Linien}
    fl_ruecken:Boolean;         {FlÑchenrÅcken unterdrÅcken ?}
    Texture:Boolean;            {Texturen verwenden ?}
    lightsrc:Boolean;           {Lichtquelle verwenden ?}
    Glas:Boolean;               {Glas-FlÑchen ?}

    Txt_Daten:Array[0..Txt_Anzahl-1] of Pointer;
                                {Lage der Texturen im Speicher}
    Txt_Offs:Array[0..Txt_Anzahl-1] of Word;
                                {Offset innerhalb des Textur-Bilds}
    Txt_Pic:Pointer;            {Zeiger auf Textur-Bild}

    Sinus:Array[0..149] of Word;{Sinus-Tabelle fÅr Rotationen}

Implementation
Begin
  Move(Sinus[0],Sinus[120],60);
Begin
  for i:=0 to 149 do
    sinus[i]:=round(sin(i*2*pi/120)*16384);
End;

End.
