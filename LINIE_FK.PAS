Uses Crt;

Var x:Word;

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

Procedure Line(x1,y1,x2,y2,col:Word);assembler;
asm
  {verwendete Register:
    bx/cx: Vor-/Nachkommateil der y-Koordinate
    si   : Nachkommateil der Steigung}
  mov si,x1                     {x mit Startwert laden}
  mov x,si
  sub si,x2                     {und x-Differenz bilden (in si)}

  mov ax,y1                     {y (gespeichert in bx) mit Startwert laden}
  mov bx,ax
  sub ax,y2                     {und y-Differenz bilden (in ax)}

  mov cx,100                    {y-Differenz wg Rechengenauigkeit erweitern}
  imul cx
  idiv si                       {und durch x-Diff dividieren (Steigung)}
  mov si,ax                     {Steigung in si sichern}

  xor cx,cx                     {Nachkommateil der y-Koordinate auf 0}

@lp:
  push x                        {x und Vorkommateil von y an PutPixel}
  push bx
  push col
  call PutPixel

  add cx,si                     {y-Nachkommateil erh”hen}
  cmp cx,100                    {Nachkomma-šberlauf ?}
  jb @kein_ueberlauf            {nein, dann weiter}
  sub cx,100                    {ansonsten Nachkommateil verringern}
  inc bx                        {und Vorkommateil erh”hen}

@kein_ueberlauf:
  inc x                         {auch x weiterz„hlen}
  mov ax,x
  cmp ax,x2                     {Ende erreicht ?}
  jb @lp                        {nein, dann n„chsten Durchlauf}
end;

Begin
  asm mov ax,0013h; int 10h end;{Mode 13h einschalten}
  Line(10,10,100,50,1);         {Linie ziehen}
  ReadLn;
  Textmode(3);
End.