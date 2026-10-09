program AbstractClass;

{ Абстрактный класс: нельзя создать объект,
  но можно хранить наследников. }

type
  TAnimal = class
  public
    function Voice: String; virtual; abstract;
    function Name: String; virtual; abstract;

    procedure Print;
    begin
      WriteLn(Name, ' говорит ', Voice);
    end;
  end;

  TDog = class(TAnimal)
  public
    function Voice: String; override;
    begin
      Result := 'Гав';
    end;

    function Name: String; override;
    begin
      Result := 'Собака';
    end;
  end;

var
  a: TAnimal;

begin
  a := new TDog;
  a.Print;
end.