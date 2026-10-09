# Урок 1. Классы и объекты

## Цель

Познакомиться с объектно-ориентированным программированием в PascalABC.NET:
научиться описывать классы, создавать объекты, работать с полями и методами.

## Ключевые понятия

- **Класс** — описание типа: какие поля и методы есть у объектов.
- **Объект** — экземпляр класса, конкретная «вещь» с данными и поведением.
- **Поле** — переменная внутри класса (данные объекта).
- **Метод** — процедура или функция внутри класса (поведение объекта).
- **Конструктор** — специальный метод создания объекта.
- **`new`** — оператор создания объекта (PascalABC.NET).

---

## 1. Зачем ООП

До этого мы хранили данные в переменных и записях, а действия — в отдельных
процедурах. С ростом программы это неудобно: данные и код «разъезжаются».

ООП объединяет **данные и действия над ними** в один тип — класс.

```
Запись:       данные отдельно, процедуры отдельно
Класс:        данные + методы вместе
```

---

## 2. Первый класс

```pascal
type
  TPoint = class
    x, y: Integer;
  end;
```

- `class` — ключевое слово.
- Поля объявляются как обычные переменные.
- `end;` с точкой с запятой обязателен.

### Создание объекта

```pascal
var
  p: TPoint;
begin
  p := new TPoint;      { создали объект }
  p.x := 3;
  p.y := 5;
  WriteLn('(', p.x, ', ', p.y, ')');
end.
```

- `new TPoint` — выделяет память и вызывает конструктор.
- Доступ к полям — через точку.
- **Без `new` объект не существует** — обращение к полям вызовет ошибку.

---

## 3. Методы

Методы — это процедуры и функции **внутри класса**.

```pascal
type
  TPoint = class
    x, y: Integer;

    procedure Print;
    begin
      WriteLn('(', x, ', ', y, ')');
    end;

    function Dist2: Integer;   { квадрат расстояния до (0,0) }
    begin
      Result := x * x + y * y;
    end;
  end;
```

Использование:

```pascal
var p: TPoint;
begin
  p := new TPoint;
  p.x := 3; p.y := 4;
  p.Print;                    { (3, 4) }
  WriteLn(p.Dist2);           { 25 }
end.
```

- Внутри метода **поля видны по имени**, без `p.`.
- `Result` — то же, что имя функции в обычной функции.
- `Self` — ссылка на текущий объект (нужна редко).

---

## 4. Конструктор

Конструктор вызывается при создании объекта и задаёт начальные значения.

```pascal
type
  TPoint = class
    x, y: Integer;

    constructor (aX, aY: Integer);
    begin
      x := aX;
      y := aY;
    end;
  end;
```

- Имя конструктора в PascalABC.NET — **`constructor`** (без имени класса, в отличие от Delphi).
- Объект создаётся через `new`:

```pascal
var
  p: TPoint;
begin
  p := new TPoint(3, 5);
  WriteLn('(', p.x, ', ', p.y, ')');
end.
```

- Если конструктор без параметров — `new TPoint` (можно и `new TPoint()`).

---

## 5. Несколько объектов одного класса

```pascal
var
  a, b: TPoint;
begin
  a := new TPoint(1, 2);
  b := new TPoint(10, 20);

  a.Print;   { (1, 2) }
  b.Print;   { (10, 20) }
end.
```

Каждый объект имеет **свои** значения полей. Изменение `a.x` не влияет на `b`.

---

## 6. Массив объектов

```pascal
var
  points: array of TPoint;
  n, i: Integer;
begin
  Write('Сколько точек? '); ReadLn(n);
  SetLength(points, n);

  for i := 0 to n - 1 do
  begin
    points[i] := new TPoint(i, i * i);
    points[i].Print;
  end;
end.
```

- Динамический массив объектов.
- Каждый элемент создаётся отдельно через `new`.

---

## 7. Пример: класс «Студент»

```pascal
type
  TStudent = class
    name: String;
    age: Integer;
    avg: Real;

    constructor (n: String; a: Integer; m: Real);
    begin
      name := n;
      age := a;
      avg := m;
    end;

    procedure Print;
    begin
      WriteLn(name, ', ', age, ' лет, средний ', avg:0:2);
    end;
  end;

var
  s: TStudent;
begin
  s := new TStudent('Иван', 18, 4.5);
  s.Print;
end.
```

---

## 8. Класс vs запись

| | `record` | `class` |
|---|---|---|
| Объявление | `record ... end` | `class ... end` |
| Создание | сразу существует как переменная | через `new` |
| Методы | нельзя | можно |
| Копирование | `b := a` копирует поля | `b := a` — **обе ссылки на один объект** |
| Наследование | нет | да |

> **Важно:** для классов `b := a` **не копирует** объект — обе переменные
> указывают на один и тот же объект. Изменение через `b` видно и через `a`.

```pascal
var
  a, b: TPoint;
begin
  a := new TPoint(1, 2);
  b := a;            { b — та же точка }
  b.x := 100;
  WriteLn(a.x);      { 100 }
end.
```

Чтобы получить независимую копию — создавайте новый объект и копируйте поля вручную.

---

## 9. Типичные задачи

### Класс «Прямоугольник»

```pascal
type
  TRect = class
    w, h: Real;

    constructor (a, b: Real);
    begin
      w := a; h := b;
    end;

    function Area: Real;
    begin
      Result := w * h;
    end;

    function Perimeter: Real;
    begin
      Result := 2 * (w + h);
    end;
  end;
```

### Класс «Счёт»

```pascal
type
  TCounter = class
    value: Integer;

    constructor;
    begin
      value := 0;
    end;

    procedure Inc;
    begin
      value := value + 1;
    end;

    procedure Reset;
    begin
      value := 0;
    end;

    function Get: Integer;
    begin
      Result := value;
    end;
  end;
```

### Класс «Дробь»

```pascal
type
  TFraction = class
    num, den: Integer;

    constructor (n, d: Integer);
    begin
      num := n;
      den := d;
    end;

    function Value: Real;
    begin
      Result := num / den;
    end;

    procedure Print;
    begin
      WriteLn(num, '/', den);
    end;
  end;
```

### Массив студентов, вывод среднего балла

```pascal
var
  group: array of TStudent;
  n, i: Integer;
  sum: Real;
begin
  Write('Сколько студентов? '); ReadLn(n);
  SetLength(group, n);

  for i := 0 to n - 1 do
  begin
    group[i] := new TStudent('Студент ' + IntToStr(i + 1), 18, 4.0 + i * 0.1);
    group[i].Print;
    sum := sum + group[i].avg;
  end;

  WriteLn('Средний балл группы: ', (sum / n):0:2);
end.
```

---

## 10. Частые ошибки

- **Забыли `new`** — обращение к полям объекта, которого нет.
  ```pascal
  var p: TPoint;
  p.x := 3;          { ошибка: объект не создан }
  ```
- **Думать, что `b := a` копирует объект** — на самом деле обе ссылки ведут на один объект.
- **Конструктор с именем класса** (`constructor TPoint`) — в PascalABC.NET не нужно; пишите просто `constructor`.
- **Точка с запятой после `end` класса** — обязательна, как и у записи.
- **Поля без `private`** — по умолчанию в PascalABC.NET поля класса доступны снаружи. Инкапсуляция — в Уроке 2.

---

## Примеры

- [class_basic.pas](class_basic.pas) — простейший класс с полями
- [class_methods.pas](class_methods.pas) — методы внутри класса
- [class_constructor.pas](class_constructor.pas) — конструктор с параметрами
- [class_array.pas](class_array.pas) — массив объектов
- [student.pas](student.pas) — класс «Студент», вывод, средний балл
- [counter.pas](counter.pas) — класс «Счётчик»
- [fraction.pas](fraction.pas) — класс «Дробь»
- [rect.pas](rect.pas) — класс «Прямоугольник», площадь и периметр

## Запуск

**PascalABC.NET:** открыть файл, F9.

## Что дальше

Урок 2 — инкапсуляция и свойства: `private`, `public`, `property`.