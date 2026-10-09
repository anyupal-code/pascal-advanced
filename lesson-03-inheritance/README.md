# Урок 3. Наследование

## Цель

Научиться строить иерархии классов: расширять базовый класс,
переопределять методы, использовать `inherited` в методах
и строить полиморфные коллекции.

## Ключевые понятия

- **Базовый класс (родитель)** — класс, от которого наследуют.
- **Наследник (потомок)** — класс, который расширяет базовый.
- **`class(TBase)`** — синтаксис наследования.
- **`override`** — переопределение метода родителя.
- **`inherited`** — вызов метода родителя из наследника.
- **`protected`** — доступ для класса и его наследников.

---

## 1. Зачем наследование

Если два класса имеют общие поля и методы — выносим их в **базовый класс**,
а различия — в наследники.

```
       TAnimal
       ├── TDog
       └── TCat
```

Общее: `name`, `Voice`. Различия — в конкретной реализации `Voice`.

---

## 2. Базовый класс

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

    function Voice: String;
    begin
      Result := '...';
    end;

    procedure Print;
    begin
      WriteLn(fName, ': ', Voice);
    end;
  end;
```

- `protected` — доступно классу и его наследникам.
- Метод `Voice` пока общий — переопределим в потомках.

---

## 3. Наследник

```pascal
type
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

- **`class(TAnimal)`** — наследует поля и методы `TAnimal`.
- **`override`** — переопределяет метод родителя.
- **Тот же заголовок** — то же имя, параметры, тип результата.

Использование:

```pascal
var
  d: TDog;
  c: TCat;
begin
  d := new TDog('Бим');
  c := new TCat('Мурка');

  d.Print;   { Бим: Гав }
  c.Print;   { Мурка: Мяу }
end.
```

Метод `Print` унаследован — не переписываем.

---

## 4. Правило `virtual` и `override`

Чтобы переопределение работало **через переменную базового типа**, метод
в базовом классе должен быть `virtual`, а в наследнике — `override`.

```pascal
type
  TAnimal = class
  public
    function Voice: String; virtual;
    begin
      Result := '...';
    end;
  end;

  TDog = class(TAnimal)
  public
    function Voice: String; override;
    begin
      Result := 'Гав';
    end;
  end;
```

Без `virtual` метод не будет полиморфным (см. Урок 4).

> В PascalABC.NET методы классов по умолчанию **не виртуальные**.
> Хочешь полиморфизм — пиши `virtual` и `override` явно.

---

## 5. Конструктор наследника

**Важно:** в PascalABC.NET вызов родительского конструктора
через `inherited (args);` **не работает**. Компилятор ищет в базовом классе
конструктор с такими же параметрами и не находит — отсюда ошибка
«Не найден конструктор с такими параметрами в базовом классе».

**Рабочий приём:** не вызывать `inherited` в конструкторе наследника,
а **присваивать поля родителя напрямую**. Они доступны, потому что
объявлены `protected`.

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
  end;

  TDog = class(TAnimal)
  private
    fBreed: String;
  public
    constructor (name, breed: String);
    begin
      fName := name;         { поле родителя, protected }
      fBreed := breed;
    end;
  end;
```

> **`inherited MethodName`** в обычных методах **работает** и нужен
> для полиморфизма. Пример — `TManager.Salary` ниже.

---

## 6. Вызов метода родителя — `inherited`

Если в наследнике нужно использовать логику родителя:

```pascal
type
  TDog = class(TAnimal)
  public
    function Voice: String; override;
    begin
      Result := inherited Voice + ' (гав)';
    end;
  end;
```

- `inherited Voice` — вызвать `Voice` из `TAnimal`.
- Без имени метода: `inherited;` — вызов одноимённого метода родителя.

Пример с зарплатой:

```pascal
type
  TManager = class(TEmployee)
  private
    fBonus: Real;
  public
    function Salary: Real; override;
    begin
      Result := inherited Salary + fBonus;
    end;
  end;
```

`inherited Salary` — базовый оклад. Плюс бонус. Полиморфизм работает.

---

## 7. Расширение наследника

Наследник может добавлять **свои** поля и методы:

```pascal
type
  TDog = class(TAnimal)
  private
    fBreed: String;
  public
    constructor (name, breed: String);
    begin
      fName := name;
      fBreed := breed;
    end;

    function Voice: String; override;
    begin
      Result := 'Гав';
    end;

    procedure PrintBreed;
    begin
      WriteLn(fName, ' породы ', fBreed);
    end;
  end;
```

- `fBreed` — новое поле.
- `PrintBreed` — новый метод.
- `fName` доступно, потому что в родителе оно `protected`.

---

## 8. Полиморфная коллекция

Переменная **базового** типа может указывать на объект **наследника**:

```pascal
var
  pets: array of TAnimal;
begin
  SetLength(pets, 3);
  pets[0] := new TDog('Бим');
  pets[1] := new TCat('Мурка');
  pets[2] := new TDog('Рекс');

  for var i := 0 to High(pets) do
    pets[i].Print;    { у каждого вызовется свой Voice }
end.
```

Вывод:

```
Бим: Гав
Мурка: Мяу
Рекс: Гав
```

Это и есть **полиморфизм** — благодаря `virtual`/`override`.
Подробно — в Уроке 4.

> **Имя переменной не должно совпадать с именем программы.**
> `program Animals;` и `var animals: ...` — конфликт: Pascal не различает
> регистр. Переименуйте программу в `AnimalsDemo` или переменную в `pets`.

---

## 9. `is` и `as`

Проверка типа и приведение:

```pascal
for var i := 0 to High(pets) do
begin
  if pets[i] is TDog then
  begin
    var d := pets[i] as TDog;
    d.PrintBreed;
  end;
end.
```

- **`x is TКласс`** — `True`, если объект — экземпляр этого класса или его наследника.
- **`x as TКласс`** — приведение к типу. Если тип не совпадает — исключение.

---

## 10. Наследование vs композиция

**Наследование** — «является»:

```
Собака — это животное.
TDog = class(TAnimal)
```

**Композиция** — «содержит»:

```pascal
type
  TEngine = class ... end;

  TCar = class
  private
    fEngine: TEngine;
  end.
```

Правило: **наследование — только для отношения «is-a»**.
Для «has-a» используйте поле.

---

## 11. Типичные задачи

### Иерархия «Фигуры»

```pascal
type
  TFigure = class
  public
    function Area: Real; virtual;
    begin
      Result := 0;
    end;

    procedure Print;
    begin
      WriteLn('Площадь: ', Area:0:2);
    end;
  end;

  TCircle = class(TFigure)
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

  TRect = class(TFigure)
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

### Иерархия «Сотрудники»

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
```

### Цепочка из трёх уровней

```
TAnimal → TMammal → TDog
```

- `TAnimal` — общее: `name`, `Voice`.
- `TMammal` — добавляет `fLegs`, метод `Move`.
- `TDog` — конкретика: `Voice`, `fBreed`.

---

## 12. Частые ошибки

- **Забыли `override`** в наследнике — компилятор создаёт **новый** метод, а не переопределяет. Полиморфизм ломается.
- **Забыли `virtual`** в родителе — то же самое.
- **Разные заголовки** метода в родителе и наследнике — ошибка компиляции.
- **Обращение к `private`-полю родителя** — недоступно. Используйте `protected`.
- **`inherited (args);` в конструкторе наследника** — не работает в PascalABC.NET. Присваивайте поля родителя напрямую.
- **Имя программы совпадает с именем переменной** — `program Animals;` + `var animals` — конфликт. Переименуйте.
- **Наследование ради переиспользования кода** без отношения «is-a» — плохая практика. Используйте композицию.

---

## Примеры

- [inherit_basic.pas](inherit_basic.pas) — базовый класс и один наследник
- [inherit_override.pas](inherit_override.pas) — `virtual`/`override`, полиморфизм
- [inherit_constructor.pas](inherit_constructor.pas) — конструктор наследника без `inherited`
- [inherit_extend.pas](inherit_extend.pas) — новые поля и методы в наследнике
- [inherit_inherited.pas](inherit_inherited.pas) — `inherited` в методах
- [animals.pas](animals.pas) — иерархия животных, полиморфная коллекция
- [figures.pas](figures.pas) — иерархия фигур
- [employees.pas](employees.pas) — иерархия сотрудников

## Запуск

**PascalABC.NET:** открыть файл, F9.

## Что дальше

Урок 4 — полиморфизм и абстрактные методы.