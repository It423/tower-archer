unit UArcher;

interface

uses 
  W3System, W3Image,
  UGameVariables, USpawner, UArrow;

type TArcher = class(TObject)
  public
    X, Y : float;
    XVol, YVol : float; // The predicted x and y velocities of shots
    constructor Create(newX, newY : float);
    procedure UpdateInformation(origX, origY, currX, currY : float);
    procedure Fire();
    function GetSpawnPoint() : array [0 .. 1] of float;
//  function GetAngle() : float;
//  function GetPower() : float;
end;

var
  BowTexture : TW3Image;

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
  SpawnArrow(XVol, YVol, GetSpawnPoint()[0], GetSpawnPoint()[1]);

  XVol := 0;
  YVol := 0;
end;

function TArcher.GetSpawnPoint() : array [0 .. 1] of float;
begin
  // Get x and y points
  var yPoint := Y + BowTexture.Handle.height / 2;
  var xPoint := X + BowTexture.Handle.width;

  if XVol < 0 then
    begin
      xPoint := X - BowTexture.Handle.width;
    end;

  exit([xPoint, yPoint]);
end;

//function TArcher.GetAngle() : float;
//begin
//  if XVol < 0 then
//    begin
//      exit(Tan((YVol) / XVol));
//    end
//  else
//    begin
//      exit(Tan((YVol * -1) / (XVol * -1)));
//    end;
//end;

//function TArcher.GetPower() : float;
//begin
//
//end;

end.
