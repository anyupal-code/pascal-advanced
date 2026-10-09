# Урок 2. Инкапсуляция и свойства

## Цель

Научиться скрывать внутренние данные класса от внешнего кода
и предоставлять контролируемый доступ через свойства (`property`).

## Ключевые понятия

- **Инкапсуляция** — сокрытие внутреннего устройства класса.
- **Модификаторы доступа** — `private`, `public`, `protected`.
- **Свойство (`property`)** — управляемый доступ к полю через `read`/`write`.
- **Сеттер / геттер** — метод записи / чтения.
- **`read fX` / `write fX`** — прямой доступ к полю из свойства.

---

## 1. Зачем инкапсуляция

Без неё любой код может сломать объект:

```pascal
var
  p: TPoint;
begin
  p := new TPoint;
  p.x := -999999;      { кто проверяет корректность? }
end.
```

С инкапсуляцией класс **сам решает**, что и как менять:

- поля скрыты (`private`),
- доступ — через методы или свойства,
- при установке значения можно проверять его корректность.

---

## 2. Модификаторы доступа

```pascal
type
  TPoint = class
  private
    fX, fY: Integer;      { доступно только внутри класса }

  public
    procedure SetX(v: Integer);
    function GetX: Integer;
  end;
```

| Модификатор | Кто видит |
|---|---|
| `private` | только сам класс |
| `protected` | класс и его наследники (Урок 3) |
| `public` | все |

В PascalABC.NET по умолчанию поля — `public`. Хороший стиль — **всегда указывать** явно.

---

## 3. Соглашение об именах

- Приватное поле: `fX`, `fValue`, `fName` — префикс `f` (field).
- Публичное свойство: `X`, `Value`, `Name` — без префикса.
- Сеттер: `SetX`, геттер: `GetX`.

```pascal
type
  TPoint = class
  private
    fX, fY: Integer;
  public
    procedure SetX(v: Integer);
    begin
      fX := v;
    end;

    function GetX: Integer;
    begin
      Result := fX;
    end;
  end;
```

Использование:

```pascal
p.SetX(5);
WriteLn(p.GetX);
```

Работает, но громоздко. Отсюда — свойства.

---

## 4. Свойства (`property`)

Свойство выглядит как поле, но за ним стоят методы или прямое поле.

```pascal
type
  TPoint = class
  private
    fX, fY: Integer;

    procedure SetX(v: Integer);
    begin
      fX := v;
    end;

    function GetX: Integer;
    begin
      Result := fX;
    end;

  public
    property X: Integer read GetX write SetX;
  end;
```

Использование:

```pascal
p.X := 5;              { вызывает SetX }
WriteLn(p.X);          { вызывает GetX }
```

- `read GetX` — что вызывается при чтении.
- `write SetX` — что вызывается при записи.
- Снаружи — как обычное поле.

### Свойство только для чтения

```pascal
property X: Integer read GetX;
```

Попытка `p.X := 5` — ошибка компиляции.

### Свойство только для записи

```pascal
property X: Integer write SetX;
```

---

## 5. Свойства с проверкой

```pascal
type
  TAge = class
  private
    fValue: Integer;

    procedure SetValue(v: Integer);
    begin
      if (v < 0) or (v > 150) then
        raise new System.ArgumentException('Недопустимый возраст')
      else
        fValue := v;
    end;

  public
    property Value: Integer read fValue write SetValue;
  end;
```

Использование:

```pascal
var a: TAge;
begin
  a := new TAge;
  a.Value := 30;         { ok }
  a.Value := 200;        { исключение }
end.
```

> `raise` и `ArgumentException` — из Урока 5. Пока просто запомните идею:
> сеттер может отказать в некорректном значении.

---

## 6. Свойства без явных геттеров и сеттеров

Если проверка не нужна, можно писать и читать **напрямую в приватное поле**:

```pascal
type
  TPoint = class
  private
    fX, fY: Integer;
  public
    property X: Integer read fX write fX;
    property Y: Integer read fY write fY;
  end;
```

- `read fX` — чтение прямо из поля.
- `write fX` — запись прямо в поле.
- Снаружи — обычный доступ: `p.X := 3; WriteLn(p.X);`

Такой вариант короче, чем сеттер/геттер, и сохраняет инкапсуляцию
(поле всё равно скрыто в `private`).

> В **этой версии PascalABC.NET** «автосвойства» —
> `property X: Integer;` без `read`/`write` — **не поддерживаются**.
> Компилятор требует `read` или `write`.
> Безопасный вариант — указывать их явно, как выше.

---

## 7. Прямой доступ к приватному полю в `read`

Можно писать не геттер, а сразу поле:

```pascal
type
  TPoint = class
  private
    fX: Integer;

    procedure SetX(v: Integer);
    begin
      fX := v;
    end;

  public
    property X: Integer read fX write SetX;
  end;
```

Чтение — напрямую из `fX`, запись — через `SetX`. Короче, но работает только внутри класса.

---

## 8. Вычисляемые свойства — только через геттер

**`read` и `write` принимают только имя поля или метода**, не выражение.

**Не работает:**

```pascal
property Area: Real read (Pi * R * R);   { ошибка }
```

**Работает:**

```pascal
type
  TCircle = class
  private
    fRadius: Real;

    function GetArea: Real;
    begin
      Result := Pi * fRadius * fRadius;
    end;

  public
    property Radius: Real read fRadius;
    property Area: Real read GetArea;
  end;
```

Для вычисляемых свойств **всегда заводите отдельный геттер-функцию**.

---

## 9. Пример: класс «Студент»

```pascal
type
  TStudent = class
  private
    fName: String;
    fAge: Integer;
    fAvg: Real;

    procedure SetAge(v: Integer);
    begin
      if (v < 14) or (v > 100) then
        raise new System.ArgumentException('Некорректный возраст');
      fAge := v;
    end;

    procedure SetAvg(v: Real);
    begin
      if (v < 0) or (v > 5) then
        raise new System.ArgumentException('Средний балл: 0..5');
      fAvg := v;
    end;

  public
    constructor (n: String);
    begin
      fName := n;
      fAge := 18;
      fAvg := 0;
    end;

    property Name: String read fName;
    property Age: Integer read fAge write SetAge;
    property Avg: Real read fAvg write SetAvg;

    procedure Print;
    begin
      WriteLn(fName, ', ', fAge, ' лет, ср. ', fAvg:0:2);
    end;
  end;
```

Использование:

```pascal
var s: TStudent;
begin
  s := new TStudent('Иван');
  s.Age := 19;
  s.Avg := 4.5;
  s.Print;
end.
```

- `Name` — только для чтения (менять имя нельзя).
- `Age` — с проверкой диапазона.
- `Avg` — с проверкой 0..5.

---

## 10. Пример: класс «Банковский счёт»

```pascal
type
  TAccount = class
  private
    fOwner: String;
    fBalance: Real;

    procedure SetBalance(v: Real);
    begin
      if v < 0 then
        raise new System.ArgumentException('Баланс не может быть отрицательным');
      fBalance := v;
    end;

  public
    constructor (owner: String; initial: Real);
    begin
      fOwner := owner;
      fBalance := initial;
    end;

    property Owner: String read fOwner;
    property Balance: Real read fBalance;

    procedure Deposit(amount: Real);
    begin
      if amount <= 0 then
        raise new System.ArgumentException('Сумма должна быть положительной');
      SetBalance(fBalance + amount);
    end;

    procedure Withdraw(amount: Real);
    begin
      if amount <= 0 then
        raise new System.ArgumentException('Сумма должна быть положительной');
      if amount > fBalance then
        raise new System.ArgumentException('Недостаточно средств');
      SetBalance(fBalance - amount);
    end;
  end;
```

- `Balance` — только для чтения.
- Изменение — через `Deposit` и `Withdraw`, где проверки.
- Прямое `acc.Balance := 1000` — ошибка компиляции.

---

## 11. Типичные задачи

### Класс «Точка» — свойства прямо к полям

```pascal
type
  TPoint = class
  private
    fX, fY: Integer;
  public
    property X: Integer read fX write fX;
    property Y: Integer read fY write fY;

    procedure Print;
    begin
      WriteLn('(', fX, ', ', fY, ')');
    end;
  end;
```

### Класс «Прямоугольник» с проверкой сторон

```pascal
type
  TRect = class
  private
    fW, fH: Real;

    procedure SetW(v: Real);
    begin
      if v <= 0 then
        raise new System.ArgumentException('Ширина > 0');
      fW := v;
    end;

    procedure SetH(v: Real);
    begin
      if v <= 0 then
        raise new System.ArgumentException('Высота > 0');
      fH := v;
    end;

  public
    constructor (w, h: Real);
    begin
      SetW(w);
      SetH(h);
    end;

    property Width: Real read fW write SetW;
    property Height: Real read fH write SetH;

    function Area: Real;
    begin
      Result := fW * fH;
    end;
  end;
```

### Класс «Температура» с двумя шкалами

```pascal
type
  TTemp = class
  private
    fCelsius: Real;

    function GetFahrenheit: Real;
    begin
      Result := fCelsius * 9 / 5 + 32;
    end;

  public
    constructor (c: Real);
    begin
      fCelsius := c;
    end;

    property Celsius: Real read fCelsius write fCelsius;
    property Fahrenheit: Real read GetFahrenheit;
  end;
```

`Fahrenheit` — **вычисляемое** свойство через геттер.

---

## 12. Частые ошибки

- **Все поля `public`** — теряется весь смысл инкапсуляции.
- **Геттер и сеттер для тривиального поля** — если проверки нет, хватит `read fX write fX`.
- **Забыли `private`** — по умолчанию в PascalABC.NET поля доступны снаружи.
- **Изменение `fBalance` в обход сеттера** — обходит проверки.
- **Путаница `read` / `write`** — `read fX` читает из поля, `write SetX` пишет через метод.
- **Выражение в `read`/`write`** — запрещено. Только имя поля или метода.
- **Автосвойство без `read`/`write`** — в этой версии PascalABC.NET не компилируется.

---

## Примеры

- [private_basic.pas](private_basic.pas) — приватные поля, методы доступа
- [property_basic.pas](property_basic.pas) — свойство с `read`/`write`
- [property_readonly.pas](property_readonly.pas) — свойство только для чтения, вычисляемое через геттер
- [property_validation.pas](property_validation.pas) — проверка в сеттере
- [autoproperty.pas](autoproperty.pas) — свойства с `read fX write fX`
- [student.pas](student.pas) — класс «Студент» с проверками
- [account.pas](account.pas) — банковский счёт
- [temperature.pas](temperature.pas) — вычисляемое свойство через геттер

## Запуск

**PascalABC.NET:** открыть файл, F9.

## Что дальше

Урок 3 — наследование: `class(TBase)`, `override`, `inherited`.