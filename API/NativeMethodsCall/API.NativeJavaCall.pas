unit API.NativeJavaCall;

interface

uses
{$REGION '  Systems''s .. '}
  System.Classes,
  System.Threading,
  System.SyncObjs,
  System.SysUtils,
  System.Generics.Collections,
{$ENDREGION}
{$REGION '  Async''s .. '}
  FMX.DialogService.Async,
{$ENDREGION}
{$REGION '  Helpers .. '}
  FMX.Helpers.Android,
  Androidapi.Helpers,
{$ENDREGION}
{$REGION '  JNI''s .. '}
  Androidapi.Jni,
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,

{$ENDREGION}
  Androidapi.JNI.NativeJavaCall
;

type

  TMyStaticNativeMethods = class(TJMyStaticNativeMethods)
  private
    class procedure AttachDelphiToJavaEnv(aPJavaVM: PJavaVM; aPJNIEnv: PJNIEnv); inline;
    class procedure DetachDelphiFromJavaEnv(aPJavaVM: PJavaVM; aPJNIEnv: PJNIEnv); inline;

    class procedure Log(const aLogMsg: string; aNewLine: Boolean = True);

  public

    class procedure nativeOnLog
      (aPJNIEnv: PJNIEnv; aJavaClass: JNIClass); cdecl; export;

  end;

  TMyNativeMethodsCall = class(TJMyNativeMethodsCall)
  strict private
    fJavaObj: JMyNativeMethodsCall;
  public
    constructor Create;

    property JavaObj: JMyNativeMethodsCall read fJavaObj;
  end;

  TNativeMethodCall = class
  strict private
    fMyNativeMethodsCall: TMyNativeMethodsCall;
  private
  public
    constructor Create();
    destructor Destroy; override;

    procedure GetNativeJava_logHelloWorld;
    function ExecuteJava_reverseString(aInputStr: String): String;
    function ExecutJava_GetTest: string;
  end;



function JNI_OnLoad(aPJavaVM: PJavaVM; reserved: Pointer): JNIInt; cdecl;// export;
procedure JNI_OnUnload(aPJavaVM: PJavaVM; reserved: Pointer); cdecl;// export;

implementation

procedure RegisterNativeJNIMethods(aPJNIEnv: PJNIEnv); inline;
const
  cJavaClassPath = 'com/MBenDelphi/DelphiNativeJavaMethodCallDemo/MyStaticNativeMethods';
var
  LJNIMethod: JNINativeMethod;
  LJNIClass: JNIClass;
begin
  LJNIClass := TJNIResolver.GetJavaClassID(cJavaClassPath);

  LJNIMethod.Name := 'nativeOnLog';
  LJNIMethod.Signature := '()V';
  LJNIMethod.FnPtr := @TMyStaticNativeMethods.nativeOnLog;

  if aPJNIEnv^.RegisterNatives(aPJNIEnv, LJNIClass,
    PJNINativeMethod(@LJNIMethod), 1) < 0 then
  begin
    TDialogServiceAsync.ShowMessage('Failed to register native methods');
  end;

  aPJNIEnv^.DeleteLocalRef(aPJNIEnv, LJNIClass);
end;

procedure UnregisterNativeJNIMethods(aPJNIEnv: PJNIEnv); inline;
const
  cJavaClassPath = 'com/MBenDelphi/DelphiNativeJavaMethodCallDemo/MyStaticNativeMethods';
var
  LJNIClass: JNIClass;
begin
  LJNIClass := TJNIResolver.GetJavaClassID(cJavaClassPath);

  if aPJNIEnv^.UnregisterNatives(aPJNIEnv, LJNIClass) < 0 then
    TDialogServiceAsync.ShowMessage('Failed to unregister native methods');

  aPJNIEnv^.DeleteLocalRef(aPJNIEnv, LJNIClass);
end;

class procedure TMyStaticNativeMethods
  .AttachDelphiToJavaEnv(aPJavaVM: PJavaVM; aPJNIEnv: PJNIEnv);
var
  LStatus: Integer;
begin
  if aPJNIEnv = nil then
    raise Exception.Create('Java Envirement is not initialized.') else
  begin
    if aPJavaVM = nil then begin
      TMyStaticNativeMethods.Log('Java VM is Nil in ON_Load !!');
      aPJavaVM := System.JavaMachine;
    end;

    if aPJavaVM = nil then
      raise Exception.Create('Java VM is not initialized.');

    // Attach current thread to JVM if not already attached
    LStatus := aPJavaVM^.AttachCurrentThread(aPJavaVM, @aPJNIEnv, nil);
    if LStatus <> JNI_OK then
      raise Exception.Create('Failed to attach current thread to JVM, JNI error code: ' + IntToStr(LStatus));

  end;
end;

class procedure TMyStaticNativeMethods
  .DetachDelphiFromJavaEnv(aPJavaVM: PJavaVM; aPJNIEnv: PJNIEnv);
begin
  // If no JNIEnv is attached, there's nothing to detach
  if aPJNIEnv = nil then
    Exit;

  if aPJavaVM = nil then begin
    TMyStaticNativeMethods.Log('Java VM is Nil in ON_Load !!');
    aPJavaVM := System.JavaMachine;
  end;

  if aPJavaVM = nil then
    raise Exception.Create('Java VM is not initialized.');

  // Detach the current thread from the JVM
  if aPJavaVM^.DetachCurrentThread(aPJavaVM) <> JNI_OK then
    raise Exception.Create('Failed to detach thread from JVM');
end;

{ TJavaDelphiJNINativeMethods }

class procedure TMyStaticNativeMethods
  .Log(const aLogMsg: string; aNewLine: Boolean);
begin
  TThread.Queue(nil, procedure begin
    TDialogServiceAsync.ShowMessage(aLogMsg);
  end);
end;

// Native method that triggers any logs ..
class procedure TMyStaticNativeMethods
  .nativeOnLog
    (aPJNIEnv: PJNIEnv; aJavaClass: JNIClass); cdecl; export;
begin

  TMyStaticNativeMethods.Log('Received log message: ' +
    JStringToString(TMyStaticNativeMethods.JavaClass.rturnedStr));

end;

{ TJavaNativeMethodCall }

constructor TMyNativeMethodsCall.Create;
begin
  fJavaObj := Self.JavaClass.init;
end;

{ TNativeMethodCall }

constructor TNativeMethodCall.Create;
begin
  fMyNativeMethodsCall :=
    TMyNativeMethodsCall.Create;
end;

destructor TNativeMethodCall.Destroy;
begin
  inherited;
end;

procedure TNativeMethodCall
  .GetNativeJava_logHelloWorld;
begin
  CallInUIThread(procedure begin
    fMyNativeMethodsCall.JavaObj.doLogHelloWorld;
  end);
end;

function TNativeMethodCall
  .ExecuteJava_reverseString(aInputStr: String): String;
var
  LResult: JString;
begin
  CallInUIThread(procedure begin
    LResult := fMyNativeMethodsCall
      .JavaObj.doReverseString(StringToJString(aInputStr));
  end);

  Result  := JStringToString(LResult);
end;

function TNativeMethodCall
  .ExecutJava_GetTest: string;
var
  LResult: JString;
begin
  CallInUIThread(procedure begin
    LResult := fMyNativeMethodsCall.JavaObj.GetTest;
  end);

  Result  := JStringToString(LResult);
end;

// JNI_OnLoad: Called when the native library is loaded
function JNI_OnLoad(aPJavaVM: PJavaVM; reserved: Pointer): JNIInt; cdecl;// export;
const
  JNI_VERSION_1_8 = JNIInt($00010008);
var
  LJNIEnv: PJNIEnv;
  LJNIVers: JNIInt;
begin
  LJNIEnv  := TJNIResolver.GetJNIEnv;
  LJNIVers := LJNIEnv^.GetVersion(LJNIEnv);

  aPJavaVM^.GetEnv(aPJavaVM, @LJNIEnv, LJNIVers);

  try
    RegisterNativeJNIMethods(LJNIEnv);
  finally
    LJNIEnv := TJNIResolver.GetJNIEnv;
    TMyStaticNativeMethods
      .AttachDelphiToJavaEnv(aPJavaVM, LJNIEnv);
  end;

  Result := LJNIVers;
end;

// JNI_OnUnload: Called when the native library is unloaded
procedure JNI_OnUnload(aPJavaVM: PJavaVM; reserved: Pointer); cdecl;// export;
var
  LJNIEnv: PJNIEnv;
  LJNIVers: JNIInt;
begin
  LJNIEnv  := TJNIResolver.GetJNIEnv;
  LJNIVers := LJNIEnv^.GetVersion(LJNIEnv);

  aPJavaVM^.GetEnv(aPJavaVM, @LJNIEnv, LJNIVers);

  try
    TMyStaticNativeMethods
      .DetachDelphiFromJavaEnv(aPJavaVM, LJNIEnv);
  finally
    UnregisterNativeJNIMethods(LJNIEnv);
  end;
end;

exports
  JNI_OnLoad name 'JNI_OnLoad',
  JNI_OnUnload name 'JNI_OnUnload';

end.