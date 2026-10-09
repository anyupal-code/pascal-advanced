program Employees;

{ Иерархия сотрудников: базовый оклад + бонус менеджера. }

type
  TEmployee = class
  protected
    fName: String;
    fBase: Real;
  public
    constructor (name: String; base: Real);
    begin
      fName := name;
      fBase := base;
    end;

    function Salary: Real; virtual;
    begin
      Result := fBase;
    end;

    procedure Print;
    begin
      WriteLn(fName, ': ', Salary:0:2);
    end;
  end;

  TManager = class(TEmployee)
  private
    fBonus: Real;
  public
    constructor (name: String; base, bonus: Real);
    begin
      fName := name;
      fBase := base;
      fBonus := bonus;
    end;

    function Salary: Real; override;
    begin
      Result := inherited Salary + fBonus;
    end;
  end;

var
  staff: array of TEmployee;
  i: Integer;

begin
  SetLength(staff, 3);
  staff[0] := new TEmployee('Иван', 50000);
  staff[1] := new TManager('Мария', 70000, 20000);
  staff[2] := new TEmployee('Пётр', 45000);

  for i := 0 to High(staff) do
    staff[i].Print;
end.