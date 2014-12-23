unit UEnemy;

interface

uses 
  W3System, W3Time,
  UGameVariables;

type ECrossedTowerEvent = procedure();

type TEnemy = class(TObject)
  public
    X, Y : float;
    Health, MaxHealth : integer;
    Frozen : boolean;
    procedure Move(); virtual;
    function GetRect() : TRectF; virtual; abstract;
    procedure Hit(damage : integer; xArrowSpeed, yArrowSpeed : float);
    procedure Freeze(minDuration, maxDuration : integer);
    procedure PauseTimer();
    procedure ResumeTimer();
  protected
    Timer : TW3EventRepeater; // Timer for being frozen
    DelayHolder : integer;
    HasCrossedTower : boolean; // Wether the enemy has taken a life from the player by crossing the tower
    CrossedTowerEvent : ECrossedTowerEvent; // The event
    property OnPurchase : ECrossedTowerEvent read CrossedTowerEvent write CrossedTowerEvent; // The event handler
    procedure CrossedTower();
    procedure ApplyToEventHadler();
    function HandleTimer(sender : TObject) : boolean;
end;

procedure CrossedTowerEventHandler();

implementation

procedure TEnemy.Move();
begin
  if X < 0 then
    begin
      if not HasCrossedTower then
        begin
          CrossedTower();
        end
      else
        begin
          if X < -300 then
            begin
              Health := 0; // Kill the enemy if its gone far beyond the end of the screen
            end;
        end;
    end;
end;

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

procedure TEnemy.CrossedTower();
begin
  // Only run the handler if the event has one
  if Assigned(CrossedTowerEvent) then
    begin
      CrossedTowerEvent();
      HasCrossedTower := true;
    end;
end;

procedure TEnemy.ApplyToEventHadler();
begin
  CrossedTowerEvent := CrossedTowerEventHandler;
end;

function TEnemy.HandleTimer(sender : TObject) : boolean;
begin
  Frozen := false;
  TW3EventRepeater(sender).Free();
  exit(true);
end;

procedure CrossedTowerEventHandler();
begin
  Dec(Lives)
end;

end.