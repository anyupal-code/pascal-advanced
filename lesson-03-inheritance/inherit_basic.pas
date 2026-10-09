program InheritBasic;

{ Базовый класс и один наследник. }

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

var
  d: TDog;

begin
  d := new TDog('Бим');
  d.Print;
end.