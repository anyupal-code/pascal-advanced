program ListOfObjects;

{ List<TPoint> с переопределённым ToString. }

type
  TPoint = class
  private
    fX, fY: Integer;
  public
    constructor (x, y: Integer);
    begin
      fX := x; fY := y;
    end;

    property X: Integer read fX;
    property Y: Integer read fY;

    function ToString: String; override;
    begin
      Result := '(' + IntToStr(fX) + ', ' + IntToStr(fY) + ')';
    end;
  end;

var
  points: List<TPoint>;

begin
  points := new List<TPoint>;
  points.Add(new TPoint(1, 2));
  points.Add(new TPoint(3, 4));
  points.Add(new TPoint(5, 6));

  foreach var p in points do
    WriteLn(p);
end.