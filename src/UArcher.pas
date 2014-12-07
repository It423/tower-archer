unit UArcher;

interface

uses 
  W3System,
  UGameVariables, USpawner, UArrow, UTextures;

type TArcher = class(TObject)
  public
    X, Y : float;
    XVol, YVol : float; // The predicted x and y velocities of shots
    constructor Create(newX, newY : float);
    procedure UpdateInformation(origX, origY, currX, currY : float);
    procedure Fire();
    function ArrowSpawnPoint() : array [0 .. 1] of float;
    function Angle() : float;
    function Power() : float;
end;

implementation

constructor TArcher.Create(newX, newY : float);
begin
  X := newX;
  Y := newY;
end;

procedure TArcher.UpdateInformation(origX, origY, currX, currY : float);
begin
  // Work out the x and y velocitys
  XVol := (origX - currX) / PixelToPowerRatio;
  YVol := (origY - currY) / PixelToPowerRatio;
end;

procedure TArcher.Fire();
begin
  SpawnArrow(XVol, YVol, ArrowSpawnPoint()[0], ArrowSpawnPoint()[1]);

  XVol := 0;
  YVol := 0;
end;

function TArcher.ArrowSpawnPoint() : array [0 .. 1] of float;
var
  xPoint, yPoint : float;
begin
  // Get the x and y points using trigonometry
  xPoint := X + ArcherTexture.Handle.width / 2 + Cos(Angle()) * BowTexture.Handle.width;
  yPoint := Y + ArcherTexture.Handle.height / 3 + Sin(Angle()) * BowTexture.Handle.width;

  exit([xPoint, yPoint]);
end;

function TArcher.Angle() : float;
begin
  exit(ArcTan2(YVol, XVol));
end;

function TArcher.Power() : float;
var
  retVal : float;
begin
  // Get the power
  retVal := Sqrt(Sqr(XVol) + Sqr(YVol));

  // Return max power if above max power, otherwise return the calculated power
  if retVal > MaxPower then
    begin
      exit(MaxPower);
    end
  else
    begin
      exit(retVal);
    end;
end;

end.
