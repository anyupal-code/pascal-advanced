program TypeCheck;

{ Проверка фактического типа: is, as. }

type
  TShape = class
  public
    function Name: String; virtual;
    begin
      Result := 'Фигура';
    end;

    function Area: Real; virtual; abstract;
  end;

  TCircle = class(TShape)
  private
    fR: Real;
  public
    constructor (r: Real);
    begin
      fR := r;
    end;

    function Name: String; override;
    begin
      Result := 'Круг';
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

    function Name: String; override;
    begin
      Result := 'Прямоугольник';
    end;

    function Area: Real; override;
    begin
      Result := fW * fH;
    end;

    function IsSquare: Boolean;
    begin
      Result := Abs(fW - fH) < 1e-9;
    end;
  end;

var
  shapes: array of TShape;
  i: Integer;

begin
  SetLength(shapes, 3);
  shapes[0] := new TCircle(2);
  shapes[1] := new TRect(3, 4);
  shapes[2] := new TRect(5, 5);

  for i := 0 to High(shapes) do
  begin
    Write(shapes[i].Name, ': ', shapes[i].Area:0:2);

    if shapes[i] is TRect then
    begin
      var r := shapes[i] as TRect;
      if r.IsSquare then Write(' (квадрат)');
    end;

    WriteLn;
  end;
end.