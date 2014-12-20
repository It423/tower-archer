unit UShopItem;

interface

uses 
  W3System, W3Image, W3Graphics,
  UShopData;

type TPurchasedEvent = procedure();

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
    function IsInButton(xPos, yPos : integer) : boolean;
  private
    PurchaseEvent : TPurchasedEvent;
    property OnPurchase : TPurchasedEvent read PurchaseEvent write PurchaseEvent;
end;

const
  SHOP_WIDTH = 360;

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
  // Draw the background rectangle
  canvas.FillStyle := "rgb(110, 0, 0)";
  canvas.FillRect(X, Y, SHOP_WIDTH, Thumbnail.Handle.height + 6);

  // Draw item icon
  canvas.DrawImageF(Thumbnail.Handle, X + 3, Y + 3);

  // Draw the label and price
  canvas.FillStyle := "rgb(0, 0, 0)";
  canvas.Font := "18pt verdana";
  canvas.TextAlign := "left";
  canvas.TextBaseLine := "middle";
  canvas.FillTextF(ItemName, X + 6 + Thumbnail.Handle.width, Y + 6 + Thumbnail.Handle.height / 2, 150);
  canvas.TextAlign := "right";
  canvas.FillText("£" + IntToStr(Price), X + SHOP_WIDTH - 76, Y + 6 + Thumbnail.Handle.height / 2, 60);

  // Draw the button
  canvas.StrokeStyle := "rgb(0, 0, 0)";
  canvas.LineWidth := 3;
  canvas.FillStyle := "rgb(130, 120, 140)";
  canvas.StrokeRectF(X + SHOP_WIDTH - 73, Y + 3, 70, Thumbnail.Handle.height);
  canvas.FillRectF(X + SHOP_WIDTH - 73, Y + 3, 70, Thumbnail.Handle.height);

  // Draw the text inside the button
  canvas.FillStyle := "rgb(0, 0, 0)";
  canvas.Font := "24pt verdana";
  canvas.TextAlign := "center";
  canvas.TextBaseLine := "middle";
  canvas.FillTextF("Purchase", X + SHOP_WIDTH - 38, Y + 3 + Thumbnail.Handle.height / 2, 60);

  // Put a line throught the item if no more can be brought
  if (not MaxUnitsSold <= -1) and (UnitsSold >= MaxUnitsSold) then
    begin
      canvas.StrokeStyle := "rgb(0, 0, 0)";
      canvas.LineWidth := 10;
      canvas.BeginPath();
      canvas.MoveToF(X - 10, Y + 3 + Thumbnail.Handle.height / 2);
      canvas.LineToF(X + SHOP_WIDTH + 10, Y + 3 + Thumbnail.Handle.height / 2);
      canvas.ClosePath();
      canvas.Stroke();
    end;
end;

function TShopItem.IsInButton(xPos, yPos : integer) : boolean;
var
  buttonRect : TRectF;
begin
  // Make the button a TRect
  buttonRect := TRectF.Create(X + SHOP_WIDTH - 73, Y + 3, X + SHOP_WIDTH - 3, Y + 3 + Thumbnail.Handle.height);

  // Return if the point is in the button
  exit(buttonRect.ContainsPoint(TPointF.Create(xPos, yPos)))
end;

end.
