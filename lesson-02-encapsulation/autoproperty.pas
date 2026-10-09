program AutoProperty;

{ Свойства без геттеров и сеттеров — запись/чтение идут напрямую
  в приватное поле через read fX / write fX. }

type
  TPoint = class
  private
    fX: Integer;
    fY: Integer;

  public
    property X: Integer read fX write fX;
    property Y: Integer read fY write fY;

    procedure Print;
    begin
      WriteLn('(', X, ', ', Y, ')');
    end;
  end;

var
  p: TPoint;

begin
  p := new TPoint;
  p.Print;        { (0, 0) }

  p.X := 3;
  p.Y := 5;
  p.Print;        { (3, 5) }
end.