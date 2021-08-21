unit barrier;

{$mode objfpc}{$H+}

interface

uses
  SysUtils
  {$IfDef WINDOWS}, win_barrier, windows{$EndIf};

type

  { ESystemError }
  TErrorCode = {$IfDef WINDOWS}DWORD{$EndIf};

  ESystemError = class(Exception)
  private
    FErrorCode: TErrorCode;
  public
    constructor Create(const msg: string; const code: TErrorCode);

    property Code: TErrorCode read FErrorCode;
  end;

  { TBarrier }

  TBarrier = object
  private
    FBarrier: {$IfDef WINDOWS}TSYNCHRONIZATION_BARRIER{$EndIf};
  public
    procedure Enter;

    constructor Initialize(NumThreads: Integer);
    destructor Destroy;
  end;
  PBarrier = ^TBarrier;

implementation

{ ESystemError }

constructor ESystemError.Create(const msg: string; const code: TErrorCode);
begin
  FErrorCode:=code;
end;

{ TBarrier }

procedure TBarrier.Enter;
begin
  {$IfDef WINDOWS}
  EnterSynchronizationBarrier(@FBarrier, 0);
  {$EndIf}
end;

constructor TBarrier.Initialize(NumThreads: Integer);
begin
  {$IfDef WINDOWS}
  if not InitializeSynchronizationBarrier(@FBarrier, NumThreads, -1) then
    raise ESystemError.Create('Error calling InitializeSynchronizationBarrier', GetLastError);
  {$EndIf}
end;

destructor TBarrier.Destroy;
begin
  {$IfDef WINDOWS}
  if not DeleteSynchronizationBarrier(@FBarrier) then
    raise ESystemError.Create('Error calling DeleteSynchronizationBarrier', GetLastError);
  {$EndIf}
end;

end.

