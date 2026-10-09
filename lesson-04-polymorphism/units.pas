program UnitsDemo;

{ Юниты с разной атакой и защитой.
  Конструкторы наследников принимают HP и задают свои характеристики. }

type
  TUnit = class
  protected
    fName: String;
    fHP: Integer;
  public
    constructor (name: String; hp: Integer);
    begin
      fName := name;
      fHP := hp;
    end;

    function Attack: Integer; virtual; abstract;
    function Defense: Integer; virtual; abstract;

    procedure Print;
    begin
      WriteLn(fName, ': HP ', fHP, ', атака ', Attack, ', защита ', Defense);
    end;
  end;

  TWarrior = class(TUnit)
  public
    constructor (hp: Integer);
    begin
      fName := 'Воин';
      fHP := hp;
    end;

    function Attack: Integer; override;
    begin
      Result := 20;
    end;

    function Defense: Integer; override;
    begin
      Result := 15;
    end;
  end;

  TMage = class(TUnit)
  public
    constructor (hp: Integer);
    begin
      fName := 'Маг';
      fHP := hp;
    end;

    function Attack: Integer; override;
    begin
      Result := 30;
    end;

    function Defense: Integer; override;
    begin
      Result := 5;
    end;
  end;

var
  army: array of TUnit;
  i: Integer;

begin
  SetLength(army, 4);
  army[0] := new TWarrior(100);
  army[1] := new TMage(60);
  army[2] := new TWarrior(120);
  army[3] := new TMage(50);

  for i := 0 to High(army) do
    army[i].Print;
end.