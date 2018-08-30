{$G+}
Uses Crt,ModeXLib;
Type Block=Array[0..99,0..319] of Byte;
Var
  Src_Frame,                    {vorheriges Bild}
  Dest_Frame:^Block;            {aktuelles Bild}

Procedure Scroll_Up;assembler;
{scrollt das Bild um eine Zeile nach oben und interpoliert}
asm
  push ds
  les di,Dest_Frame             {Zeiger auf Zielbild laden}
  lds si,Src_Frame              {Zeiger auf Quellbild}
  add si,320                    {im Quellbild auf Zeile 1}
  mov cx,320*98                 {99 Zeilen scrollen}
  xor bl,bl                     {wird als Dummy fÅr High-Byte benîtigt}
@lp1:
  xor ax,ax
  xor bx,bx
  mov al,[si-321]               {ersten Punkt holen}
  mov bl,[si-320]               {zweiten Punkt addieren}
  add ax,bx
  mov bl,[si-319]               {nÑchsten Punkt addieren}
  add ax,bx
  mov bl,[si-1]                 {usw...}
  add ax,bx
  mov bl,[si+1]
  add ax,bx
  mov bl,[si+319]
  add ax,bx
  mov bl,[si+320]
  adc ax,bx
  mov bl,[si+321]
  adc ax,bx
  shr ax,3

  or ax,ax                      {bereits 0 ?}
  je @null
  dec al                        {wenn nein, dann verringern}
@null:
  stosb                         {Wert ins Ziel}
  inc si                        {nÑchsten Punkt}
  dec cx                        {weitere Punkte ?}
  jne @lp1
  pop ds
End;

Procedure New_Line;             {baut die untersten Zeilen neu auf}
Var i,x:Word;
Begin
  For x:=0 to 319 do Begin      {untere 3 Zeilen mit zufÑlligen Werten fÅllen}
    Dest_Frame^[97,x]:=Random(15)+64;
    Dest_Frame^[98,x]:=Random(15)+64;
    Dest_Frame^[99,x]:=Random(15)+64;
  End;
  For i:=0 to Random(45) do Begin {zuf. Anzahl Hotspots einfÅgen}
    x:=Random(320);             {an zufÑllige Koordinaten}
    asm
      les di,Dest_Frame         {Zielbild adressieren}
      add di,98*320             {Zeile 98 (zweitunterste) bearbeiten}
      add di,x                  {x-Koordinate dazu}
      mov al,0ffh               {hellste Farbe}
      mov es:[di-321],al        {gro·en Hotspot erzeugen (9 Punkte)}
      mov es:[di-320],al
      mov es:[di-319],al
      mov es:[di-1],al
      mov es:[di],al
      mov es:[di+1],al
      mov es:[di+319],al
      mov es:[di+320],al
      mov es:[di+321],al
    End;
  End;
End;

Procedure Show_Screen;          {kopiert fertigen Bilschirm auf VGA}
Var temp:Pointer;               {zum Tauschen der Zeiger}
Begin
asm
  push ds
  lds si,Dest_Frame             {fertiges Bild als Quelle}
  mov ax,0a000h                 {VGA als Ziel}
  mov es,ax
  mov di,320*100                {ab Zeile 100}
  mov cx,320*100/4              {100 Zeilen als Dwords kopieren}
db 66h                          {Operand Size Prefix (32 Bit)}
  rep movsw                     {kopieren}
  pop ds
End;
  temp:=Dest_Frame;             {Zeiger auf Quell- und Zielbild tauschen}
  Dest_Frame:=Src_Frame;
  Src_Frame:=temp;
End;

Procedure Prep_Pal;             {Palette auf Flames vorbereiten}
Var i:Word;
Begin
  FillChar(Palette,80*3,0);     {Grundlage: alles schwarz}
  For i:=0 to 7 do Begin
    Palette[i*3+2]:=i*2;        {Farbe 0-7: Anstieg Blau}
    Palette[(i+8)*3+2]:=16-i*2; {Farbe 0-7: abfallendes Blau}
  End;
  For i:=8 to 31 do             {Farbe 8 -31: Anstieg Rot}
    Palette[i*3]:=(i-8)*63 div 23;
  For i:=32 to 55 do Begin      {Farbe 32-55: Anstieg GrÅn, Rot konstant}
    Palette[i*3]:=63;
    Palette[i*3+1]:=(i-32)*63 div 23;
  End;
  For i:=56 to 79 do Begin      {Farbe 56-79: Anstieg Blau,Rot u. Blau konst.}
    Palette[i*3]:=63;
    Palette[i*3+1]:=63;
    Palette[i*3+2]:=(i-56)*63 div 23;
  End;
  FillChar(Palette[80*3],176*3,63);  {Rest wei·}
  SetPal;                       {fertige Palette setzen}
End;

begin
  Randomize;                    {Random Seed bestimmen}
  GetMem(Src_Frame,320*100);    {Speicher fÅr Quellbild holen und lîschen}
  FillChar(Src_Frame^,320*100,0);
  GetMem(Dest_Frame,320*100);   {Speicher fÅr Ziellbild holen und lîschen}
  FillChar(Dest_Frame^,320*100,0);
  Init_Mode13;                  {Mode 13h setzen}
  Prep_Pal;                     {Palette vorbereiten}
  Repeat
    Scroll_Up;                  {Flammen nach oben}
    New_Line;                   {unten neue Linie anfÅgen}
    Show_Screen;                {fertigen Bildschirm zeigen}
  Until KeyPressed;
  TextMode(3);
end.
