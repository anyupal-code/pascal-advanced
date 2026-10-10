program LinqAggregate;

{ Sum, Min, Max, Average, Count. }

var
  nums: List<Integer>;

begin
  nums := new List<Integer>;
  nums.AddRange([5, 2, 8, 1, 9, 3, 4, 7, 6]);

  WriteLn('Сумма:     ', nums.Sum);
  WriteLn('Минимум:   ', nums.Min);
  WriteLn('Максимум:  ', nums.Max);
  WriteLn('Среднее:   ', nums.Average:0:2);
  WriteLn('Больше 5:  ', nums.Where(x -> x > 5).Count);
end.