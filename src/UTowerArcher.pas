unit UTowerArcher;

interface

uses
  W3System, W3Components, W3Application, W3Game, W3GameApp, W3Graphics, W3Image,
  UMouseInputs, UArrow, UArcher, UDrawing, UGameVariables, UGameItems, UPlayerData, UTextures, UGroundUnit, UAirUnit;

type
  TApplication = class(TW3CustomGameApplication)
  protected
    procedure ApplicationStarting; override;
    procedure ApplicationClosing; override;
    procedure PaintView(Canvas: TW3Canvas); override;
  end;

procedure InitializeVariables();
procedure DrawMouseDragLine(canvas : TW3Canvas);
procedure UpdateArrows(canvas : TW3Canvas);
procedure UpdateEnemies(canvas : TW3Canvas);
procedure EvaluateLoadedContent();

var
  ContentLoaded : boolean;
  Loaded : array of boolean;

implementation

procedure TApplication.ApplicationStarting;
begin
  inherited;
  // Initialize textures
  ArrowTexture := TW3Image.Create(nil);
  ArrowTexture.LoadFromURL("res\Arrow.png");
  BowTexture := TW3Image.Create(nil);
  BowTexture.LoadFromURL("res\Bow.png");
  ArcherTexture := TW3Image.Create(nil);
  ArcherTexture.LoadFromURL("res\Archer.png");
  GroundUnitTexture := TW3Image.Create(nil);
  GroundUnitTexture.LoadFromURL("res\GroundEnemy.png");
  FrozenGroundUnitTexture := TW3Image.Create(nil);
  FrozenGroundUnitTexture.LoadFromURL("res\GroundEnemyFrozen.png");
  AirUnitTexture := TW3Image.Create(nil);
  AirUnitTexture.LoadFromURL("res\AirEnemy.png");
  FrozenAirUnitTexture := TW3Image.Create(nil);
  FrozenAirUnitTexture.LoadFromURL("res\AirEnemyFrozen.png");

  // Tell the program the content has not loaded
  ContentLoaded := false;
  Loaded := [ false, false, false, false, false, false, false ];

  // Add the mouse input handlers
  GameView.OnMouseDown := MouseDownHandler;
  GameView.OnMouseUp := MouseUpHandler;
  GameView.OnMouseMove := MouseMoveHandler;

  // Initialize refresh interval
  GameView.Delay := 20;

  // Start the redraw-cycle with framecounter inactive
  GameView.StartSession(True);
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
  Canvas.FillStyle := "rgb(255, 255, 255)";
  Canvas.FillRectF(0, 0, GameView.Width, GameView.Height);

  if ContentLoaded then
    begin
      // Draw the mouse to origin line if prepearing to fire
      DrawMouseDragLine(Canvas);

      DrawArcher(Player, Canvas);

      UpdateArrows(Canvas);

      UpdateEnemies(Canvas);
    end
  else
    begin
      EvaluateLoadedContent();

      DrawLoadingScreen(Canvas);
    end;
end;

procedure InitializeVariables();
begin
  // Initialize the variables
  PixelToPowerRatio := 10;
  MaxPower := 30;

  // Initialize the player
  Player := TArcher.Create(200,100);
end;

procedure DrawMouseDragLine(canvas : TW3Canvas);
begin
  if MouseDown and Player.CanShoot then
    begin
      canvas.StrokeStyle := 'rgba(0, 0, 0, 0.5)';
      canvas.LineWidth := 0.3;
      canvas.BeginPath();
      canvas.MoveToF(MouseDownX, MouseDownY);
      canvas.LineToF(CurrentMouseX, CurrentMouseY);
      canvas.ClosePath();
      canvas.Stroke();
    end;
end;

procedure UpdateArrows(canvas : TW3Canvas);
begin
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
end;

procedure UpdateEnemies(canvas : TW3Canvas);
begin
  for var i := 0 to High(Enemies) do
    begin
      if (Enemies[i].Health > 0) then
        begin
          // Only move the enemy if its not frozen
          if not Enemies[i].Frozen then
            begin
              Enemies[i].Move();
            end;

          // Draw the enemy
          DrawEnemy(Enemies[i], canvas);
        end;
    end;
end;

procedure EvaluateLoadedContent();
begin
  // Check which content is loaded
  if ArrowTexture.Ready then
    begin
      Loaded[0] := true;
    end;

  if ArcherTexture.Ready then
    begin
      Loaded[1] := true;
    end;

  if BowTexture.Ready then
    begin
      Loaded[2] := true;
    end;

  if GroundUnitTexture.Ready then
    begin
      Loaded[3] := true;
    end;

  if FrozenGroundUnitTexture.Ready then
    begin
      Loaded[4] := true;
    end;

  if AirUnitTexture.Ready then
    begin
      Loaded[5] := true;
    end;

  if FrozenAirUnitTexture.Ready then
    begin
      Loaded[6] := true;
    end;

  // Evaluate if everything is loaded
  for var i := 0 to High(Loaded) do
    begin
      // Break the procedure if the content is not loaded
      if not Loaded[i] then
        begin
          exit;
        end;
    end;

  // If the procedure has not ended the content is fully loaded
  ContentLoaded := true;

  // Initialize variables now content has been loaded
  InitializeVariables()
end;

end.
