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
end;

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

end.
