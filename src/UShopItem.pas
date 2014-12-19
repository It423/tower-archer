unit UShopItem;

interface

uses 
  W3System, W3Image, W3Graphics,
  UShopData;

type TPurchasedEvent = procedure of object;

type TShopItem = class(TObject)
  public
    X, Y : integer;
    Price, UnitsSold, MaxUnitsSold : integer;
    PriceAfterPurchaseMultiplyer : float;
    ItemName : string;
    Thumbnail : TW3Image;
    constructor Create(newX, newY, newMaxUnitsToSell, newPrice : integer; newPriceAfterPurchaseMultiplyer : float; newName : string; newThumbnail : TW3Image; purchaseHandler : procedure);
    procedure Purchase();
    procedure Draw(canvas : TW3Canvas);
  private
    PurchaseEvent : TPurchasedEvent;
    property OnPurchase : TPurchasedEvent read PurchaseEvent write PurchaseEvent;
end;

implementation

constructor TShopItem.Create(newX, newY, newMaxUnitsToSell, newPrice : integer; newPriceAfterPurchaseMultiplyer : float; newName : string; newThumbnail : TW3Image; purchaseHandler : procedure);
begin
  X := newX;
  Y := newY;
  UnitsSold := 0;
  MaxUnitsSold := newMaxUnitsToSell;
  Price := newPrice;
  PriceAfterPurchaseMultiplyer := newPriceAfterPurchaseMultiplyer;
  ItemName := newName;
  Thumbnail := newThumbnail;
  OnPurchase := purchaseHandler;
end;

procedure TShopItem.Purchase();
begin
  // Only run the handler if the event has one
  if Assigned(PurchaseEvent) then
    begin
      // Check if its affordable or if more can be sold
      if (not MaxUnitsSold <= -1) and (UnitsSold >= MaxUnitsSold) then
        begin
          PurchaseMessage := "No more of this item can be purchased!";
        end
      else if Money < Price then
        begin
          PurchaseMessage := "You cannot afford that!";
        end
      else
        begin
          // If the item can be purchased...
          Inc(UnitsSold); // Increment the amount of units sold
          Money -= Price; // Take away the appropriate amount of money
          PurchaseEvent(); // Run the event handler
          PurchaseMessage := "Item purchased!"; // Tell the player the item has been brought

          // Increase the price by the price multiplyer
          Price := Round(Price * PriceAfterPurchaseMultiplyer);
        end;
    end
  else
    begin
      // If there is no event handler the item cannot be purchased
      PurchaseMessage := "This item cannot be purchased!";
    end;
end;

procedure TShopItem.Draw(canvas : TW3Canvas);
begin
  // TODO: Write draw function
end;


end.
