unit UDrawing;

interface

uses 
  W3System, W3Graphics,
  UTextures, UArrow, UArcher, UEnemy, UGroundUnit;

procedure DrawArcher(archer : TArcher; canvas : TW3Canvas);
procedure DrawArrow(arrows : array of TArrow; canvas : TW3Canvas); overload;
procedure DrawArrow(arrow : TArrow; canvas : TW3Canvas); overload;
procedure DrawEnemy(enemy : array of TEnemy; canvas : TW3Canvas); overload;
procedure DrawEnemy(enemy : TEnemy; canvas : TW3Canvas); overload;
procedure RotateCanvas(angle, xChange, yChange : float; canvas : TW3Canvas);

implementation

procedure DrawArcher(archer : TArcher; canvas : TW3Canvas);
begin

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
      canvas.DrawImageF(GroundUnitTexture.Handle, enemy.X, enemy.Y);
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
