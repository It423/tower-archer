unit UShop;

interface

uses 
  W3System, W3Image, W3Graphics,
  UShopItem, UShopData;

type TShop = class(TObject)
  public
    Items : array [0 .. 4] of TShopItem;
    constructor Create();
    procedure Draw(canvas : TW3Canvas);
    procedure CheckClicked(xPos, yPos : integer);
end;

var
  Shop : TShop;

implementation

constructor TShop.Create();
begin
  // TODO: load each shop item with texture and event handler
end;

procedure TShop.Draw(canvas : TW3Canvas);
begin
  for var i := 0 to 4 do
    begin
      Items[i].Draw(canvas);
    end;
end;

procedure TShop.CheckClicked(xPos, yPos : integer);
begin
  for var i := 0 to High(Items) do
    begin
      // Perchase the item if it was clicked
      if Items[i].IsInButton(xPos, yPos) then
        begin
          Items[i].Purchase();
          break;
        end;
    end;
end;

end.
