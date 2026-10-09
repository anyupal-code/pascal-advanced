program SafeInput;

{ Безопасный ввод числа через try. }

function ReadInt(prompt: String): Integer;
var
  s: String;
begin
  while True do
  begin
    Write(prompt);
    ReadLn(s);
    try
      Result := StrToInt(s);
      Exit;
    except
      on E: System.FormatException do
        WriteLn('Это не число, попробуйте снова');
    end;
  end;
end;

var
  n: Integer;

begin
  n := ReadInt('Введите число: ');
  WriteLn('Вы ввели: ', n);
end.