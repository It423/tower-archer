unit USpawner;

interface

uses 
  W3System, W3Time,
  UArrow, UGroundUnit, UAirUnit, UGameVariables, UGameItems, UScalingInfo, UTextures;

procedure SpawnArrow(xVol, yVol, x, y : float);
procedure StartEnemySpawners();
procedure PauseEnemySpawners();
function SpawnGroundEnemy(sender : TObject) : boolean;
function SpawnAirEnemy(sender : TObject) : boolean;
function GetNextEnemyIndex() : integer;

var
  GroundTimer, AirTimer : TW3EventRepeater; // Timers for enemy spawn
  GroundDelay, AirDelay, GroundDelayHolder, AirDelayHolder : integer; // Dealys and delay holders for the timers
  Difficulty : integer; // The difficulty level

implementation

procedure StartGroundTimer(delay : integer);
begin
  GroundTimer := TW3EventRepeater.Create(SpawnGroundEnemy, delay);
end;

procedure StartAirTimer(delay : integer);
begin
  AirTimer := TW3EventRepeater.Create(SpawnAirEnemy, delay);
end;

procedure SpawnArrow(xVol, yVol, x, y : float);
begin
  // Change the x and y velocity if they exceed the max power
  if (Sqrt(Sqr(xVol) + Sqr(yVol)) > MaxPower) then
    begin
      // Work out the angle
      var ang := ArcTan2(yVol, xVol);

      // Change the velocites to match the angle at max power
      xVol := Cos(ang) * MaxPower;
      yVol := Sin(ang) * MaxPower;
    end;

  for var i := 0 to High(Arrows) do
    begin
      // If the arrow is inactive spawn one at this index
      if not Arrows[i].Active then
        begin
          Arrows[i] := TArrow.Create(x, y, xVol, yVol);
          exit;
        end;
    end;

  // Spawn an arrow if an inactive one wasn't found
  Arrows[High(Arrows) + 1] := TArrow.Create(x, y, xVol, yVol);
end;

procedure StartEnemySpawners();
begin
  // Start the ground timer
  if GroundDelayHolder <= 0 then
    begin
      StartGroundTimer(GroundDelay);
    end
  else
    begin
      StartGroundTimer(GroundDelayHolder);
    end;

  // Start the air timer
  if AirDelayHolder <= 0 then
    begin
      StartAirTimer(AirDelay);
    end
  else
    begin
      StartAirTimer(AirDelayHolder);
    end;

  // Clear delay holders
  GroundDelayHolder := 0;
  AirDelayHolder := 0;
end;

procedure PauseEnemySpawners();
begin
  // Record the delays
  GroundDelayHolder := GroundTimer.Delay;
  AirDelayHolder := AirTimer.Delay;

  // Destroy the timers
  GroundTimer.Destroy();
  AirTimer.Destroy();
end;

function SpawnGroundEnemy(sender : TObject) : boolean;
begin
  Enemies[GetNextEnemyIndex()] := TGroundUnit.Create(GAMEWIDTH, GAMEHEIGHT - GroundUnitTexture.Handle.height, 1, 1000, 50);

  // Release the timer then restart it
  TW3EventRepeater(sender).Free();
  StartGroundTimer(GroundDelay);
  exit(true);
end;

function SpawnAirEnemy(sender : TObject) : boolean;
begin
  Enemies[GetNextEnemyIndex()] := TAirUnit.Create(GAMEWIDTH, GAMEHEIGHT / 2, 1, 100, 1000, 50);

  // Release the timer then restart it
  TW3EventRepeater(sender).Free();
  StartAirTimer(AirDelay);
  exit(true);
end;

function GetNextEnemyIndex() : integer;
begin
  // Check for dead enemies
  for var i := 0 to High(Enemies) do
    begin
      if Enemies[i].Dead then
        begin
          exit(i); // Return the first index of a dead enemy
        end;
    end;

  // If no dead enemies were found create a new index
  exit(Length(Enemies));
end;

end.
