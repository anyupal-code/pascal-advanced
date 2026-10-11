# Продвинутый Pascal: ООП и алгоритмы

Продолжение курса [pascal-basics](https://github.com/anyupal-code/pascal-basics).
Второй том: объектно-ориентированное программирование, коллекции .NET,
сортировки, модули и итоговый проект.

## Содержание

| № | Тема | Конспект | Примеры |
|---|------|----------|---------|
| 1 | Классы и объекты | [README](lesson-01-classes/README.md) | [код](lesson-01-classes/) |
| 2 | Инкапсуляция и свойства | [README](lesson-02-encapsulation/README.md) | [код](lesson-02-encapsulation/) |
| 3 | Наследование | [README](lesson-03-inheritance/README.md) | [код](lesson-03-inheritance/) |
| 4 | Полиморфизм, абстрактные методы | [README](lesson-04-polymorphism/README.md) | [код](lesson-04-polymorphism/) |
| 5 | Исключения | [README](lesson-05-exceptions/README.md) | [код](lesson-05-exceptions/) |
| 6 | Интерфейсы | [README](lesson-06-interfaces/README.md) | [код](lesson-06-interfaces/) |
| 7 | Generics и коллекции .NET | [README](lesson-07-collections/README.md) | [код](lesson-07-collections/) |
| 8 | Сортировки и бинарный поиск | [README](lesson-08-sorting/README.md) | [код](lesson-08-sorting/) |
| 9 | Модули | [README](lesson-09-modules/README.md) | [код](lesson-09-modules/) |
| 10 | Итоговый проект | [README](lesson-10-project/README.md) | [код](lesson-10-project/) |

## Среда

Примеры курса рассчитаны на **PascalABC.NET** — свободную
реализацию Pascal для платформы .NET.

- Скачать: <https://pascalabc.net>
- VS Code + расширение PascalABC.NET: открыть `.pas` и нажать **F9**.

### Особенности по урокам

- **Уроки 1–8** — компилируются и запускаются в VS Code (F9).
- **Урок 9 (модули)** — расширение PascalABC.NET для VS Code
  не подхватывает модули автоматически. Программа выдаёт
  «Модуль не найден», хотя файл модуля лежит рядом.

  **Как запустить урок 9:** через **Free Pascal** (`fpc`) в терминале.

  - Установка в Fedora: `sudo dnf install fpc`
  - Windows / macOS: <https://www.freepascal.org/download.html>

  ```bash
  cd lesson-09-modules
  fpc use_mathutils.pas
  ./use_mathutils
  ```

### Требования

- PascalABC.NET 3.8+ (VS Code / standalone)
- Free Pascal 3.2+ — для урока 9 (опционально)
- Базовый курс [pascal-basics](https://github.com/anyupal-code/pascal-basics) — пройден

## Структура репозитория

```
pascal-advanced/
├── README.md
├── LICENSE
├── .gitignore
├── lesson-01-classes/
│   ├── README.md
│   └── *.pas
├── lesson-02-encapsulation/
├── ...
```

В каждой папке урока:

- `README.md` — конспект: цель, ключевые понятия, примеры, что дальше.
- `*.pas` — рабочие примеры кода с комментариями.

## Как проходить курс

1. Читаем `README.md` урока.
2. Открываем и разбираем примеры `*.pas`.
3. Запускаем в PascalABC.NET (F9).
4. Меняем, экспериментируем.
5. Переходим к следующему уроку.

## Ограничения PascalABC.NET, о которых стоит знать

По ходу курса мы столкнулись с рядом особенностей среды.
Они собраны здесь, чтобы не наступать на одни и те же грабли.

- **Автосвойства не поддерживаются.** `property X: Integer;`
  без `read`/`write` не компилируется. Пишите
  `property X: Integer read fX write fX;`.
- **`read`/`write` принимают только имя поля или метода**, не выражение.
  Для вычисляемых свойств заводите геттер-функцию.
- **`inherited (args);` в конструкторе наследника не работает.**
  Присваивайте поля родителя напрямую — они `protected`.
- **Имя программы не должно совпадать с именем переменной.**
  Регистр не важен: `program Shapes;` + `var shapes` — конфликт.
- **Модули (`unit`) не подхватываются в VS Code.** См. урок 9.

## Лицензия

MIT