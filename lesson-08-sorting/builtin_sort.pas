program BuiltinSort;

{ Встроенные Sort и OrderBy. }

var
  a: array of Integer;

begin
  a := [5, 2, 8, 1, 9, 3, 4, 7, 6];

  WriteLn('Исходный:');
  foreach var x in a do Write(x, ' ');
  WriteLn;

  a.Sort;
  WriteLn('После Sort:');
  foreach var x in a do Write(x, ' ');
  WriteLn;

  var desc := a.OrderByDescending(x -> x).ToArray;
  WriteLn('По убыванию:');
  foreach var x in desc do Write(x, ' ');
  WriteLn;
end.