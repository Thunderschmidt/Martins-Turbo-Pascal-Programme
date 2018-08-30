Unit Tools;

Interface
uses crt;
Procedure Draw_Ansi(Name:String);


Implementation

Procedure Draw_Ansi(Name:String);
{gibt ein Ansi-File auf dem Bildschirm aus (ANSI.SYS erforderlich !)}
Var Ansi:File;                  {Ansi-Datei}
    StdOut:File;                {Standard-Ausgabe Datei (Int 21h)}
    Puffer:Pointer;             {Zwischenpuffer fÅr Bildschirm}
    Groesse:Word;               {Dateigrî·e}
Begin
  Assign(Ansi,Name);            {Ansi-File îffnen}
  Assign(StdOut,'CON');         {Ausgabe-File îffnen}

  Reset(Ansi,1);                {Ansi-File mit Blockgrî·e 1 Byte init.}
  Groesse:=FileSize(Ansi);      {Grî·e (in Byte) bestimmen}
  Reset(Ansi,Groesse);          {Datei mit dieser Grî·e erneut initialisieren}
  Reset(StdOut,Groesse);        {Ausgabe-Datei initialisieren}

  GetMem(Puffer,Groesse);       {Puffer allokieren}
  BlockRead(Ansi,Puffer^,1);    {File lesen ...}
  BlockWrite(StdOut,Puffer^,1); {... und ausgeben}
  FreeMem(Puffer,Groesse);      {Puffer freigeben}
  Close(Ansi);                  {Dateien schlie·en}
  Close(StdOut);
End;

Begin
End.
