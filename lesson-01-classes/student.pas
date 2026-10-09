program StudentDemo;

{ Класс «Студент»: конструктор, метод, массив. }

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
  group: array of TStudent;
  n, i: Integer;
  sum: Real;

begin
  Write('Сколько студентов? '); ReadLn(n);
  SetLength(group, n);

  for i := 0 to n - 1 do
    group[i] := new TStudent('Студент ' + IntToStr(i + 1), 18, 4.0 + i * 0.1);

  sum := 0;
  for i := 0 to n - 1 do
  begin
    group[i].Print;
    sum := sum + group[i].avg;
  end;

  WriteLn('Средний балл: ', (sum / n):0:2);
end.