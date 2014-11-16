unit UDrawing;

interface

uses 
  W3System, W3Graphics,
  UArrow;

procedure DrawArrow(arrow : TArrow; canvas : TW3Canvas);
procedure RotateCanvas(angle, xChange, yChange : float; canvas : TW3Canvas);

implementation

procedure DrawArrow(arrow : TArrow; canvas : TW3Canvas);
begin
  // Rotate the canvas correctly
  RotateCanvas(arrow.GetAngle(), arrow.X + ArrowTexture.Handle.width / 2, arrow.Y + ArrowTexture.Handle.height / 2, canvas);

  // Draw the arrow
  canvas.DrawImageF(ArrowTexture.Handle, arrow.X, arrow.Y);

  // Rotate the canvas back
  RotateCanvas(-arrow.GetAngle(), arrow.X + ArrowTexture.Handle.width / 2, arrow.Y + ArrowTexture.Handle.height / 2, canvas);
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
