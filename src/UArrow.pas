unit UArrow;

interface

uses 
  W3System, W3Image,
  UGameVariables;

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

  // Make the bullet inactive if out off screen
  if (MaxX() < 0) or (MinX() > GameWidth) or (MinY() > GameHeight) then
    begin
      Active := false;
    end;
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

function TArrow.MaxX() : float;
begin
  // Get the current angle (stops us running the same method over and over angin
  var currAng := FloatMod(GetAngle(true), 360);

  // Work out the max x value
  if (currAng <= 90) or ((currAng > 180) and (currAng <= 270)) then
    begin
      exit(X + Sin((currAng mod 90) * Pi() / 180) * ArrowTexture.Handle.width);
    end
  else
    begin
      exit(X + Sin((currAng mod 90) * Pi() / 180) * ArrowTexture.Handle.width + Cos((currAng mod 90) * Pi() / 180) * ArrowTexture.Handle.height);
    end;
end;

function TArrow.MinX() : float;
begin
  // Get the current angle (stops us running the same method over and over angin
  var currAng := FloatMod(GetAngle(true), 360);

  // Work out the min x value
  if (currAng <= 90) or ((currAng > 180) and (currAng <= 270)) then
    begin
      exit(X - Sin((currAng mod 90) * Pi() / 180) * ArrowTexture.Handle.height);
    end
  else
    begin
      exit(X);
    end;
end;

function TArrow.MaxY() : float;
begin
  // Get the current angle (stops us running the same method over and over angin
  var currAng := FloatMod(GetAngle(true), 360);

  // Work out the max y value
  if (currAng <= 90) or ((currAng > 180) and (currAng <= 270)) then
    begin
      exit(Y + Cos((currAng mod 90) * Pi() / 180) * ArrowTexture.Handle.height + Sin((currAng mod 90) * Pi() / 180) * ArrowTexture.Handle.width);
    end
  else
    begin
      exit(Y + Sin((currAng mod 90) * Pi() / 180) * ArrowTexture.Handle.height);
    end;
end;

function TArrow.MinY() : float;
begin
  // Get the current angle (stops us running the same method over and over angin
  var currAng := FloatMod(GetAngle(true), 360);

  // Work out the min y value
  if (currAng <= 90) or ((currAng > 180) and (currAng <= 270)) then
    begin
      exit(Y);
    end
  else
    begin
      exit(Y - Cos((currAng mod 90) * Pi() / 180) * ArrowTexture.Handle.width);
    end;
end;

end.
