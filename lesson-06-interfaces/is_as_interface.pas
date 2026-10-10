program IsAsInterface;

{ is и as с интерфейсами. }

type
  IShape = interface
    function Area: Real;
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

    procedure Print;
    begin
      WriteLn('Круг: ', Area:0:2);
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

    function IsSquare: Boolean;
    begin
      Result := Abs(fW - fH) < 1e-9;
    end;

    procedure Print;
    begin
      WriteLn('Прямоугольник: ', Area:0:2);
    end;
  end;

var
  shapes: array of IShape;
  i: Integer;

begin
  SetLength(shapes, 3);
  shapes[0] := new TCircle(2);
  shapes[1] := new TRect(3, 4);
  shapes[2] := new TRect(5, 5);

  for i := 0 to High(shapes) do
  begin
    shapes[i].Print;

    if shapes[i] is TRect then
    begin
      var r := shapes[i] as TRect;
      if r.IsSquare then WriteLn('  (квадрат)');
    end;
  end;
end.