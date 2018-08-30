Unit fade;
{verwendet zum öberblenden eines gerade angezeigten Bild(teil)s
 in ein neues}

Interface
Uses ModeXLib;

Var Colors:Word;                {Anzahl Farben pro Einzelbild}

Procedure fade_ResetPic(y,Hoehe:Word);
Procedure Ueberblenden(Pic:Pointer;Pal:Array of Byte; Start,y,Hoehe:Word);


Implementation
Var i,j:Word;                   {temporÑre ZÑhler}
    Ziel_Pal:Array[0..768] of Byte;  {temporÑre Zielpalette}

Procedure fade_set(Quelle:Pointer;Start,y,Hoehe:Word);external;
{"mischt" Quelle mit VGA-Ram}
{dabei Quelle ab Zeile Start und VGA-Ram ab Zeile y bei Hîhe Hoehe verwenden}

Procedure fade_ResetPic(y,Hoehe:Word);external;
{bereitet Åbergeblendetes Bild auf erneutes Faden vor}
{dazu Reduktion von "Colors^2" auf "Colors" Farben}
{auch hier y=Zeile im VGA-Ram, Hoehe=Hîhe des zu bearbeitenden Bereichs}

{$l fade}


Procedure fade_CopyPal;
{Palette auf Colors^2 vervielfachen (nichthomogenen Block 0 vervielfachen)}
Begin
  For i:=1 to Colors do
    Move(Palette[0],Palette[i*3*Colors],Colors*3);

End;

Procedure fade_spreizen(Var Pal:Array of Byte);
{Palette auf Colors^2 spreizen (jede Farbe einzeln vervielfachen)}
{hier werden aus den Farben 0..Colors-1 die homogenen Blîcke gebildet}
Begin
  For i:= 0 to Colors-1 do      {jede Farbe einzeln bearbeiten}
    For j:=0 to Colors -1 do    {jeweils Colors mal schreiben}
      Move(Pal[i*3],Pal[(i+1)*3*Colors+j*3],3);
End;

Procedure Ueberblenden(Pic:Pointer;Pal:Array of Byte; Start,y,Hoehe:Word);
{Blendet von aktuell sichtbarem Bild auf Pic (mit Palette Pal) Åber
 dabei wird in Zeile "Start" von Pic begonnen, "Hoehe" Zeilen zur
 y-Koordinate y des aktuellen Bilds zu kopieren}
Begin
  WaitRetrace;                  {Synchronisation}
  fade_CopyPal;                 {in aktueller Palette Block vervielfachen}
  SetPal;                       {diese Palette neu setzen}
  Move(Palette,Ziel_Pal,768);   {originale Palettenteile beibehalten}
  Move(pal,Ziel_Pal,Colors*3);  {Zielpalette laden}
  fade_spreizen(Ziel_pal);      {Zielpaletten-Blocks spreizen}
  fade_set(pic,start,y,hoehe);  {neues Bild dazumischen}
  fade_to(Ziel_pal,1);          {und Åberblenden}
End;

Begin
  Colors:=15;                   {nur Defaultwert !}
End.
