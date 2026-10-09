program PropertyBasic;

{ Свойство с read/write. }

type
  TPoint = class
  private
    fX, fY: Integer;

    procedure SetX(v: Integer);
    begin
      fX := v;
    end;

    function GetX: Integer;
    begin
      Result := fX;
    end;

  public
    property X: Integer read GetX write SetX;
    property Y: Integer read fY write fY;

    procedure Print;
    begin
      WriteLn('(', fX, ', ', fY, ')');
    end;
  end;

var
  p: TPoint;

begin
  p := new TPoint;
  p.X := 3;
  p.Y := 5;
  p.Print;

  WriteLn('X = ', p.X);
  WriteLn('Y = ', p.Y);
end.