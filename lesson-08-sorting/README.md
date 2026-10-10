# Урок 8. Сортировки и бинарный поиск

## Цель

Освоить классические алгоритмы сортировки и бинарный поиск.
Понять их сложность и научиться применять встроенные средства
PascalABC.NET там, где свои реализации не нужны.

## Ключевые понятия

- **Сортировка** — упорядочивание элементов по критерию.
- **Сложность O(...)** — как растёт время работы с ростом данных.
- **Устойчивость** — сохраняется ли порядок равных элементов.
- **Бинарный поиск** — быстрый поиск в **отсортированном** массиве.
- **Встроенные средства** — `Sort`, `OrderBy` вместо ручных алгоритмов.

---

## 1. Зачем сортировка

- Бинарный поиск работает только на отсортированных данных.
- Многие задачи (медиана, топ-N, объединение) требуют упорядоченности.
- Часто сортировка — первый шаг обработки.

## 2. Оценка сложности

| O(...) | Название | Пример |
|---|---|---|
| O(n²) | квадратичная | пузырьковая, вставками, выбором |
| O(n log n) | логарифмически-линейная | быстрая, слиянием, пирамидальная |
| O(n) | линейная | подсчётом (для узкого диапазона) |
| O(log n) | логарифмическая | бинарный поиск |

**Правило:** для малых массивов (до ~50) годится любая. Для больших — O(n log n).

---

## 3. Пузырьковая сортировка (Bubble Sort)

Идея: многократно проходим массив, меняя местами соседние элементы,
если они в неправильном порядке. Крупные элементы «всплывают» в конец.

```pascal
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
```

- Сложность: **O(n²)**.
- Устойчивая.
- Простая, но медленная.

---

## 4. Сортировка выбором (Selection Sort)

Идея: на каждом шаге находим минимум в неотсортированной части
и ставим его в начало.

```pascal
procedure SelectionSort(a: array of Integer);
var
  i, j, minIdx, t: Integer;
begin
  for i := 0 to Length(a) - 2 do
  begin
    minIdx := i;
    for j := i + 1 to Length(a) - 1 do
      if a[j] < a[minIdx] then
        minIdx := j;

    if minIdx <> i then
    begin
      t := a[i];
      a[i] := a[minIdx];
      a[minIdx] := t;
    end;
  end;
end;
```

- Сложность: **O(n²)**.
- Неустойчивая.
- Мало перестановок — полезно, если обмен «дорогой».

---

## 5. Сортировка вставками (Insertion Sort)

Идея: берём очередной элемент и вставляем его в **уже отсортированную**
часть слева.

```pascal
procedure InsertionSort(a: array of Integer);
var
  i, j, key: Integer;
begin
  for i := 1 to Length(a) - 1 do
  begin
    key := a[i];
    j := i - 1;
    while (j >= 0) and (a[j] > key) do
    begin
      a[j + 1] := a[j];
      j := j - 1;
    end;
    a[j + 1] := key;
  end;
end;
```

- Сложность: **O(n²)**, но на почти отсортированных данных — **O(n)**.
- Устойчивая.
- Хороша для небольших массивов.

---

## 6. Быстрая сортировка (Quick Sort)

Идея: выбираем «опорный» элемент, разделяем массив на «меньше» и «больше»,
затем рекурсивно сортируем обе части.

```pascal
procedure QuickSort(a: array of Integer; left, right: Integer);
var
  i, j, pivot, t: Integer;
begin
  if left >= right then Exit;

  pivot := a[(left + right) div 2];
  i := left;
  j := right;

  while i <= j do
  begin
    while a[i] < pivot do i := i + 1;
    while a[j] > pivot do j := j - 1;

    if i <= j then
    begin
      t := a[i];
      a[i] := a[j];
      a[j] := t;
      i := i + 1;
      j := j - 1;
    end;
  end;

  QuickSort(a, left, j);
  QuickSort(a, i, right);
end;
```

Вызов:

```pascal
QuickSort(arr, 0, Length(arr) - 1);
```

- Средняя сложность: **O(n log n)**.
- Худший случай: **O(n²)** (редко при удачном выборе опорного).
- Неустойчивая.
- Обычно самая быстрая из «ручных» сортировок.

---

## 7. Сортировка слиянием (Merge Sort)

Идея: делим массив пополам, сортируем каждую половину рекурсивно,
затем **сливаем** две отсортированные части.

```pascal
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
```

- Сложность: **O(n log n)** всегда.
- Устойчивая.
- Требует O(n) дополнительной памяти.

---

## 8. Встроенные средства PascalABC.NET

**Для массивов:**

```pascal
var a := Arr(3, 1, 4, 1, 5, 9, 2, 6);
a.Sort;                    { сортировка по возрастанию, на месте }
a := a.OrderBy(x -> x).ToArray;   { сортировка с созданием нового массива }
a := a.OrderByDescending(x -> x).ToArray;
```

**Для `List<T>`:**

```pascal
var nums := new List<Integer>;
nums.AddRange([3, 1, 4, 1, 5]);
nums.Sort;                 { на месте }
```

**Сортировка объектов по полю:**

```pascal
var
  students: List<TStudent>;
begin
  students := new List<TStudent>;
  ...
  var sorted := students.OrderBy(s -> s.Avg);
  foreach var s in sorted do
    WriteLn(s);
end.
```

> **Правило курса:** для реальной работы используйте встроенные средства.
> Ручные алгоритмы — для понимания, как это устроено внутри.

---

## 9. Бинарный поиск

Работает **только на отсортированном** массиве. За O(log n) находит элемент.

Идея: сравниваем искомое со средним элементом, отбрасываем половину.

```pascal
function BinarySearch(a: array of Integer; target: Integer): Integer;
var
  lo, hi, mid: Integer;
begin
  lo := 0;
  hi := Length(a) - 1;

  while lo <= hi do
  begin
    mid := (lo + hi) div 2;

    if a[mid] = target then
      Exit(mid)
    else if a[mid] < target then
      lo := mid + 1
    else
      hi := mid - 1;
  end;

  BinarySearch := -1;
end;
```

- Сложность: **O(log n)**.
- Возвращает индекс или `-1`.
- **Массив обязан быть отсортирован.**

### Линейный поиск для сравнения

```pascal
function LinearSearch(a: array of Integer; target: Integer): Integer;
var
  i: Integer;
begin
  for i := 0 to High(a) do
    if a[i] = target then
      Exit(i);
  LinearSearch := -1;
end;
```

Сложность: **O(n)**. На больших массивах бинарный поиск в разы быстрее.

---

## 10. Встроенный бинарный поиск

В PascalABC.NET:

```pascal
var idx := a.BinarySearch(target);
```

- Возвращает индекс или отрицательное число (дополнение до позиции вставки).
- Требует отсортированного массива.

Или через `System.Array`:

```pascal
var idx := System.Array.BinarySearch(a, target);
```

---

## 11. Типичные задачи

### Сортировка массива пузырьком

```pascal
procedure BubbleSort(a: array of Integer);
...
```

### Проверка на отсортированность

```pascal
function IsSorted(a: array of Integer): Boolean;
var
  i: Integer;
begin
  for i := 0 to High(a) - 1 do
    if a[i] > a[i + 1] then
      Exit(False);
  IsSorted := True;
end;
```

### Количество обменов в пузырьке

```pascal
function BubbleSortCount(a: array of Integer): Integer;
var
  i, j, t, swaps: Integer;
begin
  swaps := 0;
  for i := 0 to Length(a) - 2 do
    for j := 0 to Length(a) - 2 - i do
      if a[j] > a[j + 1] then
      begin
        t := a[j]; a[j] := a[j + 1]; a[j + 1] := t;
        swaps := swaps + 1;
      end;
  BubbleSortCount := swaps;
end;
```

### Поиск пары с заданной суммой

Если массив отсортирован — два указателя:

```pascal
function HasPairSum(a: array of Integer; target: Integer): Boolean;
var
  i, j, s: Integer;
begin
  i := 0;
  j := Length(a) - 1;
  while i < j do
  begin
    s := a[i] + a[j];
    if s = target then Exit(True)
    else if s < target then i := i + 1
    else j := j - 1;
  end;
  HasPairSum := False;
end;
```

### Сортировка объектов по двум полям

```pascal
var
  sorted := students
    .OrderBy(s -> s.Avg)
    .ThenBy(s -> s.Name);
```

---

## 12. Сравнение алгоритмов

| Алгоритм | Среднее | Худшее | Устойчивость | Память |
|---|---|---|---|---|
| Пузырьковая | O(n²) | O(n²) | да | O(1) |
| Выбором | O(n²) | O(n²) | нет | O(1) |
| Вставками | O(n²) | O(n²) | да | O(1) |
| Быстрая | O(n log n) | O(n²) | нет | O(log n) |
| Слиянием | O(n log n) | O(n log n) | да | O(n) |
| Встроенная `Sort` | O(n log n) | O(n log n) | зависит | O(log n) |

---

## 13. Частые ошибки

- **Бинарный поиск на неотсортированном массиве** — результат непредсказуем.
- **`mid := (lo + hi) div 2`** при больших значениях — переполнение. Для учебных массивов безопасно.
- **Ошибка на единицу**: `lo := mid + 1` vs `lo := mid` — приводит к бесконечному циклу.
- **Выход за границы** в QuickSort при неправильном выборе опорного.
- **Сортировка копии, а не оригинала** — `OrderBy` возвращает новую последовательность.
- **Сравнение объектов** без указания поля: `students.Sort` для `List<TStudent>` не сработает без `IComparable`.

---

## Примеры

- [bubble.pas](bubble.pas) — пузырьковая сортировка
- [selection.pas](selection.pas) — сортировка выбором
- [insertion.pas](insertion.pas) — сортировка вставками
- [quick.pas](quick.pas) — быстрая сортировка
- [merge.pas](merge.pas) — сортировка слиянием
- [builtin_sort.pas](builtin_sort.pas) — встроенные `Sort`, `OrderBy`
- [binary_search.pas](binary_search.pas) — бинарный поиск вручную
- [compare_search.pas](compare_search.pas) — линейный vs бинарный поиск

## Запуск

**PascalABC.NET:** открыть файл, F9.

## Что дальше

Урок 9 — модули: разбиение программы на `.pas`-юниты.