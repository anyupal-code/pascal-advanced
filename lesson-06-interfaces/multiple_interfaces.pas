program MultipleInterfaces;

{ Один класс — два интерфейса. }

type
  ICanFly = interface
    procedure Fly;
  end;

  ICanSwim = interface
    procedure Swim;
  end;

  TDuck = class(ICanFly, ICanSwim)
  public
    procedure Fly;
    begin
      WriteLn('Утка летит');
    end;

    procedure Swim;
    begin
      WriteLn('Утка плывёт');
    end;
  end;

var
  d: TDuck;
  flyer: ICanFly;
  swimmer: ICanSwim;

begin
  d := new TDuck;

  flyer := d;
  flyer.Fly;

  swimmer := d;
  swimmer.Swim;
end.