unit UDrawing;

interface

uses 
  W3System, W3Graphics,
  UTextures, UGameVariables, UArrow, UArcher, UEnemy, UGroundUnit, UAirUnit;

procedure DrawLoadingScreen(canvas : TW3Canvas);
procedure DrawArcher(archer : TArcher; canvas : TW3Canvas);
procedure DrawArrow(arrows : array of TArrow; canvas : TW3Canvas); overload;
procedure DrawArrow(arrow : TArrow; canvas : TW3Canvas); overload;
procedure DrawEnemy(enemy : array of TEnemy; canvas : TW3Canvas); overload;
procedure DrawEnemy(enemy : TEnemy; canvas : TW3Canvas); overload;
procedure RotateCanvas(angle, xChange, yChange : float; canvas : TW3Canvas);

implementation

procedure DrawLoadingScreen(canvas : TW3Canvas);
begin
  canvas.FillStyle := "blue";
  canvas.Font := "24pt verdana";
  canvas.FillTextF("Loading Content...", GameWidth / 2 - 137.5, GameHeight / 2 - 12, 275);
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
      DrawArrow(arrows[i], canvas);
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
      DrawEnemy(enemy[i], canvas);
    end;
end;

procedure DrawEnemy(enemy : TEnemy; canvas : TW3Canvas); overload;
begin
  if (enemy is TGroundUnit) then
    begin
      // Draw the ground unit if it is one
      canvas.DrawImageF(GroundUnitTexture.Handle, enemy.X, enemy.Y);
    end
  else if (enemy is TAirUnit) then
    begin
      // Draw the air unit if it is one
      canvas.DrawImageF(AirUnitTexture.Handle, enemy.X, enemy.Y);
    end;
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
