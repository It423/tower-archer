unit UPlayer;

interface

uses 
  W3System,
  UArcher;

type TPlayer = class(TArcher)
  public
    ExtraArchers : array of TArcher;
    procedure UpdateInformation(origX, origY, currX, currY : float); override;
    procedure Fire(); override;
end;

implementation

procedure TPlayer.UpdateInformation(origX, origY, currX, currY : float);
begin
  inherited(origX, origY, currX, currY);

  // Update information for the extra archers
  for var i := 0 to High(ExtraArchers) do
    begin
      ExtraArchers[i].UpdateInformation(origX, origY, currX, currY);
    end;
end;

procedure TPlayer.Fire();
begin
  inherited();

  // Make extra archers also fire
  for var i := 0 to High(ExtraArchers) do
    begin
      ExtraArchers[i].Fire();
    end;
end;

end.
