program CustomException;

{ Свой класс исключения. }

type
  TAgeException = class(Exception)
  public
    constructor (msg: String);
    begin
      inherited Create(msg);
    end;
  end;

procedure SetAge(age: Integer);
begin
  if (age < 0) or (age > 150) then
    raise new TAgeException('Возраст: 0..150');
  WriteLn('Возраст принят: ', age);
end;

begin
  try
    SetAge(30);
    SetAge(200);
  except
    on E: TAgeException do
      WriteLn('Ошибка возраста: ', E.Message);
  end;
end.