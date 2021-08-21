unit win_barrier;

{$mode objfpc}{$H+}

interface

uses
  windows;

type
  // See winnt.h:19826
  {$PackRecords C}
  TRTL_BARRIER = record
    Reserved1: DWORD;
    Reserved2: DWORD;
    Reserved3: array[0..1] of ULONG_PTR;
    Reserved4: DWORD;
    Reserved5: DWORD;
  end;
  PRTL_BARRIER = ^TRTL_BARRIER;
  // see Synchapi.h:709
  TSYNCHRONIZATION_BARRIER = TRTL_BARRIER;
  PSYNCHRONIZATION_BARRIER = PRTL_BARRIER;
  LPSYNCHRONIZATION_BARRIER = PRTL_BARRIER;

const
  SYNCHRONIZATION_BARRIER_FLAGS_SPIN_ONLY = $01;
  SYNCHRONIZATION_BARRIER_FLAGS_BLOCK_ONLY = $02;
  SYNCHRONIZATION_BARRIER_FLAGS_NO_DELETE = $04;

function EnterSynchronizationBarrier(lpBarrier: LPSYNCHRONIZATION_BARRIER; dwFlags: DWORD): WINBOOL; stdcall; external 'kernel32' name 'EnterSynchronizationBarrier';
function InitializeSynchronizationBarrier(lpBarrier: LPSYNCHRONIZATION_BARRIER; lTotalThreads: LONG; lSpinCount: LONG): WINBOOL; stdcall; external 'kernel32' name 'InitializeSynchronizationBarrier';
function DeleteSynchronizationBarrier(lpBarrier: LPSYNCHRONIZATION_BARRIER): WINBOOL; stdcall; external 'kernel32' name 'DeleteSynchronizationBarrier';

implementation

end.

