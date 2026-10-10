program MergeDemo;

{ Сортировка слиянием. }

procedure MergeSort(a: array of Integer; left, right: Integer);
var
  mid, i, j, k: Integer;
  temp: array of Integer;
begin
  if left >= right then Exit;

  mid := (left + right) div 2;
  MergeSort(a, left, mid);
  MergeSort(a, mid + 1, right);

  SetLength(temp, right - left + 1);
  i := left;
  j := mid + 1;
  k := 0;

  while (i <= mid) and (j <= right) do
  begin
    if a[i] <= a[j] then
    begin
      temp[k] := a[i]; i := i + 1;
    end
    else
    begin
      temp[k] := a[j]; j := j + 1;
    end;
    k := k + 1;
  end;

  while i <= mid do
  begin temp[k] := a[i]; i := i + 1; k := k + 1; end;
  while j <= right do
  begin temp[k] := a[j]; j := j + 1; k := k + 1; end;

  for k := 0 to High(temp) do
    a[left + k] := temp[k];
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
  MergeSort(a, 0, Length(a) - 1);
  Write('После: '); PrintArr(a);
end.