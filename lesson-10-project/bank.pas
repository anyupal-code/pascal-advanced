program BankSystem;

{ Итоговый проект: банковская система.
  Демонстрирует: ООП, интерфейсы, исключения, коллекции, файлы. }

const
  DATA_FILE = 'bank.txt';

type
  { Собственное исключение для банковских ошибок }
  TBankException = class(Exception)
  public
    constructor (msg: String);
    begin
      inherited Create(msg);
    end;
  end;

  { Интерфейс: единый вывод для всех сущностей }
  IPrintable = interface
    procedure Print;
  end;

  { Абстрактный базовый счёт }
  TAccount = class(IPrintable)
  protected
    fNumber: String;
    fOwner: String;
    fBalance: Real;
    fHistory: List<String>;

    procedure AddHistory(op: String);
    function AccountType: String; virtual; abstract;
    procedure DoWithdraw(amount: Real); virtual; abstract;
  public
    constructor (num, owner: String; initial: Real);
    begin
      fNumber := num;
      fOwner := owner;
      fBalance := initial;
      fHistory := new List<String>;
    end;

    property Number: String read fNumber;
    property Owner: String read fOwner;
    property Balance: Real read fBalance;

    procedure Deposit(amount: Real);
    begin
      if amount <= 0 then
        raise new TBankException('Сумма должна быть > 0');
      fBalance := fBalance + amount;
      AddHistory('Пополнение: +' + amount.ToString('0.00'));
    end;

    procedure Withdraw(amount: Real);
    begin
      if amount <= 0 then
        raise new TBankException('Сумма должна быть > 0');
      DoWithdraw(amount);
      fBalance := fBalance - amount;
      AddHistory('Снятие: -' + amount.ToString('0.00'));
    end;

    procedure Print;
    begin
      WriteLn(AccountType, ' ', fNumber, ' | ', fOwner,
        ' | баланс: ', fBalance:0:2);
    end;

    procedure PrintHistory;
    var
      i: Integer;
    begin
      WriteLn('История по счёту ', fNumber, ':');
      if fHistory.Count = 0 then
        WriteLn('  (операций не было)')
      else
        for i := 0 to fHistory.Count - 1 do
          WriteLn('  ', fHistory[i]);
    end;
  end;

  { Обычный счёт — снятие без ограничений }
  TDebitAccount = class(TAccount)
  protected
    function AccountType: String; override;
    begin
      Result := 'Дебетовый';
    end;

    procedure DoWithdraw(amount: Real); override;
    begin
      if amount > fBalance then
        raise new TBankException('Недостаточно средств');
    end;
  end;

  { Сберегательный — снятие не больше 50% от баланса }
  TSavingsAccount = class(TAccount)
  protected
    function AccountType: String; override;
    begin
      Result := 'Сберегательный';
    end;

    procedure DoWithdraw(amount: Real); override;
    begin
      if amount > fBalance * 0.5 then
        raise new TBankException(
          'Сберегательный счёт: снятие не более 50%');
    end;
  end;

  { Кредитный — с лимитом (можно уйти в минус до -лимита) }
  TCreditAccount = class(TAccount)
  private
    fLimit: Real;
  public
    constructor (num, owner: String; initial, limit: Real);
    begin
      inherited Create(num, owner, initial);
      fLimit := limit;
    end;

    property Limit: Real read fLimit;
  protected
    function AccountType: String; override;
    begin
      Result := 'Кредитный';
    end;

    procedure DoWithdraw(amount: Real); override;
    begin
      if fBalance - amount < -fLimit then
        raise new TBankException('Превышен кредитный лимит');
    end;
  end;

{ --- Вспомогательные процедуры --- }

procedure TAccount.AddHistory(op: String);
begin
  fHistory.Add(op);
end;

{ --- Банк: хранилище счетов --- }

type
  TBank = class
  private
    fAccounts: List<TAccount>;
    fIndex: Dictionary<String, TAccount>;
  public
    constructor;
    begin
      fAccounts := new List<TAccount>;
      fIndex := new Dictionary<String, TAccount>;
    end;

    procedure Add(acc: TAccount);
    begin
      if fIndex.ContainsKey(acc.Number) then
        raise new TBankException('Счёт с таким номером уже существует');
      fAccounts.Add(acc);
      fIndex[acc.Number] := acc;
    end;

    function Find(num: String): TAccount;
    begin
      if not fIndex.ContainsKey(num) then
        raise new TBankException('Счёт не найден: ' + num);
      Result := fIndex[num];
    end;

    procedure PrintAll;
    var
      i: Integer;
    begin
      if fAccounts.Count = 0 then
      begin
        WriteLn('Счетов нет');
        Exit;
      end;
      for i := 0 to fAccounts.Count - 1 do
        fAccounts[i].Print;
    end;

    procedure PrintSortedByBalance;
    var
      sorted: sequence of TAccount;
    begin
      sorted := fAccounts.OrderBy(a -> a.Balance);
      foreach var a in sorted do
        a.Print;
    end;

    procedure SaveToFile;
    var
      f: Text;
      i: Integer;
      a: TAccount;
      kind: String;
    begin
      Assign(f, DATA_FILE);
      Rewrite(f);
      for i := 0 to fAccounts.Count - 1 do
      begin
        a := fAccounts[i];
        if a is TDebitAccount then kind := 'debit'
        else if a is TSavingsAccount then kind := 'savings'
        else kind := 'credit';
        WriteLn(f, kind, ';', a.Number, ';', a.Owner, ';', a.Balance:0:2);
      end;
      Close(f);
      WriteLn('Сохранено в ', DATA_FILE);
    end;

    procedure LoadFromFile;
    var
      f: Text;
      line, kind, num, owner, balStr: String;
      bal: Real;
      parts: array of String;
      acc: TAccount;
    begin
      if not FileExists(DATA_FILE) then
      begin
        WriteLn('Файл ', DATA_FILE, ' не найден');
        Exit;
      end;

      Assign(f, DATA_FILE);
      Reset(f);
      while not Eof(f) do
      begin
        ReadLn(f, line);
        parts := line.Split(';');
        if Length(parts) < 4 then continue;

        kind := parts[0];
        num := parts[1];
        owner := parts[2];
        balStr := parts[3];
        bal := StrToFloat(balStr);

        if kind = 'debit' then
          acc := TDebitAccount.Create(num, owner, bal)
        else if kind = 'savings' then
          acc := TSavingsAccount.Create(num, owner, bal)
        else
          acc := TCreditAccount.Create(num, owner, bal, 10000);

        Add(acc);
      end;
      Close(f);
      WriteLn('Загружено счетов: ', fAccounts.Count);
    end;

    function Count: Integer;
    begin
      Result := fAccounts.Count;
    end;
  end;

{ --- Вспомогательные функции --- }

function ReadReal(prompt: String): Real;
var
  s: String;
begin
  while True do
  begin
    Write(prompt);
    ReadLn(s);
    try
      Result := StrToFloat(s);
      Exit;
    except
      on E: Exception do
        WriteLn('Это не число');
    end;
  end;
end;

function ReadLineNotEmpty(prompt: String): String;
var
  s: String;
begin
  while True do
  begin
    Write(prompt);
    ReadLn(s);
    if s <> '' then Exit(s);
    WriteLn('Пустое значение недопустимо');
  end;
end;

procedure PrintMenu;
begin
  WriteLn;
  WriteLn('=== Банковская система ===');
  WriteLn('1. Показать все счета');
  WriteLn('2. Создать дебетовый счёт');
  WriteLn('3. Создать сберегательный счёт');
  WriteLn('4. Создать кредитный счёт');
  WriteLn('5. Пополнить счёт');
  WriteLn('6. Снять со счёта');
  WriteLn('7. Перевод между счетами');
  WriteLn('8. История по счёту');
  WriteLn('9. Сортировать по балансу');
  WriteLn('10. Сохранить в файл');
  WriteLn('11. Загрузить из файла');
  WriteLn('0. Выход');
  Write('Выбор: ');
end;

{ --- Основная программа --- }

var
  bank: TBank;
  choice: Integer;
  num, owner, num2: String;
  amount: Real;

begin
  bank := new TBank;

  if FileExists(DATA_FILE) then
    bank.LoadFromFile;

  repeat
    PrintMenu;
    ReadLn(choice);

    try
      case choice of
        1: bank.PrintAll;

        2: begin
             num := ReadLineNotEmpty('Номер счёта: ');
             owner := ReadLineNotEmpty('Владелец: ');
             amount := ReadReal('Начальный баланс: ');
             bank.Add(TDebitAccount.Create(num, owner, amount));
             WriteLn('Счёт создан');
           end;

        3: begin
             num := ReadLineNotEmpty('Номер счёта: ');
             owner := ReadLineNotEmpty('Владелец: ');
             amount := ReadReal('Начальный баланс: ');
             bank.Add(TSavingsAccount.Create(num, owner, amount));
             WriteLn('Счёт создан');
           end;

        4: begin
             num := ReadLineNotEmpty('Номер счёта: ');
             owner := ReadLineNotEmpty('Владелец: ');
             amount := ReadReal('Начальный баланс: ');
             bank.Add(TCreditAccount.Create(num, owner, amount, 10000));
             WriteLn('Счёт создан (лимит 10000)');
           end;

        5: begin
             num := ReadLineNotEmpty('Номер счёта: ');
             amount := ReadReal('Сумма: ');
             bank.Find(num).Deposit(amount);
             WriteLn('Пополнено');
           end;

        6: begin
             num := ReadLineNotEmpty('Номер счёта: ');
             amount := ReadReal('Сумма: ');
             bank.Find(num).Withdraw(amount);
             WriteLn('Снято');
           end;

        7: begin
             num := ReadLineNotEmpty('Откуда (номер): ');
             num2 := ReadLineNotEmpty('Куда (номер): ');
             amount := ReadReal('Сумма: ');
             bank.Find(num).Withdraw(amount);
             bank.Find(num2).Deposit(amount);
             WriteLn('Перевод выполнен');
           end;

        8: begin
             num := ReadLineNotEmpty('Номер счёта: ');
             bank.Find(num).PrintHistory;
           end;

        9: bank.PrintSortedByBalance;

        10: bank.SaveToFile;

        11: bank.LoadFromFile;

        0: WriteLn('До свидания');
      else
        WriteLn('Неверный пункт меню');
      end;
    except
      on E: TBankException do
        WriteLn('Ошибка: ', E.Message);
      on E: Exception do
        WriteLn('Непредвиденная ошибка: ', E.Message);
    end;

  until choice = 0;
end.