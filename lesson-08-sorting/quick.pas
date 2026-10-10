program QuickDemo;

{ Быстрая сортировка. }

procedure QuickSort(a: array of Integer; left, right: Integer);
var
  i, j, pivot, t: Integer;
begin
  if left >= right then Exit;

  pivot := a[(left + right) div 2];
  i := left;
  j := right;

  while i <= j do
  begin
    while a[i] < pivot do i := i + 1;
    while a[j] > pivot do j := j - 1;

    if i <= j then
    begin
      t := a[i];
      a[i] := a[j];
      a[j] := t;
      i := i + 1;
      j := j - 1;
    end;
  end;

  QuickSort(a, left, j);
  QuickSort(a, i, right);
end;

procedure PrintArr(a: array of Integer);
var
  i: Integer;
begin
  for i := 0 to High(a) do
    Write(a[i], ' ');
  WriteLn;
end;

var
  a: array of Integer;

begin
  a := [5, 2, 8, 1, 9, 3, 4, 7, 6];

  Write('До:    '); PrintArr(a);
  QuickSort(a, 0, Length(a) - 1);
  Write('После: '); PrintArr(a);
end.