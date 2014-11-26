unit USpawner;

interface

uses 
  W3System,
  UArrow, UGameVariables, UGameItems;

procedure SpawnArrow(xVol, yVol, x, y : float);

implementation

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

end.
