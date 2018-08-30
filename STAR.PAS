Uses Crt;
Var Sterne:Array[0..500] of Record
                              x,y,Ebene:Integer;
                            End;
  st_nr:Word;

Procedure PutPixel(x,y,col:word);assembler;
{setzt Punkt (x/y) auf Farbe col (Mode 13h)}
asm
  mov ax,0a000h                 {Segment laden}
  mov es,ax
  mov ax,320                    {Offset = Y*320 + X}
  mul y
  add ax,x
  mov di,ax                     {Offset laden}
  mov al,byte ptr col           {Farbe laden}
  mov es:[di],al                {und Punkt setzen}
End;

Begin
  Randomize;                    {Zufallszahlen initialisieren}
  asm mov ax,13h; int 10h End;  {Mode 13h setzen}
  Repeat                        {pro Bildaufbau einmal ausgefÅhrt}
    For St_nr:=0 to 500 do Begin{fÅr jeden Stern neue Posit. berechnen}
      With Sterne[st_nr] do Begin
        PutPixel(x,y,0);        {alten Punkt lîschen}
        Dec(x,Ebene shr 5 + 1); {weiterbewegen}
        if x <= 0 Then Begin    {links raus ?}
          x:=319;               {dann neu initialisieren}
          y:=Random(200);
          Ebene:=Random(256);
        End;
        PutPixel(x,y,Ebene shr 4 + 16);  {neuen Punkt setzen}
      End;
    End;
  Until KeyPressed;             {Lauf, bis Taste gedrÅckt}
  TextMode(3);
End.
