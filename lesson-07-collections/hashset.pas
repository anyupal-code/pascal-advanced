program HashSetDemo;

{ HashSet<Integer>: уникальные значения. }

var
  nums: List<Integer>;
  unique: HashSet<Integer>;

begin
  nums := new List<Integer>;
  nums.AddRange([1, 2, 2, 3, 3, 3, 4, 5, 5]);

  unique := new HashSet<Integer>;
  foreach var x in nums do
    unique.Add(x);

  WriteLn('Всего чисел:     ', nums.Count);
  WriteLn('Уникальных:      ', unique.Count);

  Write('Уникальные: ');
  foreach var x in unique do
    Write(x, ' ');
  WriteLn;
end.