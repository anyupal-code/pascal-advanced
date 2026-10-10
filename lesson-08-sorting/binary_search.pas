program BinarySearchDemo;

{ Бинарный поиск вручную. }

function BinarySearch(a: array of Integer; target: Integer): Integer;
var
  lo, hi, mid: Integer;
begin
  lo := 0;
  hi := Length(a) - 1;

  while lo <= hi do
  begin
    mid := (lo + hi) div 2;

    if a[mid] = target then
      Exit(mid)
    else if a[mid] < target then
      lo := mid + 1
    else
      hi := mid - 1;
  end;

  BinarySearch := -1;
end;

var
  a: array of Integer;
  target, idx: Integer;

begin
  a := [1, 3, 5, 7, 9, 11, 13, 15, 17, 19];

  target := 11;
  idx := BinarySearch(a, target);

  if idx >= 0 then
    WriteLn('Найдено ', target, ' в позиции ', idx)
  else
    WriteLn('Не найдено');

  target := 8;
  idx := BinarySearch(a, target);

  if idx >= 0 then
    WriteLn('Найдено ', target, ' в позиции ', idx)
  else
    WriteLn(target, ' не найдено');
end.