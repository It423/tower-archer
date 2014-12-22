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
  Paused : boolean;
  ArrowDamage : integer;
  ArrowsFreeze : boolean;
  ArrowFreezeDuration : integer;
  TimeBetweenShots : integer;
  PauseButtonCoordinates : array [0 .. 3] of integer;

// A function to perform moding operations on floats
function FloatMod(a, b : float) : integer;
function PauseButtonRect() : TRect;

implementation

function FloatMod(a, b : float) : integer;
begin
  exit(Trunc(a - b * Trunc(a / b)));
end;

function PauseButtonRect() : TRect;
begin
  exit(TRect.Create(PauseButtonCoordinates[0], PauseButtonCoordinates[1], PauseButtonCoordinates[2], PauseButtonCoordinates[3]));
end;

end.