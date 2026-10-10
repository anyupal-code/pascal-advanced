# Урок 7. Generics и коллекции .NET

## Цель

Освоить стандартные коллекции .NET: `List<T>`, `Dictionary<K,V>`,
`HashSet<T>`, `Stack<T>`, `Queue<T>`. Научиться пользоваться
готовыми структурами вместо ручных массивов, а также
базовыми LINQ-подобными операциями.

## Ключевые понятия

- **Generic (обобщённый тип)** — класс, параметризованный типом: `List<T>`.
- **`List<T>`** — динамический список.
- **`Dictionary<K,V>`** — словарь «ключ → значение».
- **`HashSet<T>`** — множество уникальных элементов.
- **`Stack<T>`** — стек (LIFO).
- **`Queue<T>`** — очередь (FIFO).
- **LINQ-подобные методы** — `Where`, `Select`, `OrderBy`, `Sum` и т.д.

---

## 1. Что такое generics

**Generic** — это «шаблон» класса, в который подставляется тип.

```pascal
var
  numbers: List<Integer>;
  names: List<String>;
  points: List<TPoint>;
```

- `List<Integer>` — список целых.
- `List<String>` — список строк.
- `List<TPoint>` — список объектов своего класса.

Один класс `List<T>` работает с любым типом. Проверка типов — на этапе компиляции.

---

## 2. `List<T>` — динамический список

```pascal
var
  nums: List<Integer>;
begin
  nums := new List<Integer>;

  nums.Add(10);
  nums.Add(20);
  nums.Add(30);

  WriteLn(nums.Count);       { 3 }
  WriteLn(nums[0]);          { 10 }
  WriteLn(nums[2]);          { 30 }
end.
```

### Основные методы и свойства

| Метод / свойство | Что делает |
|---|---|
| `Add(x)` | добавить в конец |
| `Insert(i, x)` | вставить на позицию `i` |
| `Remove(x)` | удалить первое вхождение |
| `RemoveAt(i)` | удалить по индексу |
| `Clear` | очистить |
| `Contains(x)` | есть ли элемент |
| `IndexOf(x)` | индекс первого вхождения (-1, если нет) |
| `Count` | количество элементов |
| `nums[i]` | доступ по индексу |

### Перебор

```pascal
foreach var n in nums do
  WriteLn(n);

for var i := 0 to nums.Count - 1 do
  WriteLn(nums[i]);
```

### Инициализация значениями

```pascal
var
  nums: List<Integer> := new List<Integer>;
begin
  nums.AddRange([1, 2, 3, 4, 5]);
  ...
end.
```

> Если `:= new List<Integer>` не компилируется — разделите объявление и создание:
> ```pascal
> var nums: List<Integer>;
> nums := new List<Integer>;
> ```

---

## 3. `List<T>` с объектами

```pascal
type
  TPoint = class
  private
    fX, fY: Integer;
  public
    constructor (x, y: Integer);
    begin
      fX := x; fY := y;
    end;

    property X: Integer read fX;
    property Y: Integer read fY;

    function ToString: String; override;
    begin
      Result := '(' + fX + ', ' + fY + ')';
    end;
  end;

var
  points: List<TPoint>;
begin
  points := new List<TPoint>;
  points.Add(new TPoint(1, 2));
  points.Add(new TPoint(3, 4));

  foreach var p in points do
    WriteLn(p);
end.
```

> `ToString` переопределён — тогда `WriteLn(p)` печатает объект по-человечески.
> Без этого вывелось бы имя типа.

---

## 4. `Dictionary<K,V>` — словарь

Хранит пары «ключ → значение». Ключи уникальны.

```pascal
var
  ages: Dictionary<String, Integer>;
begin
  ages := new Dictionary<String, Integer>;

  ages['Иван'] := 25;
  ages['Мария'] := 30;
  ages['Пётр'] := 28;

  WriteLn(ages['Иван']);           { 25 }
  WriteLn(ages.ContainsKey('Мария'));  { True }
  WriteLn(ages.Count);             { 3 }
end.
```

### Основные операции

| Метод / свойство | Что делает |
|---|---|
| `d[key] := value` | добавить или обновить |
| `d[key]` | получить значение (ошибка, если ключа нет) |
| `ContainsKey(key)` | есть ли ключ |
| `TryGetValue(key, out v)` | получить безопасно |
| `Remove(key)` | удалить пару |
| `Keys` | все ключи |
| `Values` | все значения |
| `Count` | количество пар |

### Перебор

```pascal
foreach var pair in ages do
  WriteLn(pair.Key, ': ', pair.Value);
```

### Безопасное чтение — `TryGetValue`

```pascal
var
  v: Integer;
begin
  if ages.TryGetValue('Иван', v) then
    WriteLn('Иван: ', v)
  else
    WriteLn('Нет такого ключа');
end.
```

---

## 5. `HashSet<T>` — множество

Хранит **уникальные** элементы. Порядок не важен.

```pascal
var
  s: HashSet<Integer>;
begin
  s := new HashSet<Integer>;
  s.Add(1);
  s.Add(2);
  s.Add(1);      { дубликат — не добавится }

  WriteLn(s.Count);        { 2 }
  WriteLn(s.Contains(1));  { True }
  s.Remove(1);
end.
```

Полезно для:

- удаления дубликатов,
- быстрой проверки «есть/нет»,
- операций над множествами.

### Операции над множествами

```pascal
var a, b: HashSet<Integer>;
begin
  a := new HashSet<Integer>;
  b := new HashSet<Integer>;
  a.Add(1); a.Add(2); a.Add(3);
  b.Add(2); b.Add(3); b.Add(4);

  a.IntersectWith(b);   { a = {2, 3} — пересечение }
  a.UnionWith(b);       { a = {1, 2, 3, 4} — объединение }
  a.ExceptWith(b);      { a = {1} — разность }
end.
```

---

## 6. `Stack<T>` — стек (LIFO)

«Последний пришёл — первый вышел».

```pascal
var
  st: Stack<Integer>;
begin
  st := new Stack<Integer>;
  st.Push(1);
  st.Push(2);
  st.Push(3);

  WriteLn(st.Pop);    { 3 }
  WriteLn(st.Pop);    { 2 }
  WriteLn(st.Peek);   { 1 — посмотреть, не удаляя }
  WriteLn(st.Count);  { 1 }
end.
```

| Метод | Что делает |
|---|---|
| `Push(x)` | положить наверх |
| `Pop` | снять верхний |
| `Peek` | посмотреть верхний |
| `Count` | сколько элементов |

Применение: отмена действий, обход дерева, разбор выражений.

---

## 7. `Queue<T>` — очередь (FIFO)

«Первый пришёл — первый вышел».

```pascal
var
  q: Queue<String>;
begin
  q := new Queue<String>;
  q.Enqueue('Иван');
  q.Enqueue('Мария');
  q.Enqueue('Пётр');

  WriteLn(q.Dequeue);   { Иван }
  WriteLn(q.Dequeue);   { Мария }
  WriteLn(q.Peek);      { Пётр }
end.
```

| Метод | Что делает |
|---|---|
| `Enqueue(x)` | добавить в конец |
| `Dequeue` | извлечь из начала |
| `Peek` | посмотреть начало |
| `Count` | сколько элементов |

Применение: обработка задач по порядку, буферы, обход в ширину.

---

## 8. LINQ-подобные методы

В PascalABC.NET у коллекций есть методы, похожие на LINQ из C#.
Они возвращают **новые** последовательности, не меняя исходную.

### `Where` — фильтр

```pascal
var
  nums: List<Integer>;
  evens: sequence of Integer;
begin
  nums := new List<Integer>;
  nums.AddRange([1, 2, 3, 4, 5, 6]);

  evens := nums.Where(x -> x mod 2 = 0);
  foreach var x in evens do
    Write(x, ' ');           { 2 4 6 }
end.
```

- `x -> x mod 2 = 0` — **лямбда-выражение** (анонимная функция).
- `x` — параметр, после `->` — возвращаемое значение.

### `Select` — преобразование

```pascal
var
  squares := nums.Select(x -> x * x);
foreach var s in squares do
  Write(s, ' ');
```

### `OrderBy` / `OrderByDescending` — сортировка

```pascal
foreach var x in nums.OrderBy(x -> x) do
  Write(x, ' ');

foreach var x in nums.OrderByDescending(x -> x) do
  Write(x, ' ');
```

Для сортировки по полю объекта:

```pascal
points.OrderBy(p -> p.X)
```

### `Sum`, `Min`, `Max`, `Average`, `Count`

```pascal
WriteLn(nums.Sum);
WriteLn(nums.Min);
WriteLn(nums.Max);
WriteLn(nums.Average:0:2);
WriteLn(nums.Where(x -> x > 3).Count);
```

### Цепочки

```pascal
nums
  .Where(x -> x mod 2 = 0)
  .Select(x -> x * x)
  .OrderByDescending(x -> x)
```

---

## 9. Что выбрать

| Задача | Коллекция |
|---|---|
| Список, порядок важен | `List<T>` |
| Пары «ключ → значение» | `Dictionary<K,V>` |
| Уникальные элементы, порядок не важен | `HashSet<T>` |
| LIFO | `Stack<T>` |
| FIFO | `Queue<T>` |
| Фильтр / сортировка / преобразование | LINQ-методы поверх коллекции |

---

## 10. Типичные задачи

### Список студентов, средний балл

```pascal
var
  group: List<TStudent>;
  sum: Real;
begin
  group := new List<TStudent>;
  group.Add(new TStudent('Иван', 4.5));
  group.Add(new TStudent('Мария', 4.8));
  group.Add(new TStudent('Пётр', 4.2));

  sum := 0;
  foreach var s in group do
    sum := sum + s.Avg;

  WriteLn('Средний балл: ', (sum / group.Count):0:2);
end.
```

### Словарь: подсчёт слов

```pascal
var
  counts: Dictionary<String, Integer>;
  words: array of String;
begin
  words := ['кот', 'пёс', 'кот', 'кот', 'пёс'];

  counts := new Dictionary<String, Integer>;
  foreach var w in words do
  begin
    if counts.ContainsKey(w) then
      counts[w] := counts[w] + 1
    else
      counts[w] := 1;
  end;

  foreach var pair in counts do
    WriteLn(pair.Key, ': ', pair.Value);
end.
```

### Уникальные элементы через `HashSet`

```pascal
var
  nums: List<Integer>;
  unique: HashSet<Integer>;
begin
  nums := new List<Integer>;
  nums.AddRange([1, 2, 2, 3, 3, 3, 4]);

  unique := new HashSet<Integer>;
  foreach var x in nums do
    unique.Add(x);

  WriteLn(unique.Count);   { 4 }
end.
```

### Проверка скобок через `Stack`

```pascal
function CheckBrackets(s: String): Boolean;
var
  st: Stack<Char>;
begin
  st := new Stack<Char>;
  foreach var c in s do
  begin
    if c = '(' then
      st.Push(c)
    else if c = ')' then
    begin
      if st.Count = 0 then Exit(False);
      st.Pop;
    end;
  end;
  CheckBrackets := st.Count = 0;
end;
```

### Очередь задач

```pascal
var
  tasks: Queue<String>;
begin
  tasks := new Queue<String>;
  tasks.Enqueue('задача 1');
  tasks.Enqueue('задача 2');
  tasks.Enqueue('задача 3');

  while tasks.Count > 0 do
    WriteLn('Обработка: ', tasks.Dequeue);
end.
```

### LINQ: топ-3 по убыванию

```pascal
var
  nums: List<Integer>;
begin
  nums := new List<Integer>;
  nums.AddRange([5, 2, 8, 1, 9, 3]);

  var top3 := nums.OrderByDescending(x -> x).Take(3);
  foreach var x in top3 do
    Write(x, ' ');      { 9 8 5 }
end.
```

---

## 11. Частые ошибки

- **Обращение к `d[key]` без проверки** — если ключа нет, исключение.
  Используйте `TryGetValue` или `ContainsKey`.
- **Дубликат в `Dictionary`** — `d.Add(k, v)` при существующем `k` бросает исключение.
  Используйте `d[k] := v` для перезаписи.
- **Дубликат в `HashSet`** — не ошибка, просто не добавится.
- **`Pop` / `Dequeue` на пустой коллекции** — исключение. Проверяйте `Count > 0`.
- **Изменение коллекции внутри `foreach`** — исключение.
  Собирайте изменения отдельно или используйте индексный цикл.
- **Забыли `new`** — `List<T>` создаётся через `new List<T>`.
- **`sequence of T` vs `List<T>`** — результат LINQ — `sequence`, а не `List`.
  Если нужен именно `List`, оберните: `nums.Where(...).ToList`.

---

## Примеры

- [list_basic.pas](list_basic.pas) — `List<Integer>`, Add, Remove, перебор
- [list_of_objects.pas](list_of_objects.pas) — `List<TPoint>`, `ToString`
- [dictionary.pas](dictionary.pas) — `Dictionary<String, Integer>`
- [hashset.pas](hashset.pas) — `HashSet<Integer>`, уникальные
- [stack_queue.pas](stack_queue.pas) — `Stack<T>` и `Queue<T>`
- [linq_where.pas](linq_where.pas) — `Where`, `Select`, `OrderBy`
- [linq_aggregate.pas](linq_aggregate.pas) — `Sum`, `Min`, `Max`, `Average`
- [word_count.pas](word_count.pas) — подсчёт слов через `Dictionary`

## Запуск

**PascalABC.NET:** открыть файл, F9.

## Что дальше

Урок 8 — сортировки и бинарный поиск.