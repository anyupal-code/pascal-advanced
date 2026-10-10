program WordCount;

{ Подсчёт слов через Dictionary. }

var
  words: array of String;
  counts: Dictionary<String, Integer>;

begin
  words := ['кот', 'пёс', 'кот', 'кот', 'пёс', 'лиса'];

  counts := new Dictionary<String, Integer>;
  foreach var w in words do
  begin
    if counts.ContainsKey(w) then
      counts[w] := counts[w] + 1
    else
      counts[w] := 1;
  end;

  WriteLn('Всего слов:     ', Length(words));
  WriteLn('Уникальных:     ', counts.Count);

  WriteLn('--- Частоты ---');
  foreach var pair in counts do
    WriteLn(pair.Key, ': ', pair.Value);
end.