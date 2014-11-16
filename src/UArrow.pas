unit UArrow;

interface

uses 
  W3System, W3Image;

type TArrow = class(TObject)
  X, Y, XVol, YVol : float;
  constructor Create(newX, newY, newXVol, newYVol : float);
  procedure Move();
  function GetAngle(deg : boolean = false) : float;
end;

const
  GRAVITY = 1.5;

var
  ArrowTexture : TW3Image;

implementation

constructor TArrow.Create(newX, newY, newXVol, newYVol : float);
begin
  X := newX;
  Y := newY;
  XVol := newXVol;
  YVol := newYVol;
end;

procedure TArrow.Move();
begin
  X += XVol;
  Y += YVol;

  YVol += GRAVITY;
end;

function TArrow.GetAngle(deg : boolean = false) : float;
var
  retVal : float;
begin
  // Get the angle from the velocity
  retVal := ArcTan(YVol / XVol);

  // Convert to degreese if ordered to
  if deg then
    begin
      retVal *= 180 / Pi();
    end;

  exit(retVal);
end;

end.
