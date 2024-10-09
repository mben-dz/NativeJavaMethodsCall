program DelphiNativeJavaMethodCallDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  API.Telephony.Infos in 'API\API.Telephony.Infos.pas',
  Androidapi.JNI.NativeJavaCall in 'API\NativeMethodsCall\Androidapi.JNI.NativeJavaCall.pas',
  API.NativeJavaCall in 'API\NativeMethodsCall\API.NativeJavaCall.pas',
  Main.View in 'Main.View.pas' {MainView};

{$R *.res}

var
  MainView: TMainView;
begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
