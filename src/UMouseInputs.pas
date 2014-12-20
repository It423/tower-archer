unit UMouseInputs;

interface

uses 
  W3System, W3Components,
  UPlayerData, UGameVariables, UGameItems, UShop;

procedure MouseDownHandler(o : TObject; b : TMouseButton; t : TShiftState; x, y : integer);
procedure MouseUpHandler(o : TObject; b : TMouseButton; t : TShiftState; x, y : integer);
procedure MouseMoveHandler(o : TObject; ss : TShiftState; x, y : integer);
procedure ChangeTimers(pause : boolean);

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
  // Change whether the game is paused if the shop/resume button was clicked
  if (MouseDown) and (b = TMouseButton.mbLeft) and (PauseButtonRect.ContainsPoint(TPoint.Create(x, y))) then
    begin
      MouseDown := false;

      // Pause/Resume all timers
      ChangeTimers(Paused);

      // Invert the paused variable
      Paused := not Paused;
      exit;
    end;

  if not Paused then
    begin
      // Only fire if the left mouse button was clicked
      if (MouseDown) and (b = TMouseButton.mbLeft) then
        begin
          Player.Fire();
        end;

      // Set the player's velocities to 0 to avoid display issues
      Player.UpdateInformation(0, 0, 0, 0);
    end
  else
    begin
      // Check what was clicked in the shop
      Shop.CheckClicked(x, y);
    end;

  MouseDown := false;
end;

procedure MouseMoveHandler(o : TObject; ss : TShiftState; x, y : integer);
begin
  CurrentMouseX := x;
  CurrentMouseY := y;

  if MouseDown and not Paused then
    begin
      Player.UpdateInformation(MouseDownX, MouseDownY, CurrentMouseX, CurrentMouseY);
    end;
end;

procedure ChangeTimers(pause : boolean);
begin
  if pause then
    begin
      // Resume timers if being unpaused
      Player.ResumeTimer();
      for var i := 0 to High(Enemies) do
        begin
          Enemies[i].ResumeTimer();
        end;
    end
  else
    begin
      // Pause timers if being paused
      Player.PauseTimer();
      for var i := 0 to High(Enemies) do
        begin
          Enemies[i].PauseTimer();
        end;
    end;
end;

end.
