unit UShop;

interface

uses 
  W3System,
  UShopItem, UShopData;

type Shop = class(TObject)
  public
    Items : array [0 .. 4] of TShopItem;
    constructor Create();
end;

implementation

constructor Shop.Create();
begin
  // TODO: load each shop item with texture and event handler
end;

end.
