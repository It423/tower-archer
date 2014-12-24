unit UArrow;

interface

uses 
  W3System,
  UEnemy, UGameVariables, UTextures, UScalingInfo;

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
    procedure CheckCollisions(enemies : array of TEnemy; prevX, prevY : float);

  private
    function CheckCollision(enemy : TEnemy; prevX, prevY : float) : boolean; overload;
end;

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

  // Make the bullet inactive if off screen
  if (MaxX() < 0) or (MinX() > GAMEWIDTH) or (MinY() > GAMEHEIGHT) then
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
  // Get the current angle (stops us running the same method over and over again)
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
  // Get the current angle (stops us running the same method over and over again)
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
  // Get the current angle (stops us running the same method over and over again)
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
  // Get the current angle (stops us running the same method over and over again)
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

procedure TArrow.CheckCollisions(enemies : array of TEnemy; prevX, prevY : float);
var
  pathRect : TRectF; // The rectangle of which the arrow has moved
  intersection : TRectF; // The intersection between objects
begin
  // Get the path rectangle
  pathRect := TRectF.Create(prevX, prevY, MaxX(), MaxY());

  // Check over each enemy
  for var i := 0 to High(enemies) do
    begin
      // Only check enemies that are active with health
      if enemies[i].Health > 0 then
        begin
          // If the enemy was in the flight path of the arrow perform more detailed analysis
          if pathRect.Intersect(enemies[i].GetRect(), intersection) then
            begin
              if CheckCollision(enemies[i], prevX, prevY) then
                begin
                  // If the arrow did actually hit the enemy run the hit procedure on it and exit the loop
                  enemies[i].Hit(ArrowDamage, XVol, YVol);

                  // Freeze the enemy if the arrows freeze enemies
                  if ArrowsFreeze then
                    begin
                      enemies[i].Freeze(ArrowFreezeDuration, ArrowFreezeDuration + ARROW_FREEZE_DURATION_RANGE);
                    end;

                  // Tell the arrow it is inactive now
                  Active := false;
                  break;
                end;
            end;
        end;
    end;
end;

function TArrow.CheckCollision(enemy : TEnemy; prevX, prevY : float) : boolean;
var
  distance : integer;
  arrowsInDistance : integer;
  xChangePerLoop, yChangePerLoop : float;
  testArrow : TArrow;
  intersection : TRectF; // The intersection between objects
begin
  // Get the distance the arrow has traveled
  distance := Ceil(Sqrt(Sqr(MaxX() - prevX) + Sqr(MaxY - prevY)));

  // Get how many arrows fit in the distance (add 1 so it does at least 2 arrows)
  arrowsInDistance := Ceil(distance / ArrowTexture.Handle.width) + 1;

  // Use the distance as the divider
  xChangePerLoop := (MaxX() - prevX) / arrowsInDistance;
  yChangePerLoop := (MaxY() - prevY) / arrowsInDistance;

  // Create an arrow in the original position with the previous velocity
  testArrow := TArrow.Create(prevX, prevY, XVol, YVol - GRAVITY);

  // Move the arrow in small steps to see if it hits the enemy
  for var i := 0 to arrowsInDistance do
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
