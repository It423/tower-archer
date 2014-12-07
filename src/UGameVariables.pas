unit UGameVariables;

interface

uses 
  W3System;

const
  GRAVITY = 1.5;
  ARROW_DAMAGE = 10;

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