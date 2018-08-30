unit THX;
interface
uses Graph;

type
  TFill = record
    Pattern                  : Word;
    Color                    : Byte;
  end;

  TOutLine = record
    LineStyle,
    Pattern,
    Thickness                : Word;
    Color                    : Byte;
  end;

  PPoint = ^TPoint;
  PRect = ^TRect;
  PSquare = ^TSquare;
  PCaption = ^TCaption;

  TPoint = object
    x, y                     : Word;
    Procedure                  Assign(ax, ay         : Word);
    Procedure                  Move(mx, my           : Integer);
    Procedure                  Copy(p                : TPoint);
    Function                   Equals(p              : TPoint) : Boolean;
  end;

  TRect = object
    a, b                     : TPoint;
    Procedure                  Assign(ax, ay, bx, by : Word);
    Procedure                  Intersect(r           : TRect);
    Procedure                  Move(mx, my           : Integer);
    Procedure                  Grow(gx, gy           : Integer);
    Procedure                  Copy(r                : TRect);
    Procedure                  Union(r               : TRect);
    Function                   Contains(p            : TPoint) : Boolean;
    Function                   Equals(r              : TRect)  : Boolean;
    Function                   Empty                 : Boolean;
  end;

  TSquare = object(TRect)
    Fill                     : TFill;
    OutLine                  : TOutLine;
    Mode                     : Byte;
    Procedure                  Init;
    Procedure                  Draw;
  end;

  TCaption = object(TSquare)
    CapStr                   : String;
    TextColor                : Byte;
    Procedure                  Init(iCap : String);
    Procedure                  Draw;
  end;

const
  moFill = 1;
  moOutLine = 2;

  stFill : TFill = (Pattern                   : SolidFill;
                    Color                     : Blue);

  stOutLine : TOutLine = (LineStyle           : SolidLn;
                          Pattern             : 0;
                          Thickness           : NormWidth;
                          Color               : White);


implementation

Procedure TPoint.Assign;
begin
  x := ax;
  y := ay
end;

Procedure TPoint.Move;
begin
  Inc(x, mx);
  Inc(y, my)
end;

Function TPoint.Equals;
begin
  Equals := (x = p.x) and (y = p.y)
end;

Procedure TRect.Assign;
begin
  a.x := ax;
  b.x := bx;
  a.y := ay;
  b.y := by
end;

Procedure TPoint.Copy;
begin
  x := p.x;
  y := p.y
end;

Procedure TRect.Intersect;
var r1, r2 : PRect;
    pa, pb  : TPoint;
begin
  r1 := @Self;                          (* erstmal so annehmen *)
  r2 := @r;
  if r.a.x < a.x then begin             (* wer is links ? *)
    r1 := @r;
    r2 := @Self;
  end;
  pa.Assign(r2^.a.x, r1^.a.y);           (* einen Punkt von machen *)
  if r1^.Contains(pa) then begin         (* is der Punkt auch "Links"? *)
    if r2^.a.y > r1^.a.y
      then pa.Assign(r2^.a.x, r2^.a.y)
      else pa.Assign(r2^.a.x, r1^.a.y);
    if r2^.b.x > r1^.b.x
      then pb.x := r1^.b.x
      else pb.x := r2^.b.x;
    if r2^.b.y > r1^.b.y
      then pb.y := r1^.b.y
      else pb.y := r2^.b.y;
    a.Copy(pa);
    b.Copy(pb)
  end
end;

Procedure TRect.Union;
var pa, pb : TPoint;
begin
  if a.x < r.a.x then pa.x := a.x
                 else pa.x := r.a.x;
  if a.y < r.a.y then pa.y := a.y
                 else pa.y := r.a.y;
  if b.x > r.b.x then pb.x := b.x
                 else pb.x := r.b.x;
  if b.y > r.b.y then pb.y := b.y
                 else pb.y := r.b.y;
  a.Copy(pa);
  b.Copy(pb);
end;

Procedure TRect.Move;
begin
  a.Move(mx, my);
  b.Move(mx, my)
end;

Procedure TRect.Grow;
begin
  a.Move(-gx, -gy);
  b.Move(gx, gy)
end;

Procedure TRect.Copy;
begin
  a.Copy(r.a);
  b.Copy(r.b)
end;

Function TRect.Contains;
begin
  Contains := (p.x >= a.x) and (p.x <= b.x) and (p.y >= a.y) and (p.y <= b.y)
end;

Function TRect.Equals;
begin
  Equals := a.Equals(r.a) and b.Equals(r.b)
end;

Function TRect.Empty;
begin
  Empty := a.Equals(b)
end;

Procedure TSquare.Init;
begin
  Fill := stFill;
  OutLine := stOutLine;
  Mode := moFill + moOutLine;
end;

Procedure TSquare.Draw;
begin
  with Fill do SetFillStyle(Pattern, Color);
  with OutLine do begin
    SetColor(Color);
    SetLineStyle(LineStyle, Pattern, Thickness);
  end;
  if (Mode and moFill) = moFill then
    Bar(a.x, a.y, b.x, b.y);
  if (Mode and moOutLine) = moOutLine then
    Rectangle(a.x, a.y, b.x, b.y);
end;

Procedure TCaption.Init;
begin
  TSquare.Init;
  CapStr := iCap;
  TextColor := White;
end;

Procedure TCaption.Draw;
begin
  TSquare.Draw;
  SetTextStyle(DefaultFont, HorizDir, 1);
  SetTextJustify(LeftText, Centertext);
  SetColor(TextColor);
  OutTextXY(a.x + 6, a.y + (b.y - a.y), CapStr);
end;

end.