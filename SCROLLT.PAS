Uses ModeXLib,Crt;

Var x,                          {x-Position in Pixel}
    x_dir,                      {x-Richtung}
    y,                          {y-Position in Pixel}
    y_dir:Word;                 {y-Richtung}

Procedure Wait_In_Display;assembler;
{GegenstÅck zu Wait_In_Retrace, wartet auf Bildaufbau durch Kathodenstrahl}
asm
  mov dx,3dah                   {Input Status 1}
@wait2:
  in al,dx
  test al,8h
  jnz @wait2                    {Display ein ? -> dann fertig}
End;
Procedure Wait_In_Retrace;assembler;
{wartet auf Retrace, setzt au·erdem durch Lesezugriff
 auf Input Status 1 den ATC Flip-Flop zurÅck}
asm
  mov dx,3dah                   {Input Status 1}
@wait1:
  in al,dx
  test al,8h
  jz @wait1                     {Retrace aktiv ? -> dann fertig}
End;

Procedure FillScreen;
{FÅllt Bildschirmspeicher mit Testbild der Grî·e 160*50 Zeichen}
var i:word;
Begin
  For i:=0 to 160*50 do Begin   {Zeichen-Schleife}
    If i mod 10 <> 0 Then       {SpaltenzÑhler schreiben ?}
      mem[$b800:i shl 1]:=      {nein, dann '-'}
        Ord('-') Else
      mem[$b800:i shl 1]:=      {ja, dann Spaltennummer in Zehnern}
      ((i mod 160) div 10) mod 10 + Ord('0');
    If i mod 160 = 0 Then       {Spalte 0 ? -> ZeilenzÑhler schreiben}
      mem[$b800:i shl 1]:=(i div 160) mod 10 + Ord('0');
  End;
End;
Procedure V_Pan(n:Byte);assembler;
{fÅhrt vertikales Paning durch}
asm
  mov dx,3d4h                   {CRTC Register 8 (Inittial Row Adress)}
  mov al,8
  mov ah,n                      {Paning-Weite setzen}
  out dx,ax
End;
Procedure H_Pan(n:Byte);assembler;
{fÅhrt vertikales Paning durch}
asm
  mov dx,3c0h                   {ATC Index/Data Port}
  mov al,13h or 32d             {Register 13h (Horizontal Pixel Paning)}
  out dx,al                     {anwÑhlen; Bit 5 (Palette RAM Address Source)}
  mov al,n                      {setzen, um Bildschirm nicht abzuschalten}
  or al,32d                     {Paning-Wert schreiben}
  out dx,al
End;

Begin
  TextMode(3);                  {BIOS-Modus 3 (80*25 Zeichen, Color) setzen}
  FillScreen;                   {Testbild aufbauen}
  portw[$3d4]:=$5013;           {doppelte virtuelle Screen-Breite(160 Zeichen)}
  x:=0;                         {Koordinaten und Richtungen initialisieren}
  x_dir:=1;
  y:=0;
  y_dir:=1;
  Repeat
    Inc(x,x_dir);               {Bewegung in x- und y-Richtung}
    Inc(y,y_dir);
    If (x<=0) or (x>=80*9)      {Umkehr an den RÑndern}
      Then x_dir:=-x_dir;
    if (y<=0) or (y>=25*16)
      Then y_dir:=-y_dir;
    Wait_in_Display;            {warten, bis Bildaufbau lÑuft}
    SetStart((y div 16 *160)    {Startadresse setzen (Grobscrolling}
      + x div 9);
    Wait_in_Retrace;            {warten, bis Retrace aktiv}
    V_Pan(y mod 16);            {Vertikal-Panning   (Feinscrolling)}
    H_Pan((x-1) mod 9);         {Horizontal-Panning (Feinscrolling)}
  Until KeyPressed;             {warten auf Taste}
  TextMode(3);                  {und normalen Videomodus setzen}
End.
