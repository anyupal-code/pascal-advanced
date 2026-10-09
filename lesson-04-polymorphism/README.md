# Урок 4. Полиморфизм и абстрактные методы

## Цель

Понять, как одна переменная базового типа вызывает разные реализации
метода у наследников. Освоить `virtual`, `override`, `abstract`
и абстрактные классы.

## Ключевые понятия

- **Полиморфизм** — одна операция, разные реализации.
- **`virtual`** — метод, который можно переопределить.
- **`override`** — переопределение виртуального метода.
- **`abstract`** — метод без тела; обязан быть переопределён в наследнике.
- **Абстрактный класс** — класс с абстрактными методами; нельзя создать объект.
- **Динамическая диспетчеризация** — выбор метода во время выполнения.

---

## 1. Что такое полиморфизм

Одна и та же строка кода работает по-разному в зависимости от
**фактического типа** объекта.

```pascal
var
  a: TAnimal;
begin
  a := new TDog('Бим');
  a.Voice;      { Гав }

  a := new TCat('Мурка');
  a.Voice;      { Мяу }
end.
```

- Переменная `a` — базового типа `TAnimal`.
- Внутри — то `TDog`, то `TCat`.
- Вызов `a.Voice` идёт к **той** реализации, которая соответствует
  фактическому объекту.

Это и есть полиморфизм.

---

## 2. Без `virtual` полиморфизма нет

Если метод **не** объявлен `virtual`, вызовется версия **по типу переменной**,
а не по фактическому объекту.

```pascal
type
  TAnimal = class
  public
    function Voice: String;      { нет virtual }
    begin
      Result := '...';
    end;
  end;

  TDog = class(TAnimal)
  public
    function Voice: String;      { нет override — это НОВЫЙ метод }
    begin
      Result := 'Гав';
    end;
  end;

var
  a: TAnimal;
begin
  a := new TDog('Бим');
  WriteLn(a.Voice);   { ... , а не Гав — полиморфизм не работает }
end.
```

**Правило:** нужен полиморфизм — пиши `virtual` в родителе, `override`
в наследнике.

---

## 3. `virtual` + `override` = полиморфизм

```pascal
type
  TAnimal = class
  protected
    fName: String;
  public
    constructor (name: String);
    begin
      fName := name;
    end;

    function Voice: String; virtual;
    begin
      Result := '...';
    end;

    procedure Print;
    begin
      WriteLn(fName, ': ', Voice);
    end;
  end;

  TDog = class(TAnimal)
  public
    function Voice: String; override;
    begin
      Result := 'Гав';
    end;
  end;

  TCat = class(TAnimal)
  public
    function Voice: String; override;
    begin
      Result := 'Мяу';
    end;
  end;
```

Теперь `Print` у базового класса вызывает **правильную** версию `Voice`.

```pascal
var
  pets: array of TAnimal;
begin
  SetLength(pets, 3);
  pets[0] := new TDog('Бим');
  pets[1] := new TCat('Мурка');
  pets[2] := new TDog('Рекс');

  for var i := 0 to High(pets) do
    pets[i].Print;
end.
```

Вывод:

```
Бим: Гав
Мурка: Мяу
Рекс: Гав
```

---

## 4. `abstract` — метод без тела

Иногда у родителя **нечего** реализовать — каждая реализация своя.
Тогда метод объявляют `abstract`: тела нет, только заголовок.

```pascal
type
  TShape = class
  public
    function Area: Real; virtual; abstract;
  end;
```

- `abstract` можно использовать только вместе с `virtual`.
- Наследник **обязан** переопределить (`override`), иначе ошибка компиляции.
- Метод `Area` не имеет тела — его нельзя вызвать у `TShape` напрямую.

---

## 5. Абстрактный класс

Класс, содержащий хотя бы один `abstract` метод, называется **абстрактным**.
Создать его объект нельзя:

```pascal
var
  s: TShape;
begin
  s := new TShape;   { ошибка компиляции }
end.
```

Зато можно объявить переменную абстрактного типа — и хранить в ней
объекты наследников:

```pascal
var
  s: TShape;
begin
  s := new TCircle(2);   { ок }
  s := new TRect(3, 4);  { ок }
end.
```

---

## 6. Иерархия фигур

```pascal
type
  TShape = class
  public
    function Area: Real; virtual; abstract;

    procedure Print;
    begin
      WriteLn('Площадь: ', Area:0:2);
    end;
  end;

  TCircle = class(TShape)
  private
    fR: Real;
  public
    constructor (r: Real);
    begin
      fR := r;
    end;

    function Area: Real; override;
    begin
      Result := Pi * fR * fR;
    end;
  end;

  TRect = class(TShape)
  private
    fW, fH: Real;
  public
    constructor (w, h: Real);
    begin
      fW := w; fH := h;
    end;

    function Area: Real; override;
    begin
      Result := fW * fH;
    end;
  end;
```

Использование:

```pascal
var
  shapes: array of TShape;
begin
  SetLength(shapes, 3);
  shapes[0] := new TCircle(2);
  shapes[1] := new TRect(3, 4);
  shapes[2] := new TCircle(1);

  for var i := 0 to High(shapes) do
    shapes[i].Print;
end.
```

- `TShape` — абстрактный, объект не создаётся.
- `Print` унаследован, вызывает `Area` — реализация определяется в потомке.
- В массиве — объекты наследников, каждый считает площадь по-своему.

---

## 7. `inherited` в полиморфных методах

Иногда наследник хочет **дополнить** поведение родителя, а не заменить:

```pascal
type
  TManager = class(TEmployee)
  public
    function Salary: Real; override;
    begin
      Result := inherited Salary + fBonus;
    end;
  end;
```

`inherited Salary` — вызывает реализацию `TEmployee`. Это **не** вызов
абстрактного метода (у абстрактного тела нет — вызывать нечего).

---

## 8. `is` и `as` — проверка фактического типа

```pascal
for var i := 0 to High(shapes) do
begin
  if shapes[i] is TCircle then
  begin
    var c := shapes[i] as TCircle;
    WriteLn('  это круг');
  end;
end.
```

- **`x is TКласс`** — `True`, если объект — экземпляр класса или его наследника.
- **`x as TКласс`** — безопасное приведение. Если тип не совпадает — исключение.

Полезно, когда в полиморфной коллекции нужно выполнить действие,
специфичное для конкретного класса.

---

## 9. Итоговая картина: три уровня

```
TShape (abstract Area)
├── TCircle (override Area)
└── TRect   (override Area)
```

| Уровень | Что делает |
|---|---|
| `TShape` | объявляет `Area` абстрактным |
| `TCircle` | реализует `Area` для круга |
| `TRect` | реализует `Area` для прямоугольника |
| Основная программа | работает с `array of TShape`, не зная конкретики |

Это **основная идея ООП**: код, работающий с базовым типом,
автоматически работает со всеми наследниками.

---

## 10. Типичные задачи

### Иерархия сотрудников

```pascal
type
  TEmployee = class
  protected
    fName: String;
    fBase: Real;
  public
    constructor (name: String; base: Real);
    begin
      fName := name;
      fBase := base;
    end;

    function Salary: Real; virtual;
    begin
      Result := fBase;
    end;

    procedure Print;
    begin
      WriteLn(fName, ': ', Salary:0:2);
    end;
  end;

  TManager = class(TEmployee)
  private
    fBonus: Real;
  public
    constructor (name: String; base, bonus: Real);
    begin
      fName := name;
      fBase := base;
      fBonus := bonus;
    end;

    function Salary: Real; override;
    begin
      Result := inherited Salary + fBonus;
    end;
  end;

  TIntern = class(TEmployee)
  public
    function Salary: Real; override;
    begin
      Result := fBase * 0.5;
    end;
  end;
```

### Иерархия транспорта

```pascal
type
  TVehicle = class
  public
    function MaxSpeed: Integer; virtual; abstract;
    function Name: String; virtual; abstract;

    procedure Print;
    begin
      WriteLn(Name, ': до ', MaxSpeed, ' км/ч');
    end;
  end;

  TCar = class(TVehicle)
  public
    function MaxSpeed: Integer; override;
    begin
      Result := 220;
    end;

    function Name: String; override;
    begin
      Result := 'Автомобиль';
    end;
  end;

  TBike = class(TVehicle)
  public
    function MaxSpeed: Integer; override;
    begin
      Result := 40;
    end;

    function Name: String; override;
    begin
      Result := 'Велосипед';
    end;
  end;
```

### Игра: юниты с разной атакой

```pascal
type
  TUnit = class
  protected
    fName: String;
    fHP: Integer;
  public
    constructor (name: String; hp: Integer);
    begin
      fName := name;
      fHP := hp;
    end;

    function Attack: Integer; virtual; abstract;
    function Defense: Integer; virtual; abstract;

    procedure Print;
    begin
      WriteLn(fName, ': HP ', fHP, ', атака ', Attack, ', защита ', Defense);
    end;
  end;

  TWarrior = class(TUnit)
  public
    constructor (hp: Integer);
    begin
      fName := 'Воин';
      fHP := hp;
    end;

    function Attack: Integer; override;
    begin
      Result := 20;
    end;

    function Defense: Integer; override;
    begin
      Result := 15;
    end;
  end;

  TMage = class(TUnit)
  public
    constructor (hp: Integer);
    begin
      fName := 'Маг';
      fHP := hp;
    end;

    function Attack: Integer; override;
    begin
      Result := 30;
    end;

    function Defense: Integer; override;
    begin
      Result := 5;
    end;
  end;
```

> Обрати внимание: конструкторы наследников **не вызывают** `inherited`,
> а присваивают `fName` и `fHP` напрямую — они объявлены `protected`
> в `TUnit`. Так работает правило из Урока 3.

---

## 11. Частые ошибки

- **`virtual` без `override`** в наследнике — создаётся новый метод,
  полиморфизм не работает.
- **`override` без `virtual`** в родителе — ошибка компиляции.
- **Наследник не переопределил `abstract` метод** — ошибка компиляции.
- **`new TАбстрактныйКласс`** — создать объект абстрактного класса нельзя.
- **`inherited` на абстрактном методе** — тела нет, вызвать нечего.
- **Попытка полиморфизма без `virtual`** — вызовется метод по типу переменной,
  а не по фактическому объекту.
- **Имя программы совпадает с именем переменной** — `program Shapes;`
  и `var shapes: ...` — конфликт. Pascal не различает регистр:
  `Shapes` и `shapes` — одно имя. Переименуйте программу в `ShapesDemo`
  или переменную в `figs`.
- **`inherited (args);` в конструкторе наследника** — не работает
  в PascalABC.NET (см. Урок 3). Присваивайте поля родителя напрямую.

---

## Примеры

- [poly_basic.pas](poly_basic.pas) — `virtual`/`override`, полиморфизм
- [poly_array.pas](poly_array.pas) — массив объектов базового типа
- [abstract_method.pas](abstract_method.pas) — абстрактный метод
- [abstract_class.pas](abstract_class.pas) — абстрактный класс, объект не создаётся
- [shapes.pas](shapes.pas) — иерархия фигур, абстрактная площадь
- [vehicles.pas](vehicles.pas) — иерархия транспорта
- [units.pas](units.pas) — игра, юниты с разной атакой
- [type_check.pas](type_check.pas) — `is`, `as`, приведение

> Имя программы внутри файла (`ShapesDemo`, `VehiclesDemo`, `UnitsDemo`)
> может отличаться от имени файла — оно не связано с именем бинарника.
> Бинарник получает имя по файлу: `shapes.pas` → `shapes`.

## Запуск

**PascalABC.NET:** открыть файл, F9.

## Что дальше

Урок 5 — исключения: `try`, `except`, `finally`, `raise`.