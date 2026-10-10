program InterfaceBasic;

{ Объявление и реализация интерфейса. }

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

var
  s: IShape;

begin
  s := new TCircle(2);
  s.Print;
end.