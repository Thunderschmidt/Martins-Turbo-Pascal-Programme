Unit Font;

Interface

Procedure Print_Char(Chr:Char);
{gibt Zeichen auf Mode X aus}
Procedure Print_String(Str:String);
{gibt String auf Mode X aus}

Procedure Scrl_Move;
{bewegt sichtbaren Teil des Scrolly nach links}
Procedure Scrl_Append;
{hÑngt am rechten Bildrand neue Daten an Scrolly an}

Var Scrl_Y:Word;                {vertikale Position des Scrollys}

Const
  Scrl_Anzahl=4;
  {Anzahl der in Scrl_Txt vorhandenen Strings}
  Scrl_Txt:Array [1..Scrl_Anzahl] of String =
  {Nur ein Demo-Text, der beliebig verÑndert oder ergÑnzt werden kann !}
  ('Hallo, dies ist Martins kleine Demo - total schlecht und eigentlich'
  +' einfach nur irgendwo abgeschrieben. Erstellt wurde sie am 21.3.1998,',
  +' um ca. 23.30 uhr. Gleich kommen noch ein paar lustige 3D - Scherzchen.'
  +' Gruesse gehen an Phylax, Buddy und an alle, die Lust haben, sich dieses ',
    '  anzutun.   --------------------------- ', ' '+'');


Implementation
Uses ModeXLib;
Const
  CharPos:Array[' '..'Z', 0..1] of Word=
  {Positionen und Breiten der einzelnen Zeichen,
   jeweils CPU-adressierte Bytes}
   ((71,4),(0,0),(0,0),(0,0),(0,0),(0,0),
    (0,0),(0,0),(0,0),(0,0),(0,0),(0,0),
    (1906,3),(1909,3),(1912,3),(1915,4),      {,-./}
    (3600,5),(3605,3),(3608,5),(3613,5),      {0..3}
    (3618,5),(3623,5),(3628,5),(3633,5),      {4..7}
    (3638,5),(3643,5),(3648,3),(3651,3),      {8..;}
    (3654,5),(3659,5),(3664,5),(3669,4),      {<..?}
    (0,0),(0,5),(5,5),(10,5),(15,6),(21,5),    {@..E}
    (26,4),(30,7),(37,5),(42,3),(45,4),(49,5),{F..K}
    (54,4),(58,8),(66,5),(1840,7),(1847,5),    {L..P}
    (1852,7),(1859,5),(1864,4),(1868,4),      {Q..T}
    (1872,5),(1877,6),(1883,8),(1891,5),      {U..X}
    (1896,5),(1901,5));                        {YZ}

Var Cur_X,                      {gegenwÑrtige x-}
    Cur_Y:Integer;              {und y-Position des Cursors}

    Scrl_Number,                {Nummer des gerade aktiven Scroll-Strings}
    Scrl_Pos,                   {Position innerhalb dieses Strings}
    Scrl_ChrPos:Word;           {Position innerhalb des Zeichens}

Procedure Print_Char(Chr:Char);
{Gibt ein Zeichen auf Mode X Bildschirm aus und bewegt Cursor
 eine Position weiter}
Begin
  Chr:=UpCase(Chr);             {nur Gro·buchstaben verwenden}
  If Chr in [' '..'Z'] Then Begin {ist das Zeichen im Zeichensatz ?, ja:}
    If 80- Cur_X <              {noch genug Platz ?}
    CharPos[Chr,1] Then Begin
      Cur_X:=0;                 {nein, dann nÑchste Zeile, x auf 0}
      Inc(Cur_Y,25);            {und y eine Zeichenhîhe weiter}
    End;
  Copy_Block(Cur_Y*80+Cur_X, 48000+Charpos[Chr,0], CharPos[Chr,1], 22);
  {Zeichen von Font-Position (aus CharPos-Tabelle) an Cursorposition
   (Cur_Y * 80 Byte pro Zeile + Cur_X) kopieren (Hîhe 22 Zeilen}
  Inc(Cur_X,CharPos[Chr,1]);    {Cursor um Zeichenbreite bewegen}
  End;
End;

Procedure Print_String(Str:String);
{gibt einen String auf Mode X Bildschirm aus,
 benutzt dazu Print_Char}
Var i:Word;
Begin
  For i:=1 to Length(Str) do    {gesamten String an Print_Char schicken}
    Print_Char(Str[i]);
End;

Procedure Scrl_Move;
{verschiebt einfach Bildinhalt an der Stelle des Scrollys um eine
 Position nach links, also 79 Bytes von x-Position 1 nach x-Position 0
 kopieren}
Begin
  Copy_Block(Scrl_y*80, Scrl_Y*80 +1, 79,22);
End;

Procedure Scrl_Append;
Var Chr:Char;                   {aktueller Buchstabe}
Begin
  Chr:=UpCase(Scrl_txt[Scrl_Number,Scrl_pos]);
                                {Buchstaben holen, nur Gro·buchstaben}
  If Chr in [' '..'Z'] Then Begin  {ist das Zeichen im Zeichensatz ?, ja:}
    If CharPos[Chr,1] > 0 Then  {nur vorhandene Zeichen darstellen}
      Copy_Block(Scrl_y*80+79, 48000+CharPos[Chr,0]+Scrl_ChrPos, 1, 22);
                                {dann 1 Spalte aus Zeichensatz an rechten}
                                {Bildschirmrand kopieren}
    Inc(Scrl_ChrPos);           {und nÑchste Spalte innerhalb des Zeichens}
    If Scrl_ChrPos >= CharPos[Chr,1] Then Begin
      Inc(Scrl_Pos);            {wenn Zeichen fertig, nÑchstes Zeichen}
      Scrl_ChrPos:=0;           {und Spalte wieder auf 0}
      If Scrl_Pos > Length(Scrl_Txt[Scrl_Number]) Then Begin
        Inc(Scrl_Number);       {wenn String fertig, nÑchsten String}
        Scrl_Pos:=1;            {Position wieder auf 0}
        If Scrl_Number > Scrl_Anzahl Then Begin
           Scrl_Number:=1;      {wenn Text fertig, wieder von vorn}
          Scrl_Pos:=1;
          Scrl_ChrPos:=0;
        End;
      End;
    End;
  End;
End;

Begin
  Cur_X:=0;                     {Cursor auf linke obere Ecke}
  Cur_Y:=0;

  Scrl_Y:=50;                   {Default-Wert fÅr y-Position}
  Scrl_Number:=1;               {Start mit String 1, Zeichen 1, Spalte 0}
  Scrl_Pos:=1;
  Scrl_ChrPos:=0;
End.
