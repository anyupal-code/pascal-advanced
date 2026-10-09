program PropertyValidation;

{ Проверка в сеттере. }

type
  TAge = class
  private
    fValue: Integer;

    procedure SetValue(v: Integer);
    begin
      if (v < 0) or (v > 150) then
        raise new System.ArgumentException('Возраст: 0..150');
      fValue := v;
    end;

  public
    property Value: Integer read fValue write SetValue;
  end;

var
  a: TAge;

begin
  a := new TAge;

  a.Value := 30;
  WriteLn('Возраст: ', a.Value);

  try
    a.Value := 200;
  except
    on e: System.ArgumentException do
      WriteLn('Ошибка: ', e.Message);
  end;
end.