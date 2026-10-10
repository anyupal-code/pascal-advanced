program CompareSearch;

{ Сравнение линейного и бинарного поиска по числу сравнений. }

function LinearSearchCount(a: array of Integer; target: Integer): Integer;
var
  i, count: Integer;
begin
  count := 0;
  for i := 0 to High(a) do
  begin
    count := count + 1;
    if a[i] = target then
    begin
      LinearSearchCount := count;
      Exit;
    end;
  end;
  LinearSearchCount := count;
end;

function BinarySearchCount(a: array of Integer; target: Integer): Integer;
var
  lo, hi, mid, count: Integer;
begin
  lo := 0;
  hi := Length(a) - 1;
  count := 0;

  while lo <= hi do
  begin
    count := count + 1;
    mid := (lo + hi) div 2;

    if a[mid] = target then
    begin
      BinarySearchCount := count;
      Exit;
    end
    else if a[mid] < target then
      lo := mid + 1
    else
      hi := mid - 1;
  end;

  BinarySearchCount := count;
end;

var
  a: array of Integer;
  i: Integer;

begin
  SetLength(a, 1000);
  for i := 0 to 999 do
    a[i] := i * 2;

  WriteLn('Линейный поиск (число сравнений): ',
    LinearSearchCount(a, 998));
  WriteLn('Бинарный поиск (число сравнений): ',
    BinarySearchCount(a, 998));
end.