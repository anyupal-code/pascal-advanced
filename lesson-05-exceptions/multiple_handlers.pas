program MultipleHandlers;

{ Несколько обработчиков исключений. }

var
  s: String;
  x: Integer;

begin
  Write('Число: '); ReadLn(s);

  try
    x := StrToInt(s);
    WriteLn('Результат: ', 100 div x);
  except
    on E: System.FormatException do
      WriteLn('Не число: ', s);
    on E: System.DivideByZeroException do
      WriteLn('Деление на ноль');
    on E: Exception do
      WriteLn('Другая ошибка: ', E.Message);
  end;
end.