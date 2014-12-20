unit UDrawing;

interface

uses 
  W3System, W3Graphics,
  UTextures, UMouseInputs, UGameVariables, UArrow, UArcher, UPlayer, UEnemy, UGroundUnit, UAirUnit, UShop;

procedure DrawLoadingScreen(canvas : TW3Canvas);
procedure DrawScenery(canvas : TW3Canvas);
procedure DrawPlayer(player : TPlayer; canvas : TW3Canvas);
procedure DrawArcher(archer : TArcher; canvas : TW3Canvas);
procedure DrawArrow(arrows : array of TArrow; canvas : TW3Canvas); overload;
procedure DrawArrow(arrow : TArrow; canvas : TW3Canvas); overload;
procedure DrawEnemy(enemy : array of TEnemy; canvas : TW3Canvas); overload;
procedure DrawEnemy(enemy : TEnemy; canvas : TW3Canvas); overload;
procedure DrawMouseDragLine(player : TPlayer; canvas : TW3Canvas);
procedure DrawCanShoot(player : TPlayer; canvas : TW3Canvas);
procedure DrawHUD(canvas : TW3Canvas);
procedure DrawPauseScreen(canvas : TW3Canvas);
procedure RotateCanvas(angle, xChange, yChange : float; canvas : TW3Canvas);

implementation

procedure DrawLoadingScreen(canvas : TW3Canvas);
begin
  canvas.FillStyle := "blue";
  canvas.Font := "24pt verdana";
  canvas.FillTextF("Loading Content...", GameWidth / 2 - 137.5, GameHeight / 2 - 12, 275);
end;

procedure DrawScenery(canvas : TW3Canvas);
begin
  canvas.DrawImageF(TowerTexture.Handle, 0, GameHeight - TowerTexture.Handle.height);

  // Draw the shop button
  canvas.StrokeStyle := "rgb(0, 0, 0)";
  canvas.LineWidth := 4;
  canvas.FillStyle := "rgb(130, 120, 140)";
  canvas.StrokeRect(PauseButtonRect);
  canvas.FillRect(PauseButtonRect);

  // Get the correct text
  var text := "Shop";
  if Paused then
    begin
      text := "Resume";
    end;

  // Put the text in the button
  canvas.Font := IntToStr(Round(PauseButtonRect.Width() / 4)) + "pt verdana";
  canvas.FillStyle := "rgb(0, 0, 0)";
  canvas.TextAlign := "center";
  canvas.TextBaseLine := "middle";
  canvas.FillTextF(text, PauseButtonRect.CenterPoint().X, PauseButtonRect.CenterPoint().Y, PauseButtonRect.Width() - 10);
end;

procedure DrawPlayer(player : TPlayer; canvas : TW3Canvas);
begin
  // Draw the player
  DrawArcher(player, canvas);

  // Draw the extra archers
  for var i := 0 to High(player.ExtraArchers) do
    begin
      DrawArcher(player.ExtraArchers[i], canvas);
    end;
end;

procedure DrawArcher(archer : TArcher; canvas : TW3Canvas);
begin
  // Draw the body of the archer
  canvas.DrawImageF(ArcherTexture.Handle, archer.X, archer.Y);

  // Rotate the canvas for the bow
  RotateCanvas(archer.Angle(), archer.X + ArcherTexture.Handle.width / 2, archer.Y + ArcherTexture.Handle.height / 3, canvas);

  // Draw the bow
  canvas.DrawImageF(BowTexture.Handle, archer.X + ArcherTexture.Handle.width / 2, archer.Y + ArcherTexture.Handle.height / 3 - BowTexture.Handle.height / 2);

  // Draw the string drawback
  canvas.StrokeStyle := "rgb(0, 0, 0)";
  canvas.LineWidth := 0.1;
  canvas.BeginPath();
  canvas.MoveToF(archer.X + ArcherTexture.Handle.width / 2 + BowTexture.Handle.width * 3 / 5, archer.Y + ArcherTexture.Handle.height / 3 - BowTexture.Handle.height / 2);
  canvas.LineToF(archer.X + ArcherTexture.Handle.width / 2 + BowTexture.Handle.width * 3 / 5 - archer.Power() / 3, archer.Y + ArcherTexture.Handle.height / 3);
  canvas.MoveToF(archer.X + ArcherTexture.Handle.width / 2 + BowTexture.Handle.width * 3 / 5, archer.Y + ArcherTexture.Handle.height / 3 + BowTexture.Handle.height / 2);
  canvas.LineToF(archer.X + ArcherTexture.Handle.width / 2 + BowTexture.Handle.width * 3 / 5 - archer.Power() / 3, archer.Y + ArcherTexture.Handle.height / 3);
  canvas.ClosePath();
  canvas.Stroke();

  // Unrotate the canvas
  RotateCanvas(-archer.Angle(), archer.X + ArcherTexture.Handle.width / 2, archer.Y + ArcherTexture.Handle.height / 3, canvas);
end;

procedure DrawArrow(arrows : array of TArrow; canvas : TW3Canvas);
begin
  for var i := 0 to High(arrows) do
    begin
      if arrows[i].Active then
        begin
          DrawArrow(arrows[i], canvas);
        end;
    end;
end;

procedure DrawArrow(arrow : TArrow; canvas : TW3Canvas);
begin
  // Rotate the canvas
  RotateCanvas(arrow.GetAngle(), arrow.X, arrow.Y, canvas);

  // Draw the arrow
  canvas.DrawImageF(ArrowTexture.Handle, arrow.X, arrow.Y);

  // Rotate the canvas back
  RotateCanvas(-arrow.GetAngle(), arrow.X, arrow.Y, canvas);
end;

procedure DrawEnemy(enemy : array of TEnemy; canvas : TW3Canvas); overload;
begin
  for var i := 0 to High(enemy) do
    begin
      if enemy[i].Health > 0 then
        begin
          DrawEnemy(enemy[i], canvas);
        end;
    end;
end;

procedure DrawEnemy(enemy : TEnemy; canvas : TW3Canvas); overload;
begin
  if (enemy is TGroundUnit) then
    begin
      // Draw the ground unit if it is one
      canvas.DrawImageF(GroundUnitTexture.Handle, enemy.X, enemy.Y);

      // Draw it frozen if its meant to be
      if enemy.Frozen then
        begin
          canvas.DrawImageF(FrozenGroundUnitTexture.Handle, enemy.X, enemy.Y);
        end;
    end
  else if (enemy is TAirUnit) then
    begin
      // Draw the air unit if it is one
      canvas.DrawImageF(AirUnitTexture.Handle, enemy.X, enemy.Y);

      // Draw it frozen if its meant to be
      if enemy.Frozen then
        begin
          canvas.DrawImageF(FrozenAirUnitTexture.Handle, enemy.X, enemy.Y);
        end;
    end;
end;

procedure DrawMouseDragLine(player : TPlayer; canvas : TW3Canvas);
begin
  if MouseDown and player.CanShoot and not Paused then
    begin
      canvas.StrokeStyle := "rgba(0, 0, 0, 0.5)";
      canvas.LineWidth := 0.3;
      canvas.BeginPath();
      canvas.MoveToF(MouseDownX, MouseDownY);
      canvas.LineToF(CurrentMouseX, CurrentMouseY);
      canvas.ClosePath();
      canvas.Stroke();
    end;
end;

procedure DrawCanShoot(player : TPlayer; canvas : TW3Canvas);
begin
  // Get red (can't shoot) or green (can shoot) fillers
  if player.CanShoot then
    begin
      canvas.FillStyle := "rgba(0, 200, 0, 0.5)";
    end
  else
    begin
      canvas.FillStyle := "rgba(200, 0, 0, 0.5)";
    end;

  // Draw a circle around the mouse
  canvas.Ellipse(CurrentMouseX - 7, CurrentMouseY - 7, CurrentMouseX + 7, CurrentMouseY + 7);
  canvas.Fill();
end;

procedure DrawPauseScreen(canvas : TW3Canvas);
begin
  Shop.Draw(canvas);
end;

procedure DrawHUD(canvas : TW3Canvas);
begin

end;

procedure RotateCanvas(angle, xChange, yChange : float; canvas : TW3Canvas);
begin
  // Trasnlate the canvas so the 0,0 point is the center of the object being rotated
  canvas.Translate(xChange, yChange);

  // Rotate the canvas
  canvas.Rotate(angle);

  // Detranslate the canvas so the 0,0 point is the normal one
  canvas.Translate(-xChange, -yChange);
end;

end.
