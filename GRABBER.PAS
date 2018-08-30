{$G+}
{$m 1024,0,0}                   {wenig Stack und kein Heap benîtigt}
Uses ModeXLib,Crt,Dos;

Var OldInt9:Pointer;            {Zeiger auf alten Tastaturhandler}
    active:Boolean;             {gesetzt, wenn bereits Hardcopy im Gange}
    nr:Word;                    {Nummer des Bilds, zur Vergabe von Filenamen}
    installiert:Boolean;        {bereits installiert ?}

    Mode,                       {aktueller VGA-Mode: 13h, ffh (Mode X)}
                                {oder 0 (keiner der beiden}
    Split_at,                   {Split-Line (Grafikzeile}
    LSA,                        {Linear Starting Address}
    Skip:Word;                  {Anzahl zu Åberspringender Bytes}

Procedure GetMode;
{bestimmt aktuellen Grafikmodus 13h oder Mode X (Nr. 255)}
{und Rahmendaten (Split-Line, Startadresse)}
Begin
  Mode:=$13;                    {Mode 13h Standard}
  asm                           {Bios-Mode bestimmen}
    mov ax,0f00h                {Funktion: Video-Info}
    int 10h
    cmp al,13h                  {Bios-Mode 13h gesetzt ?}
    je @Bios_ok
    mov mode,0                  {wenn nein -> weder Mode 13h noch X aktiv}
  @bios_ok:
  End;
  If Mode=0 Then Exit;          {falscher Modus -> abbrechen}

  Port[$3c4]:=4;                {TS-Register 4 (Memory Mode) auslesen}
  If Port[$3c5] and 8 = 0 Then  {Chain 4 (Bit 3) inaktiv ?}
    Mode:=$ff;                  {dann Mode X}

  Port[$3d4]:=$0d;              {Linear Starting Address Low (CRTC 0dh)}
  LSA:=Port[$3d5];              {auslesen}
  Port[$3d4]:=$0c;              {Linear Starting Address High (CRTC 0ch)}
  LSA:=LSA or Port[$3d5] shl 8; {auslesen und eintragen}

  Port[$3d4]:=$18;              {Line Compare CRTC 18h}
  Split_at:=Port[$3d5];         {auslesen}
  Port[$3d4]:=7;                {Overflow Low}
  Split_at:=Split_at or         {Bit 4 ausmaskieren und nach Bit 8 schieben}
    (Port[$3d5] and 16) shl 4;
  Port[$3d4]:=9;                {Maximum Row Address}
  Split_at:=Split_at or         {Bit 6 ausmaskieren unf nach Bit 9 schieben}
    (Port[$3d5] and 64) shl 3;
  Split_at:=Split_at shr 1;     {auf Bildschirmzeilen umrechnen}

  Port[$3d4]:=$13;              {Row Offset (CRTC Register 13h)}
  Skip:=Port[$3d5];             {auslesen}
  Skip:=Skip*2-80               {Differenz zum "normalen" Zeilenabstand lesen}
End;


Procedure PCXShift;assembler;
{bereitet aktuelle Palette auf PCX vor (2 nach links shiften)}
asm
  mov si,offset palette         {Zeiger auf Palette in ds:si}
  mov cx,768                    {768 Bytes bearbeiten}
@lp:
  lodsb                         {Wert holen}
  shl al,2                      {shiften}
  mov ds:[si-1],al              {zurÅckschreiben an alte Position}
  loop @lp                      {und Schleife abschlie·en}
End;

Var pcx:File;                   {PCX-Datei auf Platte}

Procedure Hardcopy(Startadr,splt:Word;s : string);
{kopiert Grafik 320x200 (Mode 13 o. X) als PCX in Datei s}
{aktueller Bildschirmstart (Linear Starting Address) in Startadr}
{Split-Zeile in splt}
Var Buf:Array[0..57] of Byte;   {nimmt Daten vor Speichern auf}
    Aux_Ofs:Word;
const
  Header1:Array[0..15] of Byte  {PCX-Kopf, erster Teil}
    =($0a,5,1,8, 0,0, 0,0, $3f,1, 199,0,$40,1,200,0);
  Header2:Array[0..5] of Byte   {PCX-Kopf, erster Teil}
    =(0,1,$40,1,0,0);
  plane:Byte=0;                 {aktuelle Planenr}

var count:Byte;                 {Anzahl gleicher Zeichen}
    wert,                       {gerade geholter Wert}
    lastbyt:Byte;               {vorheriger Wert}
    i:word;                     {Byte-ZÑhler}

begin
asm                             {Palette auslesen}
  xor al,al                     {bei Farbe 0 beginnen}
  mov dx,3c7h                   {dies dem DAC Åber Pixel Read Address}
  out dx,al                     {mitteilen}

  push ds                       {Zeiger es:di auf Palette}
  pop es
  mov di,offset palette
  mov cx,768                    {768 Bytes auslesen}
  mov dx,3c9h                   {Pixel Color Value}
  rep insb                      {und lesen}

  cmp mode,13h                  {Mode X ?}
  je @Linear                    {dann:}
  mov dx,03ceh                  {Schreib- und Lesemodus 0 setzen}
  mov ax,4005h                  {Åber GDC-Register 5 (GDC Mode)}
  out dx,ax
@Linear:
End;

  Assign(pcx,s);                {Datei zum Schreiben îffnen}
  Rewrite(pcx,1);

  BlockWrite(pcx,Header1,16);   {Header Teil 1 schreiben}
  PCXShift;                     {Palette vorbereiten}
  BlockWrite(pcx,palette,48);   {ersten 16 Farben eintragen}
  BlockWrite(pcx,Header2,6);    {Header Teil 1 schreiben}
  FillChar(buf,58,0);           {58 Nullen schreiben (Header fÅllen)}
  BlockWrite(pcx,buf,58);
  plane:=0;                     {mit Plane 0 beginnen}
  count:=1;                     {Anzahl mit 1 initialisieren}
  If splt<200 Then
    If Mode = $ff Then
      splt:=splt*80 Else        {Split-Offset berechnen}
      splt:=splt*320 Else       {je nach Mode unterschiedlich}
    Splt:=$ffff;
  If Mode=$13 Then              {LSA bezieht sich auf das Plane-Modell !}
    Startadr:=Startadr*4;
  for i:=0 to 64000 do Begin    {jeden Punkt bearbeiten}
  If i shr 2 < splt Then
  aux_ofs:=(i div 320) * skip   {Hilfsoffset unter BerÅcksichtigung}
                                {der Zeilenbreite setzen}
  Else
  aux_ofs:=((i shr 2 - splt) div 320) * skip;
                                {bei Splitting Bezug auf VGA-Start}
asm                             {Punkt auslesen}
  mov ax,0a000h                 {Segment laden}
  mov es,ax
  mov si,i                      {Offset laden}
  cmp mode,13h                  {Mode 13h ?}
  je @Linear1
  shr si,2                      {nein, dann Offset berechnen}
@Linear1:
  cmp si,splt                   {Split-Line erreicht ?}
  jb @weiter                    {nein, dann weiter}
  sub si,splt                   {ansonsten alles weitere auf den}
  sub si,startadr               {Bildschirmstart beziehen}
@weiter:
  add si,startadr               {Startadresse drauf}
  add si,aux_ofs                {Hilfs-Offset addieren}

  cmp mode,13h                  {Mode 13h ?}
  je @Linear2                   {nein, dann Mode X Lesemethode}
  mov dx,03ceh                  {Åber GDC-Register 4 (Read Plane Select)}
  mov ah,plane                  {aktuelle Plane selektieren}
  inc plane                     {und weiterschalten}
  mov al,4
  and ah,03h
  out dx,ax
@Linear2:
  mov al,es:[si]                {Byte auslesen}
  mov wert,al                   {und in Variable Wert sichern}
End;
  If i<>0 Then Begin            {beim ersten Byte keine Kompression}
  If (Wert = lastbyt) Then Begin{gleiche Bytes ?}
    Inc(Count);                 {dann ZÑhler erhîhen}
    If (Count=64) or            {ZÑhler schon zu hoch ?}
     (i mod 320 =0)  Then Begin {oder Zeilenanfang ?}
      buf[0]:=$c0 or (count-1); {dann Zwischenspeichern}
      buf[1]:=lastbyt;          {ZÑhlerstand und Wert schreiben}
      count:=1;                 {ZÑhler reinitialisieren}
      BlockWrite(pcx,buf,2);    {und auf die Platte damit}
    End;
  End Else                      {verschiedene Bytes :}
    If (Count > 1) or           {waren es mehrere gleiche ?}
    (lastbyt and $c0 <> 0) Then {Wert zu gro· zum direkten Schreiben ?}
    Begin
      buf[0]:=$c0 or count;     {dann Anzahl und Wert in Datei schreiben}
      buf[1]:=lastbyt;
      lastbyt:=Wert;            {aktuellen Wert fÅr weitere Kompression}
      Count:=1;                 {sichern und reinitialisieren}
      BlockWrite(pcx,buf,2);
    End Else Begin              {einzelnes, legales Byte:}
      buf[0]:=lastbyt;          {direkt schreiben}
      lastbyt:=Wert;            {aktuellen Wert fÅr spÑter sichern}
      BlockWrite(pcx,buf,1);
    End;

  End Else lastbyt:=wert;       {beim ersten Byte nur sichern}
End;
  buf[0]:=$0c;                  {Kennung Palette einfÅgen}
  blockwrite(pcx,buf[0],1);     {und schreiben}
  blockwrite(pcx,palette,256*3);{und Palette anfÅgen}
  Close(pcx);                   {Datei schlie·en}
End;


Procedure Action;
{wird bei Aktivierung des Hot-Keys aufgerufen}
Var nrs:String;                 {String zur Namensvergabe}
Begin
  if not active Then Begin      {nur wenn nicht bereits aktiv}
    active:=true;               {als aktiv vermerken}
    str(nr,nrs);                {Nummer in String umwandeln und erhîhen}
    Inc(nr);
    GetMode;                    {Grafikmodus etc. ermitteln}
    If Mode <> 0 Then
      HardCopy(LSA,Split_at,'hard'+nrs+'.pcx');
                                {Hardcopy durchfÅhren}
    active:=false;              {erneute Aktivierung freigeben}
  End;
End;

Procedure Handler9;interrupt;assembler;
{neuer Interrupt-Handler fÅr Tastatur-IRQ}
asm
   pushf
   call [oldint9]               {alten IRQ 1 - Handler aufrufen}

  cli                           {keine weiteren Interrupts}
  in al,60h                     {Scancode lesen}
  cmp al,34d                    {G ?}
  jne @fertig                   {nein -> Handler beenden}
  xor ax,ax                     {0-Segment laden}
  mov es,ax
  mov al,es:[417h]              {Keyboard-Status lesen}
  test al,8                     {Bit 8 (Alt-Taste) gesetzt ?}
  je @fertig                    {nein -> Handler beenden}

  call action                   {Hardcopy durchfÅhren}
@fertig:
  sti                           {Interrupts wieder zulassen}
End;

Procedure kennung;assembler;
{Dummy-Prozedur, enthÑlt Copyrightmeldung fÅr Installationskennung}
{KEIN AUSFöHRBARER CODE !}
asm
  db 'Screen-Grabber, (c) Data Becker 1994';
End;

Procedure Check_Inst;assembler;
{ÅberprÅft, ob Grabber bereits installiert}
asm
  mov installiert,1             {Annahme: bereits installiert}
  push ds                       {ds wird noch benîtigt !}
  les di,oldint9                {Zeiger auf alten Handler laden}
  mov di,offset kennung         {im gleichen Segment auch Prozedur Kennung}
  mov ax,cs                     {ds:si auf Kennung dieses Programms setzen}
  mov ds,ax
  mov si,offset kennung
  mov cx,20                     {20 Zeichen vergleichen}
  repe cmpsb
  pop ds                        {ds wieder herstellen}
  jcxz @installiert             {gleich, dann bereits installiert}
  mov installiert,0             {nicht installiert: merken}
@installiert:
End;

Begin
  nr:=0;                        {erster Dateiname: hard0.pcx}
  GetIntVec(9,OldInt9);         {alten Interrupt-Vektor holen}
  Check_Inst;                   {prÅfen, ob schon installiert}
  If not installiert Then Begin {wenn nein:}
    SetIntVec(9,@Handler9);     {neuen Handler installieren}
    WriteLn('Grabber installiert');
    WriteLn('(c) Data Becker 1994');
    WriteLn('Aktivierung mit <alt> g');
    Keep(0);                    {Meldung ausgeben und resident beenden}
  End;
  WriteLn('Grabber bereits installiert');
                                {wenn schon installiert, Meldung und beenden}
End.
