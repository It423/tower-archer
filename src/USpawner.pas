unit USpawner;

interface

uses 
  W3System,
  UArrow, UGameVariables, UGameItems;

procedure SpawnArrow(origX, origY, endX, endY : float);

implementation

procedure SpawnArrow(origX, origY, endX, endY : float);
begin
  // Work out the x and y velocitys
  var xVol := (origX - endX) / PixelToPowerRatio;
  var yVol := (origY - endY) / PixelToPowerRatio;

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
          Arrows[i] := TArrow.Create(ArrowSpawnX, ArrowSpawnY, xVol, yVol);
          exit;
        end;
    end;

  // Spawn an arrow if an inactive one wasn't found
  Arrows[High(Arrows) + 1] := TArrow.Create(ArrowSpawnX, ArrowSpawnY, xVol, yVol);
end;

end.
