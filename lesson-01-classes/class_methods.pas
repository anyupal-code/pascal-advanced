program ClassMethods;

{ Методы внутри класса: процедура и функция. }

type
  TPoint = class
    x, y: Integer;

    procedure Print;
    begin
      WriteLn('(', x, ', ', y, ')');
    end;

    function Dist2: Integer;
    begin
      Result := x * x + y * y;
    end;
  end;

var
  p: TPoint;

begin
  p := new TPoint;
  p.x := 3;
  p.y := 4;

  p.Print;
  WriteLn('Квадрат расстояния: ', p.Dist2);
end.