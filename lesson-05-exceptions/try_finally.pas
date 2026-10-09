program TryFinally;

{ Блок finally выполняется всегда. }

var
  f: Text;
  s: String;

begin
  Assign(f, 'demo.txt');
  Rewrite(f);

  try
    WriteLn(f, 'Строка 1');
    WriteLn(f, 'Строка 2');
    { здесь могла бы быть ошибка }
  finally
    Close(f);
    WriteLn('Файл закрыт');
  end;
end.