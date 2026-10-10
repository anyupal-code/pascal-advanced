program SelectionDemo;

{ Сортировка выбором. }

procedure SelectionSort(a: array of Integer);
var
  i, j, minIdx, t: Integer;
begin
  for i := 0 to Length(a) - 2 do
  begin
    minIdx := i;
    for j := i + 1 to Length(a) - 1 do
      if a[j] < a[minIdx] then
        minIdx := j;

    if minIdx <> i then
    begin
      t := a[i];
      a[i] := a[minIdx];
      a[minIdx] := t;
    end;
  end;
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
  SelectionSort(a);
  Write('После: '); PrintArr(a);
end.