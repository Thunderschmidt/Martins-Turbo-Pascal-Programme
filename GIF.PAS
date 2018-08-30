unit gif;                       {Header zu gif.asm}

Interface
uses modexlib;                  {wg. SetPal}
  var
  vram_pos,                     {aktuelle Position im VGA-Ram}
  rest, errornr:word;           {restliche Bytes im Hauptspeicher und Fehler}

  gifname:String;               {Name, erweitert um #0}
  Procedure LoadGif(GName:String);
                                {LÑdt Gif-Datei "GName.gif" in vscreen}
  Procedure LoadGif_Pos(GName:String;Posit:Word);
                                {LÑdt Gif-Datei an Bildschirmoffset Posit}

Implementation
  Procedure ReadGif;external;   {eigentlicher Gif-Loader, kompl. in Asm}
  {$l gif}

  Procedure LoadGif;
  {LÑdt Gif-Datei "GName.gif" in vscreen}
  Begin
    If pos('.',gname) = 0 then  {evtl. Endung ".gif" anhÑngen}
      gname:=gname+'.gif';
    Gifname:=GName+#0;;         {ASCIIZ - String erzeugen}
    vram_pos:=0;                {im VGA-Ram an Offset 0 beginnen}
    ReadGif;                    {und Bild laden}
    If Errornr <> 0 Then        {bei Fehler abbrechen}
      Halt(Errornr);
    SetPal;                     {geladene Palette setzen}
  End;

  Procedure LoadGif_pos;
  {LÑdt Gif-Datei an Bildschirmoffset Posit}
  Begin
    If pos('.',gname) = 0 then  {evtl. Endung ".gif" anhÑngen}
      gname:=gname+'.gif';
    Gifname:=GName+#0;          {ASCIIZ - String erzeugen}
    vram_pos:=posit;            {im VGA-Ram an Åbergebenen Offset beginnen}
    ReadGif;                    {und Bild laden}
    If Errornr <> 0 Then        {bei Fehler abbrechen}
      Halt(Errornr);
    SetPal;                     {geladene Palette setzen}
  End;
Begin
  errornr:=0;                   {normalerweise kein Fehler}
  GetMem(VScreen,64000);        {virtuellen Bildschirm allokieren}
End.
