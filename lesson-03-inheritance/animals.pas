program AnimalsDemo;

{ Иерархия животных, полиморфная коллекция. }

type
  TAnimal = class
  protected
    fName: String;
  public
    constructor (name: String);
    begin
      fName := name;
    end;

    function Voice: String; virtual;
    begin
      Result := '...';
    end;

    procedure Print;
    begin
      WriteLn(fName, ': ', Voice);
    end;
  end;

  TDog = class(TAnimal)
  public
    function Voice: String; override;
    begin
      Result := 'Гав';
    end;
  end;

  TCat = class(TAnimal)
  public
    function Voice: String; override;
    begin
      Result := 'Мяу';
    end;
  end;

var
  pets: array of TAnimal;
  i: Integer;

begin
  SetLength(pets, 4);
  pets[0] := new TDog('Бим');
  pets[1] := new TCat('Мурка');
  pets[2] := new TDog('Рекс');
  pets[3] := new TCat('Барсик');

  for i := 0 to High(pets) do
    pets[i].Print;
end.