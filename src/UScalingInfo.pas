unit UScalingInfo;

interface

uses 
  W3System, W3Graphics;

procedure ScaleCanvas(newScreenWidth, newScreenHeight : integer; canvas : TW3Canvas);

const
  GAMEWIDTH = 1366;
  GAMEHEIGHT = 598;
  PIXELTOPOWERRATIO = 12;

var
  Scale : float;

implementation

procedure ScaleCanvas(newScreenWidth, newScreenHeight : integer; canvas : TW3Canvas);
var
  gameLength, gameDepth : float;
begin
  // Put canvas back to normal scale
  if Scale <> 0 then
    begin
      canvas.Scale(1 / Scale, 1 / Scale);
    end;

  // Get the new x and y lengths
  gameLength := newScreenWidth;
  gameDepth := (gameLength / 16) * 7; // Using 16:7 aspect ratio

  // If the new game size is too tall use the height as the base of the new scale
  if gameDepth >= newScreenHeight then
    begin
      gameDepth := newScreenHeight;
      gameLength := (gameDepth / 7) * 16;
    end;

  // Get the new scale
  Scale := gameLength / GAMEWIDTH;

  // Scale the canvas
  canvas.Scale(Scale, Scale);
end;


end.
