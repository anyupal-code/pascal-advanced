program ClassConstructor;

{ Конструктор с параметрами. }

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
  a, b: TPoint;

begin
  a := new TPoint(1, 2);
  b := new TPoint(10, 20);

  a.Print;
  b.Print;

  b.x := 100;
  WriteLn('После изменения b:');
  a.Print;
  b.Print;
end.