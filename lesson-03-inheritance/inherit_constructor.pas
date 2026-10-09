program InheritConstructor;

{ Конструктор наследника: поля родителя присваиваются напрямую,
  без вызова inherited. }

type
  TAnimal = class
  protected
    fName: String;
  public
    constructor (name: String);
    begin
      fName := name;
    end;

    procedure Print;
    begin
      WriteLn('Имя: ', fName);
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

    procedure PrintFull;
    begin
      WriteLn(fName, ' породы ', fBreed);
    end;
  end;

var
  d: TDog;

begin
  d := new TDog('Бим', 'овчарка');
  d.Print;
  d.PrintFull;
end.