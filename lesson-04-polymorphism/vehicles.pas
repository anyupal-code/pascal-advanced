program VehiclesDemo;

{ Иерархия транспорта. }

type
  TVehicle = class
  public
    function Name: String; virtual; abstract;
    function MaxSpeed: Integer; virtual; abstract;

    procedure Print;
    begin
      WriteLn(Name, ': до ', MaxSpeed, ' км/ч');
    end;
  end;

  TCar = class(TVehicle)
  public
    function Name: String; override;
    begin
      Result := 'Автомобиль';
    end;

    function MaxSpeed: Integer; override;
    begin
      Result := 220;
    end;
  end;

  TBike = class(TVehicle)
  public
    function Name: String; override;
    begin
      Result := 'Велосипед';
    end;

    function MaxSpeed: Integer; override;
    begin
      Result := 40;
    end;
  end;

  TPlane = class(TVehicle)
  public
    function Name: String; override;
    begin
      Result := 'Самолёт';
    end;

    function MaxSpeed: Integer; override;
    begin
      Result := 900;
    end;
  end;

var
  items: array of TVehicle;
  i: Integer;

begin
  SetLength(items, 3);
  items[0] := new TCar;
  items[1] := new TBike;
  items[2] := new TPlane;

  for i := 0 to High(items) do
    items[i].Print;
end.