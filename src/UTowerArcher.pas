unit UTowerArcher;

interface

uses
  W3System, W3Components, W3Application, W3Game, W3GameApp, W3Graphics,
  UMouseInputs;

type
  TApplication = class(TW3CustomGameApplication)
  private
    { Private fields and methods }
  protected
    procedure ApplicationStarting; override;
    procedure ApplicationClosing; override;
    procedure PaintView(Canvas: TW3Canvas); override;
  end;

implementation

{ TApplication }

procedure TApplication.ApplicationStarting;
begin
  inherited;
  // Add the mouse input handlers
  GameView.OnMouseDown := MouseDownHandler;
  GameView.OnMouseUp := MouseUpHandler;
  GameView.OnMouseMove := MouseMoveHandler;

  // Initialize refresh interval, set this to 1 for optimal speed
  GameView.Delay := 20;

  // Start the redraw-cycle with framecounter active
  GameView.StartSession(True);
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

  // Draw our framerate on the screen
  // Canvas.Font := '10pt verdana';
  // Canvas.FillStyle := 'rgb(255, 255, 255)';
  // Canvas.FillTextF('FPS:' + IntToStr(GameView.FrameRate), 10, 20, MAX_INT);
end;


end.
