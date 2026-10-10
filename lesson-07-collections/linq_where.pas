program LinqWhere;

{ Where, Select, OrderBy. }

var
  nums: List<Integer>;

begin
  nums := new List<Integer>;
  nums.AddRange([5, 2, 8, 1, 9, 3, 4, 7, 6]);

  Write('Чётные:        ');
  foreach var x in nums.Where(x -> x mod 2 = 0) do
    Write(x, ' ');
  WriteLn;

  Write('Квадраты:      ');
  foreach var x in nums.Select(x -> x * x) do
    Write(x, ' ');
  WriteLn;

  Write('По возрастанию:');
  foreach var x in nums.OrderBy(x -> x) do
    Write(' ', x);
  WriteLn;

  Write('По убыванию:   ');
  foreach var x in nums.OrderByDescending(x -> x) do
    Write(' ', x);
  WriteLn;
end.