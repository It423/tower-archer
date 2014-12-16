unit UGameVariables;

interface

uses 
  W3System;

const
  GRAVITY = 1.5;
  FLYING_SPEED_CHANGE = 0.1;
  FLYING_SPEED_MAX = 3;
  ARROW_FREEZE_DURATION_RANGE = 2000;

var
  PixelToPowerRatio : float;
  MaxPower : float;
  GameWidth, GameHeight : integer;
  ArrowDamage : integer;
  ArrowsFreeze : boolean;
  ArrowFreezeDuration : integer;
  TimeBetweenShots : integer;

// A function to perform moding operations on floats
function FloatMod(a, b : float) : integer;

implementation

function FloatMod(a, b : float) : integer;
begin
  exit(Trunc(a - b * Trunc(a / b)));
end;

end.