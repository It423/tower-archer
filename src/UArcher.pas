unit UArcher;

interface

uses 
  W3System, W3Image,
  UGameVariables, USpawner;

type TArcher = class(TObject)
  Power, Angle : float;
  X, Y : float;
  ArrowSpawnX, ArrowSpawnY : float;
  constructor Create(newX, newY : float);
  procedure UpdateInformation(origX, origY, currX, currY : float);
  procedure Fire();
end;

var
  BowTexture : TW3Image;

implementation

constructor TArcher.Create(newX, newY : float);
begin
  Power := 0;
  Angle := 0;
  X := newX;
  Y := newY;
  ArrowSpawnX := X + BowTexture.Handle.width;
  ArrowSpawnY := Y + BowTexture.Handle.height / 2;
end;

procedure TArcher.UpdateInformation(origX, origY, currX, currY : float);
begin
  // Work out the x and y velocitys
  var xVol := (origX - currX) / PixelToPowerRatio;
  var yVol := (origY - currY) / PixelToPowerRatio;

  // Change the x and y velocity if they exceed the max power
  if (Sqrt(Sqr(xVol) + Sqr(yVol)) > MaxPower) then
    begin
      // Work out the angle
      var ang := ArcTan2(yVol, xVol);

      // Change the velocites to match the angle at max power
      xVol := Cos(ang) * MaxPower;
      yVol := Sin(ang) * MaxPower;
    end;

  // Get the power and angle from the velocities
  Angle := Tan((yVol * -1) / (xVol * -1));
  Power := Sqrt(Sqr(xVol) + Sqr(yVol));

  // Make the power negative (to the left) if its meant to shoot left
  if (xVol < 0) then
    begin
      Power := -Power;
    end;
end;

procedure TArcher.Fire();
begin
  SpawnArrow(Power, Angle, ArrowSpawnX, ArrowSpawnY);

  // Reset the power
  Power := 0;
end;

end.
