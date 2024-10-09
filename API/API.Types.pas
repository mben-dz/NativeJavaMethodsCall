unit API.Types;

interface

uses
  System.Classes,
  System.SysUtils,
  System.SyncObjs
;

type
  TProcLog = TProc<string>;
  TProcLogView = TProc<string,Boolean>;

  TLogView = class
  strict private
    fLockLogView: TCriticalSection;
    fLogView: TProcLogView;
  private
  public
    constructor Create(aLockLogView: TCriticalSection;
      aLogView: TProc<string, Boolean>);

    procedure Log(const aLogMsg: string; aNewLine: Boolean = True);
  end;

implementation

{ TLogView }

constructor TLogView.Create(
  aLockLogView: TCriticalSection;
  aLogView: TProc<string, Boolean>);
begin
  fLockLogView := aLockLogView;
  fLogView     := aLogView;
end;

procedure TLogView.Log(const aLogMsg: string; aNewLine: Boolean);
begin
  if Assigned(fLogView) then
//  TThread.Queue(nil, procedure begin
//    fLockLogView.Enter;
//    try
      fLogView(aLogMsg, aNewLine);
//    finally
//      fLockLogView.Leave;
//    end;
//  end);
end;

end.
