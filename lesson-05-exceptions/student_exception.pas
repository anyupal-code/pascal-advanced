program StudentException;

{ Класс с проверками в сеттере. }

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

var
  s: TStudent;

begin
  s := new TStudent('Иван');

  try
    s.Age := 19;
    WriteLn('Возраст: ', s.Age);

    s.Age := 200;
  except
    on E: System.ArgumentException do
      WriteLn('Ошибка: ', E.Message);
  end;

  WriteLn('Возраст остался: ', s.Age);
end.