unit UEnemy;

interface

uses 
  W3System;

type TEnemy = class(TObject)
  public
    X, Y : float;
    Health, MaxHealth : integer;
    procedure Move(); virtual; abstract;
    function GetRect() : TRectF; virtual; abstract;
    procedure Hit(damage : integer; xArrowSpeed, yArrowSpeed : float);
end;

implementation

procedure TEnemy.Hit(damage : integer; xArrowSpeed, yArrowSpeed : float);
begin
  // Times the speed of the arrow by the damage multiplyer
  var damageWithSpeed := damage * Sqrt(Sqr(xArrowSpeed) + Sqr(yArrowSpeed));

  // Take the damage from the health
  Health -= Round(damageWithSpeed);
end;
