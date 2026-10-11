unit Geometry;

interface

const
  Pi = 3.14159;

type
  TPoint = record
    x, y: Real;
  end;

function Distance(a, b: TPoint): Real;
function CircleArea(r: Real): Real;
function CircleCircumference(r: Real): Real;

implementation

function Distance(a, b: TPoint): Real;
begin
  Distance := Sqrt(Sqr(a.x - b.x) + Sqr(a.y - b.y));
end;

function CircleArea(r: Real): Real;
begin
  CircleArea := Pi * r * r;
end;

function CircleCircumference(r: Real): Real;
begin
  CircleCircumference := 2 * Pi * r;
end;

end.