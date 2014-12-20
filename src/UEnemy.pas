unit UEnemy;

interface

uses 
  W3System, W3Time;

type TEnemy = class(TObject)
  public
    X, Y : float;
    Health, MaxHealth : integer;
    Frozen : boolean;
    procedure Move(); virtual; abstract;
    function GetRect() : TRectF; virtual; abstract;
    procedure Hit(damage : integer; xArrowSpeed, yArrowSpeed : float);
    procedure Freeze(minDuration, maxDuration : integer);
    procedure PauseTimer();
    procedure ResumeTimer();
  private
    Timer : TW3EventRepeater; // Timer for being frozen
    DelayHolder : integer;
    function HandleTimer(sender : TObject) : boolean;
end;

implementation

procedure TEnemy.Hit(damage : integer; xArrowSpeed, yArrowSpeed : float);
begin
  // Times the speed of the arrow by the damage multiplyer
  var damageWithSpeed := damage * Sqrt(Sqr(xArrowSpeed) + Sqr(yArrowSpeed));

  // Take the damage from the health
  Health -= Round(damageWithSpeed);
end;

procedure TEnemy.Freeze(minDuration, maxDuration : integer);
var
  duration : integer;
begin
  // Get a random duration from the range
  duration := RandomInt(maxDuration - minDuration) + minDuration;

  // Tell the enemy that it is frozen
  Frozen := true;

  // Set the timer
  Timer := TW3EventRepeater.Create(HandleTimer, duration);
end;

procedure TEnemy.PauseTimer();
begin
  // Store the delay then destroy the timer
  DelayHolder := Timer.Delay;
  Timer.Destroy();
end;

procedure TEnemy.ResumeTimer();
begin
  // Start the timer then reset the delay holder
  Timer := TW3EventRepeater.Create(HandleTimer, DelayHolder);
  DelayHolder := 0;
end;

function TEnemy.HandleTimer(sender : TObject) : boolean;
begin
  Frozen := false;
  TW3EventRepeater(sender).Free();
  exit(true);
end;

end.