unit USpawner;

interface

uses 
  W3System,
  UArrow, UGameVariables, UGameItems;

procedure SpawnArrow(power, angle, x, y : float);

implementation

procedure SpawnArrow(power, angle, x, y : float);
begin
  // Work out the x and y velocitys
  var xVol := Cos(angle) * power;
  var yVol := Sin(angle) * power;

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
