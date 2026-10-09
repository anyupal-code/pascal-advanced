program CounterDemo;

{ Класс «Счётчик». }

type
  TCounter = class
    value: Integer;

    constructor;
    begin
      value := 0;
    end;

    procedure Inc;
    begin
      value := value + 1;
    end;

    procedure Reset;
    begin
      value := 0;
    end;

    function Get: Integer;
    begin
      Result := value;
    end;
  end;

var
  c: TCounter;

begin
  c := new TCounter;
  c.Inc;
  c.Inc;
  c.Inc;
  WriteLn('Значение: ', c.Get);

  c.Reset;
  WriteLn('После сброса: ', c.Get);
end.