program ClassArray;

{ Массив объектов. }

type
  TPoint = class
    x, y: Integer;

    constructor (aX, aY: Integer);
    begin
      x := aX;
      y := aY;
    end;

    procedure Print;
    begin
      WriteLn('(', x, ', ', y, ')');
    end;
  end;

var
  points: array of TPoint;
  n, i: Integer;

begin
  Write('Сколько точек? '); ReadLn(n);
  SetLength(points, n);

  for i := 0 to n - 1 do
    points[i] := new TPoint(i, i * i);

  for i := 0 to n - 1 do
    points[i].Print;
end.