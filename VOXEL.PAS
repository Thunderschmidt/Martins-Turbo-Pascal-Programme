{$G+}
Uses Crt,Gif,ModeXLib;

Var x,y:Integer;                {Koordinaten des Trapez}

Procedure Draw_Voxel;external;
{$l voxel.obj}

Begin
  asm mov ax,0; int 33h End;    {Maustreiber zurÅcksetzen}
  Init_ModeX;                   {Mode X einschalten}
  LoadGif('fract003');           {Landschaft laden}
  x:=195;                       {Startkoordinate festlegen}
  y:=130;
  Repeat
    ClrX($0f);                  {Bildschirm lîschen}
    Draw_Voxel;                 {Landschaft zeichnen}
    Switch;                     {fertige Bildschirmseite aktivieren}
    WaitRetrace;                {auf Retrace warten}
    asm
      mov ax,000bh              {Funktion 0bh: relative Koordinaten lesen}
      int 33h
      sar cx,2                  {Division durch 2}
      sar dx,2
      add x,cx
      add y,dx
    End;
    If x < 0 Then x:=0; If x > 130 Then x:=130;
    If y < 0 Then y:=0; If y > 130 Then y:=130;
  Until KeyPressed;             {bis Taste}
  TextMode(3);
End.
