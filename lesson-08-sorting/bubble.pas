program BubbleDemo;

{ Пузырьковая сортировка. }

procedure BubbleSort(a: array of Integer);
var
  i, j, t: Integer;
begin
  for i := 0 to Length(a) - 2 do
    for j := 0 to Length(a) - 2 - i do
      if a[j] > a[j + 1] then
      begin
        t := a[j];
        a[j] := a[j + 1];
        a[j + 1] := t;
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
  BubbleSort(a);
  Write('После: '); PrintArr(a);
end.