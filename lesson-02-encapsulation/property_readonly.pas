program PropertyReadOnly;

{ Свойство только для чтения. Вычисляемые — через геттер. }

type
  TCircle = class
  private
    fRadius: Real;

    function GetArea: Real;
    begin
      Result := Pi * fRadius * fRadius;
    end;

    function GetCircumference: Real;
    begin
      Result := 2 * Pi * fRadius;
    end;

  public
    constructor (r: Real);
    begin
      fRadius := r;
    end;

    property Radius: Real read fRadius;
    property Area: Real read GetArea;
    property Circumference: Real read GetCircumference;
  end;

var
  c: TCircle;

begin
  c := new TCircle(5);

  WriteLn('Радиус:        ', c.Radius:0:2);
  WriteLn('Площадь:       ', c.Area:0:2);
  WriteLn('Длина окружн.: ', c.Circumference:0:2);
end.