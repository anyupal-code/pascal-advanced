program InheritExtend;

{ Наследник добавляет свои поля и методы. }

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
  end;

  TDog = class(TAnimal)
  private
    fBreed: String;
  public
    constructor (name, breed: String);
    begin
      fName := name;
      fBreed := breed;
    end;

    function Voice: String; override;
    begin
      Result := 'Гав';
    end;

    procedure PrintBreed;
    begin
      WriteLn(fName, ' — ', fBreed);
    end;
  end;

var
  d: TDog;

begin
  d := new TDog('Бим', 'овчарка');
  WriteLn(d.Voice);
  d.PrintBreed;
end.