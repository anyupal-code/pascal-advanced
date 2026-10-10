program ListBasic;

{ List<Integer>: Add, Remove, перебор. }

var
  nums: List<Integer>;
  i: Integer;

begin
  nums := new List<Integer>;

  nums.Add(10);
  nums.Add(20);
  nums.Add(30);
  nums.Add(40);

  WriteLn('Элементов: ', nums.Count);
  WriteLn('nums[0] = ', nums[0]);
  WriteLn('nums[2] = ', nums[2]);

  nums.Remove(20);
  WriteLn('После Remove(20): ', nums.Count);

  nums.RemoveAt(0);
  WriteLn('После RemoveAt(0): ', nums.Count);

  Write('Осталось: ');
  for i := 0 to nums.Count - 1 do
    Write(nums[i], ' ');
  WriteLn;
end.