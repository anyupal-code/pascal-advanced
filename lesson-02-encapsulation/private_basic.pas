program PrivateBasic;

{ Приватные поля и публичные методы доступа. }

type
  TPoint = class
  private
    fX, fY: Integer;
  public
    procedure SetX(v: Integer);
    begin
      fX := v;
    end;

    function GetX: Integer;
    begin
      Result := fX;
    end;

    procedure SetY(v: Integer);
    begin
      fY := v;
    end;

    function GetY: Integer;
    begin
      Result := fY;
    end;

    procedure Print;
    begin
      WriteLn('(', fX, ', ', fY, ')');
    end;
  end;

var
  p: TPoint;

begin
  p := new TPoint;
  p.SetX(3);
  p.SetY(5);
  p.Print;

  WriteLn('X = ', p.GetX);
  WriteLn('Y = ', p.GetY);
end.