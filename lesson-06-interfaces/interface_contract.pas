program InterfaceContract;

{ Функция работает с интерфейсом, не зная конкретного класса. }

type
  IShape = interface
    function Area: Real;
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
  end;

procedure PrintArea(const s: IShape);
begin
  WriteLn('Площадь: ', s.Area:0:2);
end;

begin
  PrintArea(new TCircle(2));
  PrintArea(new TRect(3, 4));
end.