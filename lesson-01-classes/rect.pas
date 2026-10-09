program RectDemo;

{ Класс «Прямоугольник»: площадь и периметр. }

type
  TRect = class
    w, h: Real;

    constructor (a, b: Real);
    begin
      w := a; h := b;
    end;

    function Area: Real;
    begin
      Result := w * h;
    end;

    function Perimeter: Real;
    begin
      Result := 2 * (w + h);
    end;

    procedure Print;
    begin
      WriteLn('Прямоугольник ', w:0:1, ' x ', h:0:1);
      WriteLn('  площадь:   ', Area:0:2);
      WriteLn('  периметр:  ', Perimeter:0:2);
    end;
  end;

var
  r: TRect;

begin
  r := new TRect(3, 5);
  r.Print;

  r := new TRect(10, 2.5);
  r.Print;
end.