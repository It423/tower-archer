unit UShopData;

interface

uses 
  W3System,
  UGameVariables, UPlayerData, UTextures;

var
  Money : integer;
  PurchaseMessage : string;

// Purchase event handlers for shop items
procedure AddArcher();
procedure IncreaseDamage();
procedure IncreaseRange();
procedure DecreaseReload();
procedure IncreaseIce();

implementation

procedure AddArcher();
begin
  // TODO: Spawn new archer for player
end;

procedure IncreaseDamage();
begin
  ArrowDamage += 10;
end;

procedure IncreaseRange();
begin
  MaxPower += 2;
end;

procedure DecreaseReload();
begin
  TimeBetweenShots -= 200;
end;

procedure IncreaseIce();
begin
  ArrowsFreeze := true;
  ArrowFreezeDuration += 500;
end;

end.
