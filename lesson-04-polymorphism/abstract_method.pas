program AbstractMethod;

{ Абстрактный метод: тела нет, реализация — в наследниках. }

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

begin
  SetLength(shapes, 3);
  shapes[0] := new TCircle(2);
  shapes[1] := new TRect(3, 4);
  shapes[2] := new TCircle(1);

  for i := 0 to High(shapes) do
    shapes[i].Print;
end.