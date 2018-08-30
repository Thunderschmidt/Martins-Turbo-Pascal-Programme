unit Joystick;

interface

Procedure JoyButton(var B1, B2, b3, b4 : Boolean);
Procedure JoyKoor(var x, y : Integer);

implementation
uses DOS;

Procedure JoyButton;
var Regs : Registers;
begin
  Regs.AH := $84;
  Regs.DX := 0;
  Intr($15, Regs);
  B1 := Regs.AL and 128 = 128;
  B2 := Regs.AL and 64 = 64;
  B3 := Regs.AL and 32 = 32;
  B4 := Regs.AL and 16 = 16;
end;

Procedure JoyKoor;
var Regs : Registers;
begin
  Regs.AH := $84;
  Regs.DX := $1;
  Intr($15, Regs);
  x := Regs.AX;
  y := Regs.BX;
end;

end.