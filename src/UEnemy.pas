unit UEnemy;

interface

uses 
  W3System;

type TEnemy = class(TObject)
  public
    X, Y : float;
    Health, MaxHealth : integer;
    procedure Move(); virtual; abstract;
    function GetRect() : TRectF; virtual; abstract;
    procedure Hit(damage : integer); virtual; abstract;
end;
