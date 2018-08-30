{$G+}
Uses Crt,Sprites,ModeXLib,Gif,Tools;


Procedure PutScalSprt(pg_ofs,x,y,scale_y:Integer;qsprite:spritetyp);
var planecount,                 {Z„hler der bereits kopierten Planes}
    planemask:Byte;             {maskiert Write-Plane in TS-Register 2}
    Skip,                       {Anzahl zu berspringender Bytes}
    ofs,                        {aktueller Offset im Bildschirmspeicher}
    plane,                      {Nummer der aktuellen Plane}
    Breite,                     {Breite zu kopierender Bytes in einer Zeile,}
    dty:Word;                   {H”he}
    quelle:Pointer;             {Zeiger auf Grafikdaten, wenn ds ver„ndert}

    ppp:Array[0..3] of Byte;    {Anzahl Pixel pro Plane}
    rel_y,                      {Nachkommateil der rel. y-Position}
    add_y:Word;                 {Nachkommawert des Summanden}
    direction:Integer;          {Bewegungs-Richtung (+/- 80)}
    i:Word;                     {lokaler Schleifenz„hler}
Begin
  if (x + qsprite.dtx > 319)    {Clipping ? dann Abbruch}
  or (x < 0)
  or (y + qsprite.dty*scale_y div 100 > 199) or (y < 0) then exit;
  add_y:=100-abs(scale_y);      {Summanden berechnen}
  if scale_y < 0 then direction:=-80 else direction:=80;
                                {Richtung festlegen}
  Quelle:=qsprite.adr;          {Zeiger Grafik-Daten}
  dty:=qsprite.dty;             {lokale Hoehen-Variable laden}
   plane:=x mod 4;              {Start-Plane}
  ofs:=pg_ofs+80*y+(x div 4);   {und -Offset berechnen}
  Breite:=0;                    {Breite und Skip vorinitialisieren}
  Skip:=0;

  i:=qsprite.dtx shr 2;         {Anzahl glatter Viererbl”cke}
  ppp[0]:=i;ppp[1]:=i;          {entspricht Mindestanzahl zu kop. Bytes}
  ppp[2]:=i;ppp[3]:=i;
  For i:=1 to qsprite.dtx and 3 do{"berstehende" Pixel in ppp vermerken}
    Inc(ppp[(plane+i - 1) and 3]);{beginnend mit Startplane Pixel anfgen}
asm
  push ds                       {ds sichern}
  mov ax,0a000h                 {Zielsegment (VGA) laden}
  mov es,ax

  lds si,quelle                 {Quelle (Zeiger auf Grafikdaten) nach ds:si}
  mov cx,plane                  {Start-Planemaske erstellen}
  mov ax,1                      {dazu Bit 0 um Plane nach links schieben}
  shl ax,cl
  mov planemask,al              {Maske sichern}
  shl al,4                      {auch in oberes Nibble eintragen}
  or planemask,al
  mov planecount,4              {4 Planes zu kopieren}
@lplane:                        {wird einmal pro Plane durchlaufen}
  mov cl,byte ptr plane         {aktuelle Plane laden}
  mov di,cx                     {in di}
  mov cl,byte ptr ppp[di]       {cx mit zugeh”riger ppp-Anzahl laden}
  mov byte ptr Breite,cl        {Skip jeweils neu ausrechnen}
  mov ax,direction              {dazu Differenz Direction-Breite bilden}
  sub ax,cx
  mov skip,ax                   {und in skip schreiben}

  mov rel_y,0                   {Start wieder bei y=0,0}

  mov cx,Breite                 {cx mit Breite laden}
  or cl,cl                      {Breite 0, dann Plane fertig}
  je @plane_fertig

  mov di,ofs                    {Zieloffset im Bildschirmspeicher nach di}
  mov ah,planemask              {Planemaske auf bit [0..3] reduzieren}
  and ah,0fh
  mov al,02h                    {und ber TS - Register 2 (Write Plane Mask)}
  mov dx,3c4h                   {setzen}
  out dx,ax
  mov bx,dty                    {y-Z„hler initialisieren}
@lcopy_y:                       {y-Schleife, pro Zeile einmal durchlaufen}
@lcopy_x:                       {x-Schleife, pro Punkt einmal durchlaufen}
  lodsb                         {Byte holen}
  or al,al                      {wenn 0, dann berspringen}
  je @Wert0
  stosb                         {ansonsten: setzen}
@entry:
  loop @lcopy_x                 {und Schleife weiter}

  mov ax,rel_y                  {Summanden auf Nachkommateil}
  add ax,add_y
  cmp ax,100                    {Vorkommastelle erh”ht ?}
  jb @noaddovfl                 {nein, dann weiter}
  sub ax,100                    {ansonsten Nachkommastelle zurcksetzen}
  sub di,direction              {und in n„chste/vorherige Zeile}
@noaddovfl:
  mov rel_y,ax                  {und in Nachkommateil zurckschreiben}

  dec bx                        {y-Z„hler weiter}
  je @plane_fertig              {y-Z„hler = 0, dann n„chste Plane}
  add di,skip                   {sonst auf n„chsten Zeilenanfang springen}
  mov cx,Breite                 {x-Z„hler reinitialisieren,}
  jmp @lcopy_y                  {wieder in y-Schleife springen}
@wert0:                         {Sprite-Farbe 0:}
  inc di                        {Zielbyte berspringen}
  jmp @entry                    {und wieder in Schleife zurck}
@plane_fertig:                  {hier ist y-Schleife beendet}

  rol planemask,1               {n„chste Plane maskieren}
  mov cl,planemask              {plane 0 selektiert ?}
  and cx,1                      {(Bit 1 gesetzt), dann}
  add ofs,cx                    {Zieloffset erh”hen um 1 (Bit 1 !)}
  inc plane                     {Plane-Nummer (Index in ppp) weiter}
  and plane,3                   {auf 0 bis 3 reduzieren}
  dec planecount                {schon 4 Planes kopiert ?, dann Ende}
  jne @lplane
  pop ds                        {ds restaurieren, und Tschá}
End;{asm}
End;

Var Logo:SpriteTyp;
    Sinus:Array[0..99] of Word;
    Hoehe:Integer;
    i:Word;


Begin
  Init_ModeX;                   {Mode X einschalten}
  LoadGif('sprites');           {Bild mit Logo laden}
  GetSprite(88+ 6*320,150,82,Logo);    {Logo initialisieren}
  LoadGif('phint');             {Hintergrundbild laden}
  p13_2_ModeX(48000,16000);     {und auf Hintergrundseite kopieren}
  Sin_Gen(Sinus,100,100,0);     {Sinus vorberechnen}
  I:=0;                         {Index im Sinus auf 0}
  repeat
    Inc(i);                     {Index weiterz„hlen}
    Hoehe:=Integer(Sinus[i mod 100]); {Hoehe aus Sinus holen}
    CopyScreen(vpage,48000);    {Hintergrund l”schen}
    PutScalSprt(vpage,85,100-Hoehe *84 div 200,Hoehe,Logo);
                                {Sprite skaliert auf aktuelle Seite kopieren}
    Switch;                     {auf diese Seite umschalten}
    WaitRetrace;                {und auf den Retrace warten}
  Until KeyPressed;
  ReadLn;
  TextMode(3);                  {normalen Text-Mode ein}
End.
