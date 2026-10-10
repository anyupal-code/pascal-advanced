program InsertionDemo;

{ Сортировка вставками. }

procedure InsertionSort(a: array of Integer);
var
  i, j, key: Integer;
begin
  for i := 1 to Length(a) - 1 do
  begin
    key := a[i];
    j := i - 1;
    while (j >= 0) and (a[j] > key) do
    begin
      a[j + 1] := a[j];
      j := j - 1;
    end;
    a[j + 1] := key;
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
  InsertionSort(a);
  Write('После: '); PrintArr(a);
end.