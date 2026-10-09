program AccountDemo;

{ Банковский счёт: баланс только для чтения,
  изменение — через Deposit/Withdraw. }

type
  TAccount = class
  private
    fOwner: String;
    fBalance: Real;

    procedure SetBalance(v: Real);
    begin
      if v < 0 then
        raise new System.ArgumentException('Баланс < 0');
      fBalance := v;
    end;

  public
    constructor (owner: String; initial: Real);
    begin
      fOwner := owner;
      SetBalance(initial);
    end;

    property Owner: String read fOwner;
    property Balance: Real read fBalance;

    procedure Deposit(amount: Real);
    begin
      if amount <= 0 then
        raise new System.ArgumentException('Сумма должна быть > 0');
      SetBalance(fBalance + amount);
    end;

    procedure Withdraw(amount: Real);
    begin
      if amount <= 0 then
        raise new System.ArgumentException('Сумма должна быть > 0');
      if amount > fBalance then
        raise new System.ArgumentException('Недостаточно средств');
      SetBalance(fBalance - amount);
    end;

    procedure Print;
    begin
      WriteLn(fOwner, ': ', fBalance:0:2);
    end;
  end;

var
  acc: TAccount;

begin
  acc := new TAccount('Иван', 1000);
  acc.Print;

  acc.Deposit(500);
  acc.Print;

  try
    acc.Withdraw(2000);
  except
    on e: System.ArgumentException do
      WriteLn('Ошибка: ', e.Message);
  end;

  acc.Withdraw(300);
  acc.Print;
end.