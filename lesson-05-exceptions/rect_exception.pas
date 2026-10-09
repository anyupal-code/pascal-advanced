program RectException;

{ Проверка в конструкторе. }

type
  TRect = class
  private
    fW, fH: Real;
  public
    constructor (w, h: Real);
    begin
      if (w <= 0) or (h <= 0) then
        raise new System.ArgumentException('Стороны должны быть > 0');
      fW := w; fH := h;
    end;

    property Width: Real read fW;
    property Height: Real read fH;

    function Area: Real;
    begin
      Result := fW * fH;
    end;
  end;

var
  r: TRect;

begin
  try
    r := new TRect(3, 4);
    WriteLn('Площадь: ', r.Area:0:2);

    r := new TRect(3, 0);
  except
    on E: System.ArgumentException do
      WriteLn('Ошибка: ', E.Message);
  end;
end.