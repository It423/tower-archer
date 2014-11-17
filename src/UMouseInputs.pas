unit UMouseInputs;

interface

uses 
  W3System, W3Components,
  USpawner;

procedure MouseDownHandler(o : TObject; b : TMouseButton; t : TShiftState; x, y : integer);
procedure MouseUpHandler(o : TObject; b : TMouseButton; t : TShiftState; x, y : integer);
procedure MouseMoveHandler(o : TObject; ss : TShiftState; x, y : integer);

var
  MouseDown : boolean;
  MouseDownX, MouseDownY, CurrentMouseX, CurrentMouseY : integer;

implementation

procedure MouseDownHandler(o : TObject; b : TMouseButton; t : TShiftState; x, y : integer);
begin
  MouseDown := true;
  MouseDownX := x;
  MouseDownY := y;
end;

procedure MouseUpHandler(o : TObject; b : TMouseButton; t : TShiftState; x, y : integer);
begin
  MouseDown := false;

  SpawnArrow(MouseDownX, MouseDownY, CurrentMouseX, CurrentMouseY);
end;

procedure MouseMoveHandler(o : TObject; ss : TShiftState; x, y : integer);
begin
 CurrentMouseX := x;
 CurrentMouseY := y;
end;

end.
