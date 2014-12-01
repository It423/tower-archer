unit UTowerArcher;

interface

uses
  W3System, W3Components, W3Application, W3Game, W3GameApp, W3Graphics, W3Image,
  UMouseInputs, UArrow, UArcher, UDrawing, UGameVariables, UGameItems, UPlayerData, UTextures, UGroundUnit;

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
  GroundUnitTexture := TW3Image.Create(nil);
  GroundUnitTexture.LoadFromURL("res/GroundEnemy.png");

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


  // Initialize a few enemies
  Enemies[0] := TGroundUnit.Create(250, 250, 0, 5);
  Enemies[1] := TGroundUnit.Create(300, 300, 0, 5);
  Enemies[2] := TGroundUnit.Create(300, 500, 0, 5);
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
          // Get the current x and y positions for the collision engine
          var prevX := Arrows[i].X;
          var prevY := Arrows[i].Y;

          // Move the arrow
          Arrows[i].Move();

          // Check the collisions
          Arrows[i].CheckCollisions(Enemies, prevX, prevY);

          // Draw the active arrow
          DrawArrow(Arrows[i], canvas);
        end;
    end;

  // Update enemies
  for var i := 0 to High(Enemies) do
    begin
      if (Enemies[i].Health > 0) then
        begin
          // Move the enemy
          Enemies[i].Move();

          // Draw the enemy
          DrawEnemy(Enemies[i], Canvas);
        end;
    end;

  // Draw the player
  DrawArcher(Player, Canvas);
end;

end.
