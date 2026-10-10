program ShapesInterface;

{ Иерархия фигур через интерфейс: площадь и периметр. }

type
  IShape = interface
    function Area: Real;
    function Perimeter: Real;
    procedure Print;
  end;

  TCircle = class(IShape)
  private
    fR: Real;
  public
    constructor (r: Real);
    begin
      fR := r;
    end;

    function Area: Real;
    begin
      Result := Pi * fR * fR;
    end;

    function Perimeter: Real;
    begin
      Result := 2 * Pi * fR;
    end;

    procedure Print;
    begin
      WriteLn('Круг: S=', Area:0:2, ' P=', Perimeter:0:2);
    end;
  end;

  TRect = class(IShape)
  private
    fW, fH: Real;
  public
    constructor (w, h: Real);
    begin
      fW := w; fH := h;
    end;

    function Area: Real;
    begin
      Result := fW * fH;
    end;

    function Perimeter: Real;
    begin
      Result := 2 * (fW + fH);
    end;

    procedure Print;
    begin
      WriteLn('Прямоугольник: S=', Area:0:2, ' P=', Perimeter:0:2);
    end;
  end;

var
  shapes: array of IShape;
  i: Integer;

begin
  SetLength(shapes, 3);
  shapes[0] := new TCircle(2);
  shapes[1] := new TRect(3, 4);
  shapes[2] := new TCircle(1);

  for i := 0 to High(shapes) do
    shapes[i].Print;
end.