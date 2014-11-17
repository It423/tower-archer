unit UArrow;

interface

uses 
  W3System, W3Image;

type TArrow = class(TObject)
  X, Y, XVol, YVol : float;
  Active : boolean;
  constructor Create(newX, newY, newXVol, newYVol : float);
  procedure Move();
  function GetAngle(deg : boolean = false) : float;
  function MaxX() : float;
  function MinX() : float;
  function MaxY() : float;
  function MinY() : float;
end;

const
  GRAVITY = 1.5;

var
  ArrowTexture : TW3Image;
  MaxPower : float;

implementation

constructor TArrow.Create(newX, newY, newXVol, newYVol : float);
begin
  X := newX;
  Y := newY;
  XVol := newXVol;
  YVol := newYVol;
  Active := true;
end;

procedure TArrow.Move();
begin
  // Update x and y coordinates
  X += XVol;
  Y += YVol;

  // Add gravity affect
  YVol += GRAVITY;
end;

function TArrow.GetAngle(deg : boolean = false) : float;
var
  retVal : float;
begin
  // Get the angle from the velocity
  retVal := ArcTan2(YVol, XVol);

  // Convert to degreese if ordered to
  if deg then
    begin
      retVal *= 180 / Pi();
    end;

  exit(retVal);
end;

function MaxX() : float;
begin
  // Get the current angle (stops us running the same method over and over angin
  var currAng := GetAngle(true) mod 360;

  // Work out the max x value
  if (currAng <= 90) or ((currAng > 180) and (currAngle <= 270)) then
    begin
      exit(X + Sin(currAng mod 90) * ArrowTexture.Handle.Width + Cos(currAng mod 90) * ArrowTexture.Handle.Height);
    end
  else
    begin
      exit(X + Sin(currAng mod 90) * ArrowTexture.Handle.Width);
    end;
end;

function MinX() : float;
begin
  // Get the current angle (stops us running the same method over and over angin
  var currAng := GetAngle(true) mod 360;

  // Work out the min x value
  if (currAng <= 90) or ((currAng > 180) and (currAngle <= 270)) then
    begin
      exit(X);
    end
  else
    begin
      exit(X - Sin(currAng mod 90) * ArrowTexture.Handle.Height);
    end;
end;

function MaxY() : float;
begin
  // Get the current angle (stops us running the same method over and over angin
  var currAng := GetAngle(true) mod 360;

  // Work out the max y value
  if (currAng <= 90) or ((currAng > 180) and (currAngle <= 270)) then
    begin
      exit(Y + Sin(currAng mod 90) * ArrowTexture.Height);
    end
  else
    begin
      exit(Y + Cos(currAng mod 90) * ArrowTexture.Height + Sin(currAng mod 90) * ArrowTexture.Width);
    end;
end;

function MinY() : float;
begin
  // Get the current angle (stops us running the same method over and over angin
  var currAng := GetAngle(true) mod 360;

  // Work out the min y value
  if (currAng <= 90) or ((currAng > 180) and (currAngle <= 270)) then
    begin
      exit(Y - Cos(currAng mod 90) * ArrowTexture.Handle.Width);
    end
  else
    begin
      exit(Y);
    end;
end;

end.
