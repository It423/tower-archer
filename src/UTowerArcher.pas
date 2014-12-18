unit UTowerArcher;

interface

uses
  W3System, W3Components, W3Application, W3Game, W3GameApp, W3Graphics, W3Image,
  UMouseInputs, UArrow, UArcher, UPlayer, UDrawing, UGameVariables, UGameItems, UPlayerData, UTextures, UGroundUnit, UAirUnit;
type
  TApplication = class(TW3CustomGameApplication)
  protected
    procedure ApplicationStarting; override;
    procedure ApplicationClosing; override;
    procedure PaintView(Canvas: TW3Canvas); override;
  end;

procedure InitializeVariables();
procedure DrawMouseDragLine(canvas : TW3Canvas);
procedure DrawCanShoot(canvas : TW3Canvas);
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
  TowerTexture := TW3Image.Create(nil);
  TowerTexture.LoadFromURL("res\Tower.png");

  // Tell the program the content has not loaded
  ContentLoaded := false;
  Loaded := [ false, false, false, false, false, false, false, false ];

  // Add event handlers so loaded content is registered
  ArrowTexture.OnLoad := procedure(o : TObject) begin Loaded[0] := true; end;
  BowTexture.OnLoad := procedure(o : TObject) begin Loaded[1] := true; end;
  ArcherTexture.OnLoad := procedure(o : TObject) begin Loaded[2] := true; end;
  GroundUnitTexture.OnLoad := procedure(o : TObject) begin Loaded[3] := true; end;
  FrozenGroundUnitTexture.OnLoad := procedure(o : TObject) begin Loaded[4] := true; end;
  AirUnitTexture.OnLoad := procedure(o : TObject) begin Loaded[5] := true; end;
  FrozenAirUnitTexture.OnLoad := procedure(o : TObject) begin Loaded[6] := true; end;
  TowerTexture.OnLoad := procedure(o : TObject) begin Loaded[7] := true; end;

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
  // Update the game width and height variables
  GameWidth := GameView.Width;
  GameHeight := GameView.Height;

  // Clear background
  Canvas.FillStyle := "rgb(255, 255, 255)";
  Canvas.FillRectF(0, 0, GameView.Width, GameView.Height);

  if ContentLoaded then
    begin
      DrawScenery(Canvas);

      // Draw the mouse to origin line if prepearing to fire
      DrawMouseDragLine(Canvas);

      // Draw a cirlce over the mouse showing if the player can shoot
      DrawCanShoot(Canvas);

      DrawPlayer(Player, Canvas);

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
  ArrowDamage := 10;
  TimeBetweenShots := 2000;

  // Initialize the player
  Player := TPlayer.Create(TowerTexture.Handle.width - 15 - ArcherTexture.Handle.width, GameHeight - TowerTexture.Handle.height - ArcherTexture.Handle.height);
end;

procedure DrawMouseDragLine(canvas : TW3Canvas);
begin
  if MouseDown and Player.CanShoot then
    begin
      canvas.StrokeStyle := "rgba(0, 0, 0, 0.5)";
      canvas.LineWidth := 0.3;
      canvas.BeginPath();
      canvas.MoveToF(MouseDownX, MouseDownY);
      canvas.LineToF(CurrentMouseX, CurrentMouseY);
      canvas.ClosePath();
      canvas.Stroke();
    end;
end;

procedure DrawCanShoot(canvas : TW3Canvas);
begin
  // Get red (can't shoot) or green (can shoot) fillers
  if Player.CanShoot then
    begin
      canvas.FillStyle := "rgba(0, 200, 0, 0.5)";
    end
  else
    begin
      canvas.FillStyle := "rgba(200, 0, 0, 0.5)";
    end;

  // Draw a circle around the mouse
  canvas.Ellipse(CurrentMouseX - 7, CurrentMouseY - 7, CurrentMouseX + 7, CurrentMouseY + 7);
  canvas.Fill();
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
