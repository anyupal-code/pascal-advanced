program InterfaceInherit;

{ Класс + наследование + интерфейс. }

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

  ICanFly = interface
    procedure Fly;
  end;

  TBird = class(TAnimal, ICanFly)
  public
    procedure Fly;
    begin
      WriteLn(fName, ' летит');
    end;
  end;

var
  b: TBird;

begin
  b := new TBird('Орёл');
  b.Print;
  b.Fly;
end.