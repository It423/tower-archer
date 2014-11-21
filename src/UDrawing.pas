unit UDrawing;

interface

uses 
  W3System, W3Graphics,
  UArrow, UArcher;

procedure DrawArcher(archer : TArcher; canvas : TW3Canvas);
procedure DrawArrow(arrows : array of TArrow; canvas : TW3Canvas); overload;
procedure DrawArrow(arrow : TArrow; canvas : TW3Canvas); overload;
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
  // Rotate the canvas correctly
  RotateCanvas(arrow.GetAngle(), arrow.X, arrow.Y, canvas);

  // Draw the arrow
  canvas.DrawImageF(ArrowTexture.Handle, arrow.X, arrow.Y);

  // Rotate the canvas back
  RotateCanvas(-arrow.GetAngle(), arrow.X, arrow.Y, canvas);
end;

procedure RotateCanvas(angle, xChange, yChange : float; canvas : TW3Canvas);
begin
  // Trasnlate the canvas so the 0,0 point is the center of the object being rotated
  Canvas.Translate(xChange, yChange);

  // Rotate the canvas
  Canvas.Rotate(angle);

  // Detranslate the canvas so the 0,0 point is the normal one
  Canvas.Translate(-xChange, -yChange);
end;

end.
