program StudentDemo;

{ Класс «Студент» с проверками в сеттерах. }

type
  TStudent = class
  private
    fName: String;
    fAge: Integer;
    fAvg: Real;

    procedure SetAge(v: Integer);
    begin
      if (v < 14) or (v > 100) then
        raise new System.ArgumentException('Возраст: 14..100');
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

var
  s: TStudent;

begin
  s := new TStudent('Иван');
  s.Age := 19;
  s.Avg := 4.5;
  s.Print;

  try
    s.Age := 5;
  except
    on e: System.ArgumentException do
      WriteLn('Ошибка: ', e.Message);
  end;
end.