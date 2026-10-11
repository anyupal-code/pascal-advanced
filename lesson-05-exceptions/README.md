# Урок 5. Исключения

## Цель

Научиться обрабатывать ошибки времени выполнения: перехватывать исключения,
корректно освобождать ресурсы и создавать свои классы исключений.

## Ключевые понятия

- **Исключение** — объект, описывающий ошибку.
- **`try ... except`** — перехват исключения.
- **`try ... finally`** — гарантированное выполнение блока.
- **`raise`** — выброс исключения.
- **`on E: TКласс do`** — обработка конкретного типа исключения.
- **Свой класс исключения** — наследник `Exception`.

---

## 1. Зачем исключения

Без обработки любая ошибка **обрушивает программу**:

```pascal
var
  a, b: Integer;
begin
  ReadLn(a); ReadLn(b);
  WriteLn(a div b);   { если b = 0 — программа падает }
end.
```

С исключениями программа **переживает** ошибку и продолжает работу:

```pascal
try
  WriteLn(a div b);
except
  WriteLn('Деление на ноль');
end;
```

---

## 2. `try ... except`

```pascal
try
  { код, который может дать ошибку }
except
  { что делать при ошибке }
end;
```

Простейший вариант — поймать **любое** исключение:

```pascal
try
  x := StrToInt(s);
except
  WriteLn('Это не число');
end;
```

Если ошибки нет — `except` пропускается. Если есть — управление
переходит в `except`.

---

## 3. `on E: TКласс do`

Обработка конкретных типов исключений:

```pascal
try
  x := StrToInt(s);
  y := 10 div x;
except
  on E: System.FormatException do
    WriteLn('Не число: ', s);
  on E: System.DivideByZeroException do
    WriteLn('Деление на ноль');
  on E: Exception do
    WriteLn('Другая ошибка: ', E.Message);
end;
```

- `on E: TКласс do` — ловит исключения указанного типа.
- `E.Message` — текст ошибки.
- Ветка `on E: Exception` — **последняя**, ловит всё остальное.
- Если подходящей ветки нет — исключение идёт дальше «наверх».

Порядок важен: **от конкретных к общим**.

---

## 4. `try ... finally`

Блок `finally` выполняется **всегда** — была ошибка или нет.

```pascal
Assign(f, 'data.txt');
Reset(f);
try
  { работа с файлом, может упасть }
  ReadLn(f, s);
finally
  Close(f);    { закроется в любом случае }
end;
```

Зачем:

- освободить ресурсы (файлы, память),
- вернуть систему в согласованное состояние,
- гарантировать запись в лог.

### `except` + `finally` вместе

```pascal
try
  { код }
except
  { обработка ошибки }
finally
  { выполнится всегда }
end;
```

---

## 5. `raise` — выброс исключения

```pascal
if b = 0 then
  raise new System.DivideByZeroException('b не может быть нулём');
```

- `raise` создаёт и выбрасывает исключение.
- Обработать можно выше по стеку — через `try ... except`.

### Повторный выброс

```pascal
try
  ...
except
  WriteLn('Логируем и пробрасываем дальше');
  raise;         { повторно выбросить то же исключение }
end;
```

`raise;` без аргумента — **повторный выброс текущего** исключения.

---

## 6. Свой класс исключения

Наследник `Exception`:

```pascal
type
  TAgeException = class(Exception)
  public
    constructor (msg: String);
    begin
      inherited Create(msg);
    end;
  end;
```

> В PascalABC.NET конструктор родителя вызывается через
> `inherited Create(msg);` — это работает для `Exception`,
> потому что `Create` — стандартный конструктор .NET.

Использование:

```pascal
procedure SetAge(v: Integer);
begin
  if (v < 0) or (v > 150) then
    raise new TAgeException('Возраст: 0..150');
  fAge := v;
end;
```

Обработка:

```pascal
try
  s.Age := 200;
except
  on E: TAgeException do
    WriteLn('Ошибка возраста: ', E.Message);
end;
```

---

## 7. Стандартные исключения .NET

| Класс | Когда возникает |
|---|---|
| `System.ArgumentException` | неверный аргумент |
| `System.FormatException` | неверный формат (например, `StrToInt('abc')`) |
| `System.DivideByZeroException` | деление на ноль |
| `System.NullReferenceException` | обращение к `nil`-объекту |
| `System.IndexOutOfRangeException` | выход за границы массива |
| `System.IO.FileNotFoundException` | файл не найден |
| `System.Exception` | базовый класс для всех |

Все они — в пространстве имён `System`.

---

## 8. Исключения в конструкторах и методах

**Класс с проверками:**

```pascal
type
  TStudent = class
  private
    fName: String;
    fAge: Integer;

    procedure SetAge(v: Integer);
    begin
      if (v < 14) or (v > 100) then
        raise new System.ArgumentException('Возраст: 14..100');
      fAge := v;
    end;

  public
    constructor (name: String);
    begin
      fName := name;
      fAge := 18;
    end;

    property Name: String read fName;
    property Age: Integer read fAge write SetAge;
  end;
```

**Использование с обработкой:**

```pascal
var
  s: TStudent;
begin
  s := new TStudent('Иван');

  try
    s.Age := 200;
  except
    on E: System.ArgumentException do
      WriteLn('Ошибка: ', E.Message);
  end;

  WriteLn('Возраст: ', s.Age);
end.
```

---

## 9. Вложенные `try`

```pascal
try
  try
    x := StrToInt(s);
  except
    on E: System.FormatException do
    begin
      WriteLn('Плохое число, ставим 0');
      x := 0;
    end;
  end;

  WriteLn('x = ', x);
except
  on E: Exception do
    WriteLn('Внешняя ошибка: ', E.Message);
end.
```

Внутренний `try` ловит свою ошибку. Если он её пробросит — поймает внешний.

---

## 10. Типичные задачи

### Безопасный ввод числа

```pascal
function ReadInt(prompt: String): Integer;
var
  s: String;
  code: Integer;
begin
  repeat
    Write(prompt);
    ReadLn(s);
    Val(s, Result, code);
    if code <> 0 then
      WriteLn('Это не число, попробуйте снова');
  until code = 0;
end;
```

### Безопасный ввод с `try`

```pascal
function ReadInt2(prompt: String): Integer;
var
  s: String;
begin
  while True do
  begin
    Write(prompt);
    ReadLn(s);
    try
      Result := StrToInt(s);
      Exit;
    except
      on E: System.FormatException do
        WriteLn('Это не число');
    end;
  end;
end;
```

### Класс с проверкой в конструкторе

```pascal
type
  TRect = class
  private
    fW, fH: Real;
  public
    constructor (w, h: Real);
    begin
      if (w <= 0) or (h <= 0) then
        raise new System.ArgumentException('Стороны должны быть > 0');
      fW := w; fH := h;
    end;

    property Width: Real read fW;
    property Height: Real read fH;
  end;
```

Использование:

```pascal
try
  r := new TRect(3, 0);
except
  on E: System.ArgumentException do
    WriteLn('Ошибка: ', E.Message);
end;
```

### Своё исключение для бизнес-логики

```pascal
type
  TInsufficientFundsException = class(Exception)
  public
    constructor (msg: String);
    begin
      inherited Create(msg);
    end;
  end;

procedure Withdraw(amount: Real);
begin
  if amount > fBalance then
    raise new TInsufficientFundsException('Недостаточно средств');
  fBalance := fBalance - amount;
end;
```

---

## 11. Частые ошибки

- **Пустой `except` без обработки** — ошибка проглочена, программа молча
  продолжает работу. Плохо, если вы не понимаете, что произошло.
- **Порядок `on` от общего к частному** — ветка `Exception` должна быть
  последней, иначе перекроет конкретные.
- **Забыли `try ... finally` для файлов** — при ошибке файл останется
  открытым.
- **`raise` без `new`** — нельзя выбросить не-объект.
- **Слишком широкий `try`** — оборачивать всю программу не стоит,
  ловите локально.
- **Не указан тип в `on E: TКласс do`** — синтаксис требует и имя переменной,
  и тип.

---

## Примеры

- [try_except.pas](try_except.pas) — базовый `try ... except`
- [multiple_handlers.pas](multiple_handlers.pas) — несколько `on E: ... do`
- [try_finally.pas](try_finally.pas) — гарантированное выполнение блока
- [raise_demo.pas](raise_demo.pas) — `raise`, повторный `raise`
- [custom_exception.pas](custom_exception.pas) — свой класс исключения
- [student_exception.pas](student_exception.pas) — класс с проверками
- [safe_input.pas](safe_input.pas) — безопасный ввод числа
- [rect_exception.pas](rect_exception.pas) — проверка в конструкторе

## Запуск

**PascalABC.NET:** открыть файл, F9.

## Что дальше

Урок 6 — интерфейсы: `interface`, `implements`.