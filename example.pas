program example;

{$mode objfpc}{$H+}

uses
  {$IfDef Unix}cthreads,{$EndIf}
  Classes, SysUtils, barrier;

type

  { TTestThread }

  TTestThread = class(TThread)
  private
    FBarr: PBarrier;
  protected
    procedure Execute; override;
  public
    constructor Create(barr: PBarrier);
  end;

{ TTestThread }

procedure TTestThread.Execute;
var
  i: Integer;
begin
  FBarr^.Enter;
  for i := 0 to 10 do
  begin
    WriteLn(i);
    Sleep(10);
  end;
end;

constructor TTestThread.Create(barr: PBarrier);
begin                     
  FBarr:=barr;
  inherited Create(False);
  FreeOnTerminate:=True;
end;

var
  barr: TBarrier;
begin
  barr.Initialize(3);
  TTestThread.Create(@barr);
  TTestThread.Create(@barr);
  WriteLn('Threads created');
  ReadLn;
  WriteLn('Entering barrier');
  barr.Enter;
  sleep(10);
  barr.Destroy;
  ReadLn;
end.

