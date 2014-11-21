unit UGameVariables;

interface

uses 
  W3System;

var
  PixelToPowerRatio : float;
  MaxPower : float;
  GameWidth, GameHeight : integer;

// A function to perform moding operations on floats
function FloatMod(a, b : float) : integer;

implementation

function FloatMod(a, b : float) : integer;
begin
  exit(Trunc(a - b * Trunc(a / b)));
end;

end.