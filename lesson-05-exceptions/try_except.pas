program TryExcept;

{ Базовый try ... except. }

var
  a, b: Integer;

begin
  Write('a = '); ReadLn(a);
  Write('b = '); ReadLn(b);

  try
    WriteLn('Результат: ', a div b);
  except
    WriteLn('Ошибка: деление на ноль');
  end;

  WriteLn('Программа продолжает работу');
end.