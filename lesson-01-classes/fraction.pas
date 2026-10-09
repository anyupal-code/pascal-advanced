program FractionDemo;

{ Класс «Дробь». }

type
  TFraction = class
    num, den: Integer;

    constructor (n, d: Integer);
    begin
      num := n;
      den := d;
    end;

    function Value: Real;
    begin
      Result := num / den;
    end;

    procedure Print;
    begin
      WriteLn(num, '/', den, ' = ', Value:0:3);
    end;
  end;

var
  f: TFraction;

begin
  f := new TFraction(3, 4);
  f.Print;

  f := new TFraction(7, 2);
  f.Print;
end.