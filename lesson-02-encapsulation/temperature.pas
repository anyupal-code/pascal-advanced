program TemperatureDemo;

{ Вычисляемое свойство Fahrenheit через геттер. }

type
  TTemp = class
  private
    fCelsius: Real;

    function GetFahrenheit: Real;
    begin
      Result := fCelsius * 9 / 5 + 32;
    end;

  public
    constructor (c: Real);
    begin
      fCelsius := c;
    end;

    property Celsius: Real read fCelsius write fCelsius;
    property Fahrenheit: Real read GetFahrenheit;
  end;

var
  t: TTemp;

begin
  t := new TTemp(25);
  WriteLn('Цельсий:     ', t.Celsius:0:1);
  WriteLn('Фаренгейт:   ', t.Fahrenheit:0:1);

  t.Celsius := 0;
  WriteLn('Цельсий:     ', t.Celsius:0:1);
  WriteLn('Фаренгейт:   ', t.Fahrenheit:0:1);
end.