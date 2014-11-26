unit UGroundUnit;

interface

uses 
  W3System, W3Image,
  UEnemy;

type TGroundUnit = class(TEnemy)
  public
    Speed : float;
    constructor Create(newX, newY, newSpeed : float; newHealth : integer);
    function GetRect() : TRectF; override;
    procedure Hit(damage : integer); override;
end;

var
  GroundUnitTexture : TW3Image;

implementation

constructor TGroundUnit.Create(newX, newY, newSpeed : float; newHealth : integer);
begin
  X := newX;
  Y := newY;
  Speed := newSpeed;
  Health := newHealth;
end;

function TGroundUnit.GetRect() : TRectF;
begin
  exit(TRectF.Create(X, Y, X + GroundUnitTexture.Handle.width, Y + GroundUnitTexture.Handle.height));
end;

procedure TGroundUnit.Hit(damage : integer);
begin
  Health -= damage;
end;

end.
