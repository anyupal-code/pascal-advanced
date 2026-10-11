# Урок 9. Модули

## Цель

Научиться разбивать программу на несколько файлов-модулей,
подключать их через `uses` и организовывать код в переиспользуемые
библиотеки.

## Среда и ограничения

Модули в **PascalABC.NET внутри VS Code** не подхватываются автоматически —
расширение компилирует только текущий файл. Программа выдаёт
«Модуль не найден», хотя файл модуля лежит рядом.

Примеры урока проверены во **Free Pascal (fpc)**.

**Установка Free Pascal:**

- Fedora: `sudo dnf install fpc`
- Windows / macOS: <https://www.freepascal.org/download.html>

**Запуск примера:**

```bash
cd lesson-09-modules
fpc use_mathutils.pas
./use_mathutils
```

## Ключевые понятия

- **Модуль (unit)** — отдельный `.pas`-файл с заголовком `unit`.
- **Интерфейсная секция (`interface`)** — что модуль отдаёт наружу.
- **Секция реализации (`implementation`)** — как это устроено внутри.
- **`uses`** — подключение модуля к программе.

---

## 1. Зачем модули

- **Разбиение** большой программы на части.
- **Переиспользование** — один модуль в разных программах.
- **Инкапсуляция** — наружу видно только то, что в `interface`.
- **Порядок** — один модуль, одна логическая тема.

Один модуль — один файл — одна тема: `MathUtils`, `Geometry`.

---

## 2. Структура модуля

```pascal
unit MathUtils;

interface
  { Что видно снаружи: заголовки функций, типы, константы }

  function Square(x: Integer): Integer;
  function Cube(x: Integer): Integer;

implementation
  { Тела функций }

  function Square(x: Integer): Integer;
  begin
    Square := x * x;
  end;

  function Cube(x: Integer): Integer;
  begin
    Cube := x * x * x;
  end;

end.
```

- **`unit Имя;`** — заголовок модуля.
- **`interface`** — публичная часть: **только заголовки**.
- **`implementation`** — тела функций.
- **`end.`** с точкой — конец модуля.
- Имя файла должно совпадать с именем модуля: `mathutils.pas`.

---

## 3. Подключение модуля

Программа в **той же папке**:

```pascal
program UseMathUtils;

uses MathUtils;

begin
  WriteLn(Square(5));
  WriteLn(Cube(3));
end.
```

- `uses MathUtils;` — компилятор найдёт `mathutils.pas` в той же папке.
- Функции вызываются по имени, как обычные.

---

## 4. Что попадает в `interface`, а что в `implementation`

**В `interface`:**

- публичные типы, константы,
- **заголовки** функций и процедур.

**В `implementation`:**

- **тела** функций и процедур,
- приватные типы и переменные,
- вспомогательные подпрограммы, которые снаружи не нужны.

**Правило:** всё, что в `interface`, видно снаружи. Всё, что только
в `implementation`, — скрыто.

### Приватная функция

```pascal
unit MathUtils;

interface
  function Square(x: Integer): Integer;

implementation

function Helper(x: Integer): Integer;
begin
  Helper := x * x;
end;

function Square(x: Integer): Integer;
begin
  Square := Helper(x);
end;

end.
```

`Helper` недоступна снаружи — только внутри модуля.

---

## 5. Полный пример: модуль геометрии

**`geometry.pas`**

```pascal
unit Geometry;

interface

const
  Pi = 3.14159;

type
  TPoint = record
    x, y: Real;
  end;

function Distance(a, b: TPoint): Real;
function CircleArea(r: Real): Real;
function CircleCircumference(r: Real): Real;

implementation

function Distance(a, b: TPoint): Real;
begin
  Distance := Sqrt(Sqr(a.x - b.x) + Sqr(a.y - b.y));
end;

function CircleArea(r: Real): Real;
begin
  CircleArea := Pi * r * r;
end;

function CircleCircumference(r: Real): Real;
begin
  CircleCircumference := 2 * Pi * r;
end;

end.
```

**`use_geometry.pas`**

```pascal
program UseGeometry;

uses Geometry;

var
  a, b: TPoint;

begin
  a.x := 0; a.y := 0;
  b.x := 3; b.y := 4;

  WriteLn('Расстояние:    ', Distance(a, b):0:2);
  WriteLn('Площадь:       ', CircleArea(5):0:2);
  WriteLn('Длина окружн.: ', CircleCircumference(5):0:2);
end.
```

---

## 6. Имена файлов и модулей

- Имя файла = имя модуля: `mathutils.pas` → `unit MathUtils;`.
- Имя модуля **уникально** в проекте.
- Регистр не важен, но принято писать с заглавной буквы.
- Один модуль — один файл.

---

## 7. Частые ошибки

- **Имя файла не совпадает с именем модуля** — компилятор не найдёт модуль.
- **Забыли `uses`** — функции модуля не видны.
- **Объявили в `interface`, но забыли тело в `implementation`** —
  ошибка компиляции.
- **Точка с запятой после `end.`** — не нужна.
- **Точка в `end.`** — обязательна.
- **Запуск модуля, а не программы** — модуль не запускается.
  Запускается только программа (`use_*.pas`).
- **Имя переменной совпадает с именем модуля** — `uses Geometry;` +
  `var geometry: ...` — конфликт. Регистр не важен, переименуйте переменную.
- **`Result` в строгом режиме FPC** — не работает.
  Пишите имя функции: `Square := x * x`.
- **PascalABC.NET в VS Code не находит модуль** — известное ограничение.
  Запускайте через `fpc` в терминале.

---

## Примеры

- [mathutils.pas](mathutils.pas) — модуль с функциями
- [use_mathutils.pas](use_mathutils.pas) — программа с MathUtils
- [geometry.pas](geometry.pas) — модуль с типом и константой
- [use_geometry.pas](use_geometry.pas) — программа с Geometry

## Запуск

```bash
cd lesson-09-modules
fpc use_mathutils.pas && ./use_mathutils
fpc use_geometry.pas && ./use_geometry
```

## Что дальше

Урок 10 — итоговый проект.