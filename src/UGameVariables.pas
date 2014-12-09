unit UGameVariables;

interface

uses 
  W3System;

const
  GRAVITY = 1.5;
  ARROW_DAMAGE = 10;
  FLYING_SPEED_CHANGE = 0.1;
  FLYING_SPEED_MAX = 3;
  TIME_BETWEEN_SHOTS = 2000;

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