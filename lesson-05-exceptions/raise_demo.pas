program RaiseDemo;

{ raise: явный выброс исключения. }

procedure CheckPositive(x: Integer);
begin
  if x <= 0 then
    raise new System.ArgumentException('x должен быть > 0');
  WriteLn('x = ', x, ' — ок');
end;

begin
  try
    CheckPositive(5);
    CheckPositive(-3);
  except
    on E: System.ArgumentException do
      WriteLn('Ошибка: ', E.Message);
  end;

  WriteLn('Программа продолжает работу');
end.