program UseGeometry;

{ Демонстрация модуля Geometry. }

uses Geometry;

var
  a, b: TPoint;

begin
  a.x := 0; a.y := 0;
  b.x := 3; b.y := 4;

  WriteLn('Расстояние:     ', Distance(a, b):0:2);
  WriteLn('Площадь r=5:    ', CircleArea(5):0:2);
  WriteLn('Длина окружн.:  ', CircleCircumference(5):0:2);
end.