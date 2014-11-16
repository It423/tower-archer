unit UTowerArcher;

interface

uses
  W3System, W3Components, W3Application, W3Game, W3GameApp, W3Graphics, W3Image,
  UMouseInputs, UArrow, UDrawing;

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

  // Add the mouse input handlers
  GameView.OnMouseDown := MouseDownHandler;
  GameView.OnMouseUp := MouseUpHandler;
  GameView.OnMouseMove := MouseMoveHandler;

  // Initialize refresh interval
  GameView.Delay := 100;

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
  // Clear background
  Canvas.FillStyle := 'rgb(255, 255, 255)';
  Canvas.FillRectF(0, 0, GameView.Width, GameView.Height);
end;

end.
