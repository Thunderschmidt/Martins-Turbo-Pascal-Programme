{$G+}
Uses ModeXLib,Crt;
Var Sterne:Array[0..500] of Record
                              x,y,Ebene:Integer;
                            End;
  st_nr:Word;
  vscreen:Pointer;
  vpage:Word;
  palette:Array[0..768] of Byte;

Procedure PutPixel(x,y,col:word);assembler;
{setzt Punkt (x/y) auf Farbe col (Mode X)}
asm
  mov ax,0a000h                 {Segment laden}
  mov es,ax

  mov cx,x                      {Write Plane bestimmen}
  and cx,3                      {als x mov 4}
  mov ax,1
  shl ax,cl                     {entsprechendes Bit setzen}
  mov ah,al
  mov dx,03c4h                  {Timing Sequenzer}
  mov al,2                      {Register 2 - Write Plane Mask}
  out dx,ax

  mov ax,80                     {Offset = Y*80 + X div 4}
  mul y
  mov di,ax
  mov ax,x
  shr ax,2
  add di,ax                     {Offset laden}
  mov al,byte ptr col           {Farbe laden}
  mov es:[di],al                {und Punkt setzen}
End;

Begin
  Randomize;                    {Zufallszahlen initialisieren}
  Init_ModeX;
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
