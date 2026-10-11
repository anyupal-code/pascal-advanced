# Урок 6. Интерфейсы

## Цель

Научиться описывать контракты поведения через интерфейсы, реализовывать
их в классах и использовать переменные интерфейсного типа для
полиморфизма без наследования.

## Ключевые понятия

- **Интерфейс** — описание методов без реализации.
- **Реализация (`implements`)** — класс обязуется предоставить методы интерфейса.
- **Контракт** — интерфейс говорит «что умеет», класс — «как именно».
- **Множественная реализация** — один класс может реализовать много интерфейсов.
- **Полиморфизм через интерфейс** — переменная интерфейсного типа хранит любой реализующий класс.

---

## 1. Зачем интерфейсы

В PascalABC.NET у классов **одиночное наследование** — только один родитель.
Интерфейсы решают это ограничение: класс может реализовать **сколько угодно**
интерфейсов.

```
class TFlyer inherits TAnimal, implements ICanFly, ICanSwim
```

Идея:

- **класс** — «чем объект является» (`TAnimal`),
- **интерфейс** — «что объект умеет» (`ICanFly`).

---

## 2. Объявление интерфейса

```pascal
type
  IShape = interface
    function Area: Real;
    procedure Print;
  end;
```

- `interface` — ключевое слово.
- **Только заголовки**, без `begin ... end`.
- По умолчанию все методы **публичные**.
- Точка с запятой после `end` обязательна.

> Имена интерфейсов принято начинать с `I`: `IShape`, `ICanFly`, `IComparable`.

---

## 3. Реализация интерфейса

```pascal
type
  TCircle = class(IShape)
  private
    fR: Real;
  public
    constructor (r: Real);
    begin
      fR := r;
    end;

    function Area: Real;
    begin
      Result := Pi * fR * fR;
    end;

    procedure Print;
    begin
      WriteLn('Круг: ', Area:0:2);
    end;
  end;
```

- `class(IShape)` — синтаксис реализации интерфейса.
- Класс **обязан** реализовать **все** методы интерфейса.
- Если хотя бы один метод пропущен — ошибка компиляции.
- Обрати внимание: `override` **не нужен** — методы интерфейса не виртуальные
  в привычном смысле.

---

## 4. Переменная интерфейсного типа

```pascal
var
  s: IShape;
begin
  s := new TCircle(2);
  s.Print;
end.
```

- Переменная типа `IShape` хранит **любой** объект, реализующий интерфейс.
- Метод вызывается через переменную интерфейса — работает полиморфизм.
- Фактический объект может быть любого класса-реализатора.

### Массив интерфейсов

```pascal
var
  shapes: array of IShape;
  i: Integer;
begin
  SetLength(shapes, 3);
  shapes[0] := new TCircle(2);
  shapes[1] := new TRect(3, 4);
  shapes[2] := new TCircle(1);

  for i := 0 to High(shapes) do
    shapes[i].Print;
end.
```

Каждый элемент — свой класс, но вызов `Print` идёт к **правильной** реализации.

---

## 5. Несколько интерфейсов у одного класса

```pascal
type
  ICanFly = interface
    procedure Fly;
  end;

  ICanSwim = interface
    procedure Swim;
  end;

  TDuck = class(ICanFly, ICanSwim)
  public
    procedure Fly;
    begin
      WriteLn('Утка летит');
    end;

    procedure Swim;
    begin
      WriteLn('Утка плывёт');
    end;
  end;
```

Использование:

```pascal
var
  d: TDuck;
  flyer: ICanFly;
  swimmer: ICanSwim;
begin
  d := new TDuck;

  flyer := d;
  flyer.Fly;

  swimmer := d;
  swimmer.Swim;
end.
```

Один объект — два интерфейса. Разные переменные видят только свою часть.

---

## 6. Интерфейс + наследование

Класс может **наследовать класс** и **реализовать интерфейсы**:

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
  end;

  ICanFly = interface
    procedure Fly;
  end;

  TBird = class(TAnimal, ICanFly)
  public
    procedure Fly;
    begin
      WriteLn(fName, ' летит');
    end;
  end;
```

Порядок: **сначала родительский класс, потом интерфейсы**.

```pascal
TBird = class(TAnimal, ICanFly)   { ок }
TBird = class(ICanFly, TAnimal)   { ошибка }
```

---

## 7. Интерфейс как контракт

Любой код может принять переменную интерфейса и **не знать**, какой
конкретно класс за ней стоит.

```pascal
procedure PrintArea(const s: IShape);
begin
  WriteLn('Площадь: ', s.Area:0:2);
end;
```

```pascal
PrintArea(new TCircle(2));
PrintArea(new TRect(3, 4));
```

Функция работает с абстракцией, а не с конкретным классом.

---

## 8. `is` и `as` с интерфейсами

```pascal
for var i := 0 to High(shapes) do
begin
  if shapes[i] is TCircle then
    WriteLn('  это круг');
end.
```

- `x is IИнтерфейс` — проверяет, реализует ли объект интерфейс.
- `x as IИнтерфейс` — приведение к интерфейсу.

---

## 9. Отличие от абстрактного класса

| | Абстрактный класс | Интерфейс |
|---|---|---|
| Наследование | только одно | сколько угодно |
| Поля | можно | нельзя |
| Реализация методов | можно (частично) | нет (только заголовки) |
| Конструкторы | есть | нет |
| Смысл | «является» | «умеет» |

**Правило:** есть общие данные и логика — абстрактный класс. Есть только
контракт поведения — интерфейс.

---

## 10. Типичные задачи

### Иерархия фигур через интерфейс

```pascal
type
  IShape = interface
    function Area: Real;
    function Perimeter: Real;
    procedure Print;
  end;

  TCircle = class(IShape)
  private
    fR: Real;
  public
    constructor (r: Real);
    begin
      fR := r;
    end;

    function Area: Real;
    begin
      Result := Pi * fR * fR;
    end;

    function Perimeter: Real;
    begin
      Result := 2 * Pi * fR;
    end;

    procedure Print;
    begin
      WriteLn('Круг: S=', Area:0:2, ' P=', Perimeter:0:2);
    end;
  end;

  TRect = class(IShape)
  private
    fW, fH: Real;
  public
    constructor (w, h: Real);
    begin
      fW := w; fH := h;
    end;

    function Area: Real;
    begin
      Result := fW * fH;
    end;

    function Perimeter: Real;
    begin
      Result := 2 * (fW + fH);
    end;

    procedure Print;
    begin
      WriteLn('Прямоугольник: S=', Area:0:2, ' P=', Perimeter:0:2);
    end;
  end;
```

### «Умеет» через интерфейсы

```pascal
type
  IPrintable = interface
    procedure Print;
  end;

  ISerializable = interface
    function ToString: String;
  end;

  TPerson = class(IPrintable, ISerializable)
  private
    fName: String;
    fAge: Integer;
  public
    constructor (name: String; age: Integer);
    begin
      fName := name;
      fAge := age;
    end;

    procedure Print;
    begin
      WriteLn(fName, ', ', fAge);
    end;

    function ToString: String;
    begin
      Result := fName + ';' + IntToStr(fAge);
    end;
  end;
```

### Список объектов с общим интерфейсом

```pascal
var
  items: List<IPrintable>;
begin
  items := new List<IPrintable>;
  items.Add(new TCircle(2));
  items.Add(new TRect(3, 4));

  foreach var it in items do
    it.Print;
end.
```

> `List<T>` — из Урока 7. Здесь показано, как интерфейс комбинируется
> с коллекциями.

---

## 11. Частые ошибки

- **Не все методы реализованы** — ошибка компиляции: «класс не реализует метод интерфейса».
- **`override` на методе интерфейса** — не нужен и не работает. Метод просто реализуется.
- **Поля в интерфейсе** — нельзя. Только методы и свойства.
- **Конструктор в интерфейсе** — нельзя.
- **Порядок `class(TBase, IInterface)`** — родитель всегда первым.
- **Попытка создать `new IИнтерфейс`** — нельзя, интерфейс не класс.
- **Присвоение несовместимого объекта** — если класс не реализует интерфейс, компилятор не даст присвоить.

---

## Примеры

- [interface_basic.pas](interface_basic.pas) — объявление и реализация интерфейса
- [interface_array.pas](interface_array.pas) — массив интерфейсов
- [multiple_interfaces.pas](multiple_interfaces.pas) — два интерфейса у одного класса
- [interface_inherit.pas](interface_inherit.pas) — класс + наследование + интерфейс
- [interface_contract.pas](interface_contract.pas) — функция с параметром-интерфейсом
- [shapes_interface.pas](shapes_interface.pas) — иерархия фигур через интерфейс
- [printable.pas](printable.pas) — интерфейс `IPrintable`, полиморфный вывод
- [is_as_interface.pas](is_as_interface.pas) — `is`, `as` с интерфейсами

## Запуск

**PascalABC.NET:** открыть файл, F9.

## Что дальше

Урок 7 — Generics и коллекции .NET: `List<T>`, `Dictionary<K,V>`, `Stack`, `Queue`.