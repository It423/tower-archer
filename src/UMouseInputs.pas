unit UMouseInputs;

interface

uses 
  W3System, W3Components,
  UPlayerData;

procedure MouseDownHandler(o : TObject; b : TMouseButton; t : TShiftState; x, y : integer);
procedure MouseUpHandler(o : TObject; b : TMouseButton; t : TShiftState; x, y : integer);
procedure MouseMoveHandler(o : TObject; ss : TShiftState; x, y : integer);

var
  MouseDown : boolean;
  MouseDownX, MouseDownY, CurrentMouseX, CurrentMouseY : integer;

implementation

procedure MouseDownHandler(o : TObject; b : TMouseButton; t : TShiftState; x, y : integer);
begin
  // Only make the mouse down if the left mouse button is pressed
  if b = TMouseButton.mbLeft then
    begin
      MouseDown := true;
      MouseDownX := x;
      MouseDownY := y;
    end;
end;

procedure MouseUpHandler(o : TObject; b : TMouseButton; t : TShiftState; x, y : integer);
begin
  // Only fire if the left mouse button was clicked
  if (MouseDown) and (b = TMouseButton.mbLeft) then
    begin
      Player.Fire();
    end;

  MouseDown := false;

  // Set the player's velocities to 0 to avoid display issues
  Player.UpdateInformation(0, 0, 0, 0);
end;

procedure MouseMoveHandler(o : TObject; ss : TShiftState; x, y : integer);
begin
  CurrentMouseX := x;
  CurrentMouseY := y;

  if MouseDown then
    begin
      Player.UpdateInformation(MouseDownX, MouseDownY, CurrentMouseX, CurrentMouseY);
    end;
end;

end.
