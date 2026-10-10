program PrintableDemo;

{ Интерфейс IPrintable: единый способ печати разных объектов. }

type
  IPrintable = interface
    procedure Print;
  end;

  TPerson = class(IPrintable)
  private
    fName: String;
  public
    constructor (name: String);
    begin
      fName := name;
    end;

    procedure Print;
    begin
      WriteLn('Человек: ', fName);
    end;
  end;

  TBook = class(IPrintable)
  private
    fTitle: String;
    fPages: Integer;
  public
    constructor (title: String; pages: Integer);
    begin
      fTitle := title;
      fPages := pages;
    end;

    procedure Print;
    begin
      WriteLn('Книга: ', fTitle, ' (', fPages, ' стр.)');
    end;
  end;

var
  items: array of IPrintable;
  i: Integer;

begin
  SetLength(items, 3);
  items[0] := new TPerson('Иван');
  items[1] := new TBook('Pascal для всех', 300);
  items[2] := new TPerson('Мария');

  for i := 0 to High(items) do
    items[i].Print;
end.