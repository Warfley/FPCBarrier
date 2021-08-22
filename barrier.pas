unit barrier;

{$mode objfpc}{$H+}

interface

uses
  SysUtils
  {$If defined(WINDOWS)}, win_barrier, windows
  {$ElseIf defined(UNIX)}, pthreads{$EndIf};

type

  { ESystemError }
  TErrorCode = {$If defined(WINDOWS)}DWORD{$ElseIf defined(UNIX)}Integer{$EndIf};

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
    FBarrier: {$If defined(WINDOWS)}TSYNCHRONIZATION_BARRIER{$ElseIf defined(UNIX)}pthread_barrier_t{$EndIf};
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
{$IfDef UNIX}
var
  ret: Integer;
{$EndIf}
begin
  {$If defined(WINDOWS)}
  EnterSynchronizationBarrier(@FBarrier, 0);
  {$ElseIf defined(UNIX)}
  ret := pthread_barrier_wait(@FBarrier);
  if (ret <> 0) and (ret <> PTHREAD_BARRIER_SERIAL_THREAD) then
    raise ESystemError.Create('Error calling pthread_barrier_wait', ret);
  {$EndIf}
end;

constructor TBarrier.Initialize(NumThreads: Integer);
{$IfDef UNIX}
var
  ret: cint;
{$EndIf}
begin
  {$If defined(WINDOWS)}
  if not InitializeSynchronizationBarrier(@FBarrier, NumThreads, -1) then
    raise ESystemError.Create('Error calling InitializeSynchronizationBarrier', GetLastError);
  {$ElseIf defined(UNIX)}
  ret := pthread_barrier_init(@FBarrier, nil, NumThreads);
  if ret <> 0 then
    raise ESystemError.Create('Error calling pthread_barrier_init', ret);
  {$EndIf}
end;

destructor TBarrier.Destroy;
{$IfDef UNIX}
var
  ret: Integer;
{$EndIf}
begin
  {$If defined(WINDOWS)}
  if not DeleteSynchronizationBarrier(@FBarrier) then
    raise ESystemError.Create('Error calling DeleteSynchronizationBarrier', GetLastError);
  {$ElseIf defined(UNIX)}
  ret := pthread_barrier_destroy(@FBarrier);
  if ret <> 0 then
    raise ESystemError.Create('Error calling pthread_barrier_destroy', ret);
  {$EndIf}
end;

end.

