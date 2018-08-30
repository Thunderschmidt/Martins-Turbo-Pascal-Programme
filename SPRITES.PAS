{$G+}
Unit Sprites;

Interface

Type SpriteTyp=Record           {Aufbau eines Sprite-Datenblocks}
  Adr:Pointer;                  {Zeiger auf Grafik-Daten}
  dtx,dty:Word;                 {Breite und H”he in Pixel}
  px,py,                        {gegenw„rtige Position, optional *}
  sx,sy:Integer;                {gegenw„rtige Geschwindigkeit, optional *}
End;
{*: optional bedeutet, daá die Sprite-Routinen GetSprite und PutSprite
 von diesen Angaben keinen Gebrauch machen, die Variablen dienen lediglich
 dazu, eine Steuerung seitens des Hauptprogramms zu erleichtern}

Procedure GetSprite(Ofs,dtx,dty:Word;var zSprite:SpriteTyp);
{lies ein Sprite aus vscreen-Offset ofs, mit Breite dtx und H”he dty,
 zsprite ist der Sprite-Record, in dem Sprite gespeichert werden soll}

Procedure PutSprite(pg_ofs,x,y:Integer;qsprite:spritetyp);
{kopiert Sprite aus Hauptspeicher (Lage und Gr”áe werden qsprite entnommen)
 auf Bildschirmspeicher Seite pg an Position (x/y)}


Implementation
Uses ModeXLib;

Var i:Word;

Procedure GetSprite;
Var ppp:Array[0..3] of Byte;    {Tabelle mit Anzahl zu kopierender Pixel}
                                {pro Plane}
    Skip:word;                  {Anzahl zu berspringender Bytes}
    Plane_Count:Word;           {Z„hler der bereits kopierten Planes}
Begin
  GetMem(zsprite.adr,dtx*dty);  {Hauptspeicher allokieren}
  zsprite.dtx:=dtx;             {im Sprite-Record Breite und H”he vermerken}
  zsprite.dty:=dty;

  i:=dtx shr 2;                 {Anzahl glatter Viererbl”cke}
  ppp[0]:=i;ppp[1]:=i;          {entspricht Mindestanzahl zu kop. Bytes}
  ppp[2]:=i;ppp[3]:=i;
  For i:=1 to dtx and 3 do      {"berstehende" Pixel in ppp vermerken}
    Inc(ppp[(i-1) and 3]);      {beginnend mit Startplane Pixel anfgen}
  Plane_Count:=4;               {4 Planes kopieren}
asm
  push ds
  mov di,word ptr zsprite       {zun„chst Zeiger auf Daten-Block laden}
  les di,[di]                   {Zeiger auf Grafikdaten in es:di laden}
  lea bx,ppp                    {bx zeigt auf ppp-Array}

  lds si,vscreen                {Zeiger auf Bild laden}
   add Ofs,si                   {Offset der eigentlichen Sprite-Daten dazu}
@lcopy_plane:                   {wird einmal pro Plane durchlaufen}
  mov si,ofs                    {si mit Startadresse der Sprite-Daten laden}
  mov dx,dty                    {y-Z„hler mit Zeilenzahl laden}

  xor ah,ah                     {ah l”schen}
  mov al,ss:[bx]                {al mit aktuelem ppp-Eintrag laden}
  shl ax,2                      {es werden jeweils 4er-Bl”cke bewegt}
  sub ax,320                    {Differenz zur 320 bilden}
  neg ax                        {aus ax-320 320-ax machen}
  mov skip,ax                   {Wert in Skip sichern}

@lcopy_y:                       {wird einmal pro Zeile durchlaufen}
  mov cl,ss:[bx]                {Breite aus ppp-Array laden}
@lcopy_x:                       {wird einmal pro Punkt durchlaufen}
  movsb                         {Byte kopieren}
  add si,3                      {auf n„chsten Punkt dieser Plane}
  dec cl                        {alle Punkte dieser Zeile kopieren}
  jne @lcopy_x

  add si,skip                   {danach auf Anfang der n„chsten Zeile}
  dec dx                        {alle Zeilen kopieren}
  jne @lcopy_y

  inc bx                        {auf n„chsten ppp-Eintrag positionieren}
  inc ofs                       {auf neuen Plane-Start positionieren}
  dec plane_count               {alle Planes kopieren}
  jne @lcopy_plane

  pop ds
End;
End;

Procedure PutSprite;
var plane_count,                {Z„hler der bereits kopierten Planes}
    planemask:Byte;             {maskiert Write-Plane in TS-Register 2}
    Skip,                       {Anzahl zu berspringender Bytes}
    ofs,                        {aktueller Offset im Bildschirmspeicher}
    plane,                      {Nummer der aktuellen Plane}
    Breite,                     {Breite zu kopierender Bytes in einer Zeile,}
    dty:Word;                   {H”he}
    quelle:Pointer;             {Zeiger auf Grafikdaten, wenn ds ver„ndert}
    clip_lt, clip_rt:integer;   {Anzahl links und rechts berstehender PIXEL}
    clipakt_lt,                 {bei aktueller Plane aktive Anzahl}
    clipakt_rt,                 {berstehender BYTES}
    clip_dn,clip_up:Word;       {Anzahl oben und unten berstehender ZEILEN}

    ppp:Array[0..3] of Byte;    {Anzahl Pixel pro Plane}
    cpp:Array[0..3] of Byte;    {berstehende BYTES pro Plane}

Begin
  if (x > 319) or               {Darstellung berflssig, }
  (x+qsprite.dtx < 0) or        {weil gar nicht im Bild ?}
  (y > 199) or
  (y+qsprite.dty < 0) then exit;
  clip_rt:=0;                   {im Normalfall kein Clipping}
  clip_lt:=0;                   {-> alle Clipping-Variablen auf 0}
  clip_dn:=0;
  clip_up:=0;
  clipakt_rt:=0;
  clipakt_lt:=0;
   with qsprite do begin
    if y+dty > 200 then begin   {erster Clipping Fall: unten}
      clip_dn:=(y+dty-200);     {berstehende Zeilen vermerken}
      dty:=200-y;               {und Sprite-H”he reduzieren}
    End;
    if y<0 then begin           {zweiter Clipping Fall: oben}
      clip_up:=-y;              {berstehende Zeilen vermerken}
      dty:=dty+y;               {und Sprite-H”he reduzieren}
      y:=0;                     {Start-y ist 0, weil oberer Bildrand}
    End;
    if x+dtx > 320 then begin   {dritter Clipping Fall: rechts}
      clip_rt:=x+dtx-320;       {berstehende Pixel vermerken}
      dtx:=320-x;               {Breite reduzieren}
    End;
    if x<0 then begin           {vierter Clipping Fall: links}
      clip_lt:=-x;              {berstehende Pixel vermerken}
      plane:=4-(clip_lt mod 4); {neue Startplane fr Spalte 0 berechnen}
      plane:=plane and 3;       {diese auf 0..3 reduzieren}
      ofs:=pg_ofs+80*y+((x+1) div 4) - 1;  {Ofs auf korrekten 4er-Block setzen}
      x:=0;                     {Darstellung in Spalte beginnen}
    End Else Begin              {rechts kein Clipping ?}
      plane:=x mod 4;           {dann konventionelle Berechnung von Plane}
      ofs:=pg_ofs+80*y+(x div 4); {und Offset}
    End;
  End;
  Quelle:=qsprite.adr;          {Zeiger Grafik-Daten}
  dty:=qsprite.dty;             {und H”he in lok. Variablen sichern}
  Breite:=0;                    {Breite und Skip vorinitialisieren}
  Skip:=0;

  i:=qsprite.dtx shr 2;         {Anzahl glatter Viererbl”cke}
  ppp[0]:=i;ppp[1]:=i;          {entspricht Mindestanzahl zu kop. Bytes}
  ppp[2]:=i;ppp[3]:=i;
  For i:=1 to qsprite.dtx and 3 do{"berstehende" Pixel in ppp vermerken}
    Inc(ppp[(plane+i - 1) and 3]);{beginnend mit Startplane Pixel anfgen}

  i:=(clip_lt+clip_rt) shr 2;
  cpp[0]:=i;cpp[1]:=i;          {Clipping-Vorgabe : alle Seiten 0}
  cpp[2]:=i;cpp[3]:=i;
  For i:=1 to clip_rt and 3 do  {wenn rechts Clipping entsprechende Anzahl}
    Inc(cpp[i-1]);              {in Planes eintragen}
  For i:=1 to clip_lt and 3 do  {wenn rechts Clipping entsprechende Anzahl}
    Inc(cpp[4-i]);              {in Planes eintragen}

asm
  mov dx,3ceh                   {GDC Register 5 (GDC Mode)}
  mov ax,4005h                  {auf Write Mode 0 setzen}
  out dx,ax
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
  mov plane_count,4             {4 Planes zu kopieren}
@lplane:                        {wird einmal pro Plane durchlaufen}
  mov cl,byte ptr plane         {aktuelle Plane laden}
  mov di,cx                     {in di}
  mov cl,byte ptr ppp[di]       {cx mit zugeh”riger ppp-Anzahl laden}
  mov byte ptr Breite,cl        {Skip jeweils neu ausrechnen}
  mov ax,80                     {dazu Differenz 80-Breite bilden}
  sub al,cl
  mov byte ptr skip,al          {und in skip schreiben}

  mov al,byte ptr cpp[di]       {Plane-spezifische Clipping-Weite laden}
  cmp clip_lt,0                 {wenn links kein Clipping, weiter mit rechts}
  je @rechts
  mov clipakt_lt,ax             {in clip_akt_lt sichern}
  sub Breite,ax                 {Breite zu kopierender Bytes reduzieren}
  jmp @clip_rdy                 {rechts kein Clipping}
@rechts:                        {wenn links kein Clipping}
  mov clipakt_rt,ax             {dazu Clipping fr alle Planes, in clip_akt}
@clip_rdy:
  mov ax,Breite                 {Gesamtbreite in Byte berechnen}
  add ax,clipakt_rt
  add ax,clipakt_lt
  mul clip_up                   {mit Anzahl Zeilen des oberen Clipping mul.}
  add si,ax                     {diese Bytes werden nicht dargestellt}

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
  add si,clipakt_lt             {Quellzeiger um linkes Clipping weiter}
  add di,clipakt_lt             {auch Zielzeiger}
@lcopy:                         {x-Schleife, pro Punkt einmal durchlaufen}
  lodsb                         {Byte holen}
  or al,al                      {wenn 0, dann berspringen}
  je @Wert0
  stosb                         {ansonsten: setzen}
@entry:
  loop @lcopy                   {und Schleife weiter}

  add si,clipakt_rt             {nach kompletter Zeile rechtes Clipping}

  dec bx                        {y-Z„hler weiter}
  je @plane_fertig              {y-Z„hler = 0, dann n„chste Plane}
  add di,skip                   {sonst auf n„chsten Zeilenanfang springen}
  mov cx,Breite                 {x-Z„hler reinitialisieren,}
  jmp @lcopy_y                  {wieder in y-Schleife springen}
@wert0:                         {Sprite-Farbe 0:}
  inc di                        {Zielbyte berspringen}
  jmp @entry                    {und wieder in Schleife zurck}
@plane_fertig:                  {hier ist y-Schleife beendet}
  mov ax,Breite                 {Gesamtbreite in Byte berechnen}
  add ax,clipakt_rt
  add ax,clipakt_lt
  mul clip_dn                   {mit Anzahl Zeilen des unteren Clipping mul.}
  add si,ax                     {diese Bytes werden nicht dargestellt}
  rol planemask,1               {n„chste Plane maskieren}
  mov cl,planemask              {plane 0 selektiert ?}
  and cx,1                      {(Bit 1 gesetzt), dann}
  add ofs,cx                    {Zieloffset erh”hen um 1 (cx Bit 1 !)}
  inc plane                     {Plane-Nummer (Index in ppp) weiter}
  and plane,3                   {auf 0 bis 3 reduzieren}
  dec plane_count               {schon 4 Planes kopiert ?, dann Ende}
  jne @lplane
  pop ds                        {ds restaurieren, und Tschá}
End;{asm}
End;

Begin
End.
