unit MathUtils;

interface
  function Square(x: Integer): Integer;
  function Cube(x: Integer): Integer;
  function MaxOf(a, b: Integer): Integer;

implementation

function Square(x: Integer): Integer;
begin
  Square := x * x;
end;

function Cube(x: Integer): Integer;
begin
  Cube := x * x * x;
end;

function MaxOf(a, b: Integer): Integer;
begin
  if a > b then MaxOf := a
  else MaxOf := b;
end;

end.