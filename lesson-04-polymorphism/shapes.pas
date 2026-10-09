program ShapesDemo;

{ Иерархия фигур: площадь через abstract + override. }

type
  TShape = class
  public
    function Area: Real; virtual; abstract;

    procedure Print;
    begin
      WriteLn('Площадь: ', Area:0:2);
    end;
  end;

  TCircle = class(TShape)
  private
    fR: Real;
  public
    constructor (r: Real);
    begin
      fR := r;
    end;

    function Area: Real; override;
    begin
      Result := Pi * fR * fR;
    end;
  end;

  TRect = class(TShape)
  private
    fW, fH: Real;
  public
    constructor (w, h: Real);
    begin
      fW := w; fH := h;
    end;

    function Area: Real; override;
    begin
      Result := fW * fH;
    end;
  end;

var
  shapes: array of TShape;
  i: Integer;
  total: Real;

begin
  SetLength(shapes, 4);
  shapes[0] := new TCircle(2);
  shapes[1] := new TRect(3, 4);
  shapes[2] := new TCircle(1);
  shapes[3] := new TRect(5, 5);

  total := 0;
  for i := 0 to High(shapes) do
  begin
    shapes[i].Print;
    total := total + shapes[i].Area;
  end;

  WriteLn('Суммарная площадь: ', total:0:2);
end.