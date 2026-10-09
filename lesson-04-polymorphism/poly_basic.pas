program PolyBasic;

{ virtual + override = полиморфизм. }

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
  a: TAnimal;

begin
  a := new TDog('Бим');
  a.Print;

  a := new TCat('Мурка');
  a.Print;
end.