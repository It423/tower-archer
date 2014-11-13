unit TowerArcher;

interface

uses
  W3System, W3Components, W3Application, W3Game, W3GameApp, W3Graphics;

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

  // Initialize refresh interval, set this to 1 for optimal speed
  GameView.Delay := 20;

  // Start the redraw-cycle with framecounter active
  // Note: the framecounter impacts rendering speed. Disable
  // the framerate for maximum speed (false)
  GameView.StartSession(True);
end;

procedure TApplication.ApplicationClosing;
begin
  GameView.EndSession;
  inherited;
end;

// Note: In a real live game you would try to cache as much
// info as you can. Typical tricks are:
//   1: Only get the width/height when resized
//   2: Pre-calculate strings, especially RGB/RGBA values
//   3: Only redraw what has changed, avoid a full repaint
// The code below is just to get you started

procedure TApplication.PaintView(Canvas: TW3Canvas);
begin
  // Clear background
  Canvas.FillStyle := 'rgb(0, 0, 99)';
  Canvas.FillRectF(0, 0, GameView.Width, GameView.Height);

  // Draw our framerate on the screen
  Canvas.Font := '10pt verdana';
  Canvas.FillStyle := 'rgb(255, 255, 255)';
  Canvas.FillTextF('FPS:' + IntToStr(GameView.FrameRate), 10, 20, MAX_INT);
end;


end.
