program ClassBasic;

{ Простейший класс с двумя полями. }

type
  TPoint = class
    x, y: Integer;
  end;

var
  p: TPoint;

begin
  p := new TPoint;
  p.x := 3;
  p.y := 5;

  WriteLn('Точка: (', p.x, ', ', p.y, ')');
end.