(*

Tja Martin hier hassu ein kleines testprogramm f〉n Joystick
is nat〉lich nich ausgereift aber zeigt die verwendung der unit

*)

uses Crt, Joystick;

var b1, b2, b3, b4 : Boolean;
    x, y   : Integer;
    b1s, b2s, b3s, b4s, xs, ys : String;

Procedure WriteXY(x, y : Byte; s : String);
begin
  GoToXY(x, y);
  ClrEol;
  Write(s);
end;

Procedure Maske;
begin
  WriteXY(6, 2, 'Button 1 :');
  WriteXY(6, 3, 'Button 2 :');
  WriteXY(6, 4, 'Button 3 :');
  WriteXY(6, 5, 'Button 4 :');
  WriteXY(4, 7, 'X-Stellung :');
  WriteXY(4, 8, 'Y-Stellung :');
end;

Procedure Konvert;
var s : String;
begin
  b1s := 'gedr…kt';
  b2s := 'gedr…kt';
  b3s := 'gedr…kt';
  b4s := 'gedr…kt';
  if b1 then b1s := 'nicht ' + b1s;
  if b2 then b2s := 'nicht ' + b2s;
  if b3 then b3s := 'nicht ' + b3s;
  if b4 then b4s := 'nicht ' + b4s;
  Str(x, s);
  xs := s;
  Str(y, s);
  ys := s;
end;

Procedure Ausgabe;
begin
  Konvert;
  WriteXY(20, 2, b1s);
  WriteXY(20, 3, b2s);
  WriteXY(20, 4, b3s);
  WriteXY(20, 5, b4s);
  WriteXY(20, 7, xs);
  WriteXY(20, 8, ys);
end;

begin
  ClrScr;
  Maske;
  repeat
    JoyButton(b1, b2, b3, b4);
    JoyKoor(x, y);
    Ausgabe;
  until KeyPressed;
end.