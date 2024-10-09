
unit Androidapi.JNI.NativeJavaCall;

interface

uses
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes;

type
// ===== Forward declarations =====

  JMyNativeMethodsCall = interface;//com.MBenDelphi.DelphiNativeJavaMethodCallDemo.MyNativeMethodsCall
  JMyStaticNativeMethods = interface;//com.MBenDelphi.DelphiNativeJavaMethodCallDemo.MyStaticNativeMethods

// ===== Interface declarations =====

  JMyNativeMethodsCallClass = interface(JObjectClass) ['{87926597-CFCF-40CB-801A-A6FC2E77A8FB}']
    {class} function init: JMyNativeMethodsCall; cdecl;
  end;

  [JavaSignature('com/MBenDelphi/DelphiNativeJavaMethodCallDemo/MyNativeMethodsCall')]
  JMyNativeMethodsCall = interface(JObject) ['{511708B3-7970-4292-BD2B-FD9BFE8AE952}']

    function GetTest: JString; cdecl;
    procedure doLogHelloWorld; cdecl;
    function doReverseString(string_: JString): JString; cdecl;
  end;
  TJMyNativeMethodsCall = class
    (TJavaGenericImport<JMyNativeMethodsCallClass, JMyNativeMethodsCall>) end;

  JMyStaticNativeMethodsClass = interface(JObjectClass)
    ['{C820E393-A93E-45CC-9311-0CE24ED960F7}']
    {class} function _GetrturnedStr: JString; cdecl;
    {class} procedure _SetrturnedStr(Value: JString); cdecl;

    {class} function init: JMyStaticNativeMethods; cdecl;

    {class} procedure nativeOnLog; cdecl; // Native procedure to trigger Logs ..

    {class} property rturnedStr: JString read _GetrturnedStr write _SetrturnedStr;
  end;

  [JavaSignature('com/MBenDelphi/DelphiNativeJavaMethodCallDemo/MyStaticNativeMethods')]
  JMyStaticNativeMethods = interface(JObject) ['{ECD2A777-4EE1-4FB4-AAED-6FBA47FED3FC}']
  end;
  TJMyStaticNativeMethods = class
    (TJavaGenericImport<JMyStaticNativeMethodsClass, JMyStaticNativeMethods>) end;

implementation

procedure RegisterTypes;
begin

  TRegTypes.RegisterType('Androidapi.JNI.NativeJavaCall.JMyNativeMethodsCall',
    TypeInfo(Androidapi.JNI.NativeJavaCall.JMyNativeMethodsCall));

  TRegTypes.RegisterType('Androidapi.JNI.NativeJavaCall.JMyStaticNativeMethods',
    TypeInfo(Androidapi.JNI.NativeJavaCall.JMyStaticNativeMethods));

end;

initialization
  RegisterTypes;
end.
