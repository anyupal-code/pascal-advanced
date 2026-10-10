program DictionaryDemo;

{ Dictionary<String, Integer>: имена и возраста. }

var
  ages: Dictionary<String, Integer>;
  v: Integer;

begin
  ages := new Dictionary<String, Integer>;

  ages['Иван'] := 25;
  ages['Мария'] := 30;
  ages['Пётр'] := 28;

  WriteLn('Всего записей: ', ages.Count);
  WriteLn('Иван: ', ages['Иван']);

  if ages.ContainsKey('Мария') then
    WriteLn('Мария есть в словаре');

  if ages.TryGetValue('Пётр', v) then
    WriteLn('Пётр: ', v);

  WriteLn('--- Все пары ---');
  foreach var pair in ages do
    WriteLn(pair.Key, ': ', pair.Value);
end.