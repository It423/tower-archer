unit UArrow;

interface

uses 
  W3System, W3Image,
  UGameVariables, UEnemy;

type TArrow = class(TObject)
  public
    X, Y, XVol, YVol : float;
    Active : boolean;
    constructor Create(newX, newY, newXVol, newYVol : float);
    procedure Move();
    function GetAngle(deg : boolean = false) : float;
    function MaxX() : float;
    function MinX() : float;
    function MaxY() : float;
    function MinY() : float;
    function GetRect() : TRectF;
    function CheckCollisions(enemys : array of TEnemy; prevX, prevY : float) : array of TEnemy;

  private
    function CheckCollision(enemy : TEnemy; prevX, prevY : float) : boolean; overload;
end;

const
  GRAVITY = 1.5;
  DAMAGE = 10;

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
      exit(X + Cos((currAng mod 90) * Pi() / 180) * ArrowTexture.Handle.width);
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

function TArrow.GetRect() : TRectF;
begin
  exit(TRectF.Create(MinX(), MinY(), MaxX(), MaxY()));
end;

function TArrow.CheckCollisions(enemys : array of TEnemy; prevX, prevY : float) : array of TEnemy;
var
  pathRect : TRectF; // The rectangle of which the arrow has moved
  intersection : TRectF; // The intersection between objects
begin
  // Get the path rectangle
  pathRect := TRectF.Create(prevX, prevY, MaxX(), MaxY());

  // Check over each enemy
  for var i := 0 to High(enemys) do
    begin
      // If the enemy was in the flight path of the arrow perform more detailed analysis
      if pathRect.Intersect(enemys[i].GetRect(), intersection) then
        begin
          if CheckCollision(enemys[i], prevX, prevY) then
            begin
              // If the arrow did actually hit the enemy run the hit procedure on it and exit the loop
              enemys[i].Hit(DAMAGE);
              break;
            end;
        end;
    end;

  // Return back the list of enemys which could have been altered
  exit(enemys);
end;

function TArrow.CheckCollision(enemy : TEnemy; prevX, prevY : float) : boolean;
var
  distance : integer; // The distance the arrow traveled
  xChangePerLoop, yChangePerLoop : float; // How much to move the arrow per test
  testArrow : TArrow; // The arrow to test with
  intersection : TRectF; // The intersection between objects
begin
  // Get the distance the arrow has traveled
  distance := Ceil(Sqrt(Sqr(MaxX() - prevX) + Sqr(MaxY - prevY)));

  // Use the distance as the divider
  xChangePerLoop := (MaxX() - prevX) / distance;
  yChangePerLoop := (MaxY() - prevY) / distance;

  // Create an arrow in the original position with the previous velocity
  testArrow := TArrow.Create(prevX, prevY, XVol, YVol - GRAVITY);

  // Move the arrow in small steps to see if it hits the enemy
  for var i := 0 to distance do
    begin
      // Test to see if it has collided
      if testArrow.GetRect().Intersect(enemy.GetRect(), intersection) then
        begin
          exit(true);
        end
      else
        begin
          // If it did not move the arrow by a small amout
          testArrow.X += xChangePerLoop;
          testArrow.Y += yChangePerLoop;
        end
    end;

  // If the arrow did not in fact hit return false
  exit(false);
end;

end.
