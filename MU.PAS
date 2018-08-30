(********************************************************************)
(*                            MU (MouseUnit)                        *)
(*------------------------------------------------------------------*)
(* Aufgabe     : Stellt ein Object mit Mausfunctionen fÅr Standart  *)
(*               VGA (640*480*16) bereit.                           *)
(*------------------------------------------------------------------*)
(* Autor       : Sascha HÅdepohl                                    *)
(* entwickelt  : 24.1.98                                            *)
(********************************************************************)
unit MU;

interface                      (* von "Au·en" sichtbar *)

uses THX;                      (* wegen "TPoint" *)

type

PCursorArray = ^TCursorArray;
TCursorArray = Array[0..32] of Word;

PCursorList = ^TCursorList;
TCursorList = Array[0..7] of PCursorArray;

PMouse = ^TMouse;              (* Ein Zeiger auf Mouse *)
TMouse = object                (* Das Mouse-Object *)
  Cursors     : PCursorList;
  Function      Init(LC : Boolean) : Boolean;
  Procedure     ReSet;
  Procedure     Show;
  Procedure     Hide;
  Procedure     GetPos(var B : Byte; var p : TPoint);
  Procedure     SetPos(p : TPoint);
  Procedure     CountPress(var B, Count : Byte; var p : TPoint);
  Procedure     CountRel(var B, Count : Byte; var p : TPoint);
  Procedure     SetCursor(n : Byte);
  Function      LoadCursor : Boolean;
  Procedure     Done;
end;

implementation                 (* Die Implementation der Methoden *)
uses DOS;                      (* wegen "Registers" und "Intr" *)

(********************************************************************)
(* TMouse.Init: Initialisiert das Mausobject, besonders die         *)
(*              Cursorverwaltung                                    *)
(*------------------------------------------------------------------*)
(* Eingabe: LC : Boolean = Cursor laden ja/nein                     *)
(* Ausgabe: Boolean True : Maustreiber gefunden                     *)
(*                  False : kein Treiber oder Fehler bei LoadCursor *)
(********************************************************************)
Function TMouse.Init;
var Regs : Registers;
    ok : Boolean;
begin
  Cursors := nil;
  Regs.AX := $0021;
  Intr($33, Regs);
  ok := Regs.AX = $FFFF;
  if ok and lc then ok := LoadCursor;
  Init := ok;
end;

(********************************************************************)
(* TMouse.ReSet: Initialisiert den Maustreiber und leitet damit die *)
(*               Abfrage der Maus ein.                              *)
(*------------------------------------------------------------------*)
(* Eingabe: keine                                                   *)
(* Ausgabe: keine                                                   *)
(********************************************************************)
Procedure TMouse.ReSet;
var Regs : Registers;
begin
  Regs.AX := $0001;            (* Funktionsnummer ins AX-Register laden *)
  Intr($33, Regs);             (* Interrupt $33 aufrufen *)
end;                           (* fertig *)


(********************************************************************)
(* TMouse.Show: Maus-Cursor auf dem Bildschirm anzeigen             *)
(*------------------------------------------------------------------*)
(* Eingabe: keine                                                   *)
(* Ausgabe: keine                                                   *)
(********************************************************************)
Procedure TMouse.Show;
var Regs : Registers;
begin
  Regs.AX := $0001;
  Intr($33, Regs);
end;

(********************************************************************)
(* TMouse.Hide: Maus-Cursor ausblenden                              *)
(*------------------------------------------------------------------*)
(* Eingabe: keine                                                   *)
(* Ausgabe: keine                                                   *)
(********************************************************************)
Procedure TMouse.Hide;
var Regs : Registers;
begin
  Regs.AX := $0002;
  Intr($33, Regs)
end;

(********************************************************************)
(* TMouse.GetPos: Mausposition und Status der Mausknîpfe ermitteln  *)
(*------------------------------------------------------------------*)
(* Eingabe: keine                                                   *)
(* Ausgabe: B : Status der Mausknîpfe                               *)
(*                 Bit      Bedeutung                               *)
(*                 0        1 = linker Mausknopf niedergedrÅckt     *)
(*                 1        1 = rechter Mausknopf niedergedrÅckt    *)
(*                 2        1 = mittlerer Mausknopf niedergedrÅckt  *)
(*                 3-15     keine Bedeutung (0)                     *)
(*          P : Position des Maus-Cursors (TPoint)                  *)
(********************************************************************)
Procedure TMouse.GetPos;
var Regs : Registers;
begin
  Regs.AX := $0003;
  Intr($33, Regs);
  B := Regs.BX;
  p.x := Regs.CX;
  p.y := Regs.DX
end;

(********************************************************************)
(* TMouse.SetPos: Bewegt den Maus-Cursor                            *)
(*------------------------------------------------------------------*)
(* Eingabe: p = neue Position                                       *)
(* Ausgabe: keine                                                   *)
(********************************************************************)
Procedure TMouse.SetPos;
var Regs : Registers;
begin
  with Regs do begin
    AX := $0004;
    CX := p.x;
    DX := p.y;
  end;
  Intr($33, Regs)
end;


(********************************************************************)
(* TMouse.CountPress: Wie oft wurde ein Mausknopf betÑtigt (seit    *)
(*                    letzten Aufruf dieser Funktion) und           *)
(*                    wo befand sich die Maus beim letzten mal?     *)
(*------------------------------------------------------------------*)
(* Eingabe: B = angesprochener Knopf (siehe GetPos)                 *)
(* Ausgabe: B = Status aller Mausknîpfe (siehe GetPos)              *)
(*          Count = Anzahl der betÑtigungen des angesprochenen      *)
(*                  Mausknopfs                                      *)
(*          p = position der Maus bei letzter BetÑtigung des Knopfs *)
(********************************************************************)
Procedure TMouse.CountPress;
var Regs : Registers;
begin
  Regs.AX := $0005;
  Regs.BX := B;
  Intr($33, Regs);
  B := Regs.AX;
  Count := Regs.BX;
  p.x := Regs.CX;
  p.y := Regs.DX
end;


(********************************************************************)
(* TMouse.CountRel: Wie oft wurde ein Mausknopf losgelassen (seit   *)
(*                  letzten Aufruf dieser Funktion) und             *)
(*                  wo befand sich die Maus beim letzten mal?       *)
(*------------------------------------------------------------------*)
(* Eingabe: B = angesprochener Knopf (siehe GetPos)                 *)
(* Ausgabe: B = Status aller Mausknîpfe (siehe GetPos)              *)
(*          Count = Anzahl der betÑtigungen des angesprochenen      *)
(*                  Mausknopfs                                      *)
(*          p = position der Maus bei letzter BetÑtigung des Knopfs *)
(********************************************************************)
Procedure TMouse.CountRel;
var Regs : Registers;
begin
  Regs.AX := $0006;
  Regs.BX := B;
  Intr($33, Regs);
  B := Regs.AX;
  Count := Regs.BX;
  p.x := Regs.CX;
  p.y := Regs.DX
end;


(********************************************************************)
(* TMouse.SetCursor: Setzt einen anderen Cursor                     *)
(*------------------------------------------------------------------*)
(* Eingabe: n = Nummer des zu benutzenden Cursors                   *)
(* Ausgabe: keine                                                   *)
(*------------------------------------------------------------------*)
(* Achtung!!!: es wird nicht geprÅft, ob Åberhaupt Cursor geladen   *)
(*             sind A-B-S-T-U-R-Z-G-E-F-A-H-R ! ! ! !               *)
(********************************************************************)
Procedure TMouse.SetCursor;
var Regs : Registers;
begin
  with Regs do begin
    AX := $0009;
    BX := lo(Cursors^[n]^[32]);
    CX := hi(Cursors^[n]^[32]);
    ES := Seg(Cursors^[n]^);
    DX := Ofs(Cursors^[n]^);
  end;
  Intr($33, Regs);
end;


(********************************************************************)
(* TMouse.LoadCursor: LÑd die CursorListe mit Definitionen          *)
(*------------------------------------------------------------------*)
(* Eingabe: keine                                                   *)
(* Ausgabe: Boolean : True = Erfolgreich                            *)
(*                    False = Ein Fehler ist aufgetreten            *)
(********************************************************************)
Function TMouse.LoadCursor;
var i : Byte;                           (* ZÑhler *)
    Datei : File of TCursorArray;          (* eine Cursordatei *)
    s : String;                            (* ein String *)
begin
  New(Cursors);
  for i := 0 to 7 do
    New(Cursors^[i]);
  for i := 0 to 7 do begin
    Str(i, s);
    Assign(Datei, 'cursor' + s + '.cur');
    System.ReSet(Datei);
    Read(Datei, Cursors^[i]^);
    Close(Datei);
  end;
end;

Procedure TMouse.Done;
var Regs : Registers;
    i    : Byte;
begin
  if Cursors <> nil then begin
    for i := 0 to 7 do
      Dispose(Cursors^[i]);
    Dispose(Cursors);
  end;
  Regs.AX := $0021;
  Intr($33, Regs);
end;

end.