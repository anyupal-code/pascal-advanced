program InheritInherited;

{ inherited в методе наследника. }

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
      Result := inherited Voice + ' Гав';
    end;
  end;

var
  d: TDog;

begin
  d := new TDog('Бим');
  d.Print;   { Бим: ... Гав }
end.