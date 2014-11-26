unit UTowerArcher;

interface

uses
  W3System, W3Components, W3Application, W3Game, W3GameApp, W3Graphics, W3Image,
  UMouseInputs, UArrow, UArcher, UDrawing, UGameVariables, UGameItems, UPlayerData;

type
  TApplication = class(TW3CustomGameApplication)
  protected
    procedure ApplicationStarting; override;
    procedure ApplicationClosing; override;
    procedure PaintView(Canvas: TW3Canvas); override;
  end;

implementation

procedure TApplication.ApplicationStarting;
begin
  inherited;
  // Initialize textures
  ArrowTexture := TW3Image.Create(nil);
  ArrowTexture.LoadFromURL("res/Arrow.png");
  BowTexture := TW3Image.Create(nil);
  BowTexture.LoadFromURL("res/Bow.png");

  // Initialize the variables
  PixelToPowerRatio := 10;
  MaxPower := 30;

  // Initialize the player
  Player := TArcher.Create(200,100);

  // Add the mouse input handlers
  GameView.OnMouseDown := MouseDownHandler;
  GameView.OnMouseUp := MouseUpHandler;
  GameView.OnMouseMove := MouseMoveHandler;

  // Initialize refresh interval
  GameView.Delay := 1;

  // Start the redraw-cycle with framecounter inactive
  GameView.StartSession(False);
end;

procedure TApplication.ApplicationClosing;
begin
  GameView.EndSession;
  inherited;
end;

procedure TApplication.PaintView(Canvas: TW3Canvas);
begin
  // Update the game width and height
  GameWidth := GameView.Width;
  GameHeight := GameView.Height;

  // Clear background
  Canvas.FillStyle := 'rgb(255, 255, 255)';
  Canvas.FillRectF(0, 0, GameView.Width, GameView.Height);

  // Update arrows
  for var i := 0 to High(Arrows) do
    begin
      if (Arrows[i].Active) then
        begin
          Arrows[i].Move();
        end;
    end;

  // Draw game items
  DrawArrow(Arrows, Canvas);
  DrawArcher(Player, Canvas);
end;

end.
