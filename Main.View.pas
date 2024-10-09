unit Main.View;

interface

uses
{$REGION '  System''s .. '}
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.SyncObjs,  // TCriticalSection
{$ENDREGION}
{$REGION '  FMX''s .. '}
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Layouts,
  FMX.TabControl,
  FMX.Ani,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.StdCtrls,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo
{$ENDREGION}
//
, API.NativeJavaCall
;

type
  TMainView = class(TForm)
  {$REGION '  Comp .. '}
    Lyt_Main: TLayout;
    Rect_Main: TRectangle;
    Lyt_Top: TLayout;
    Lyt_Status: TLayout;
    Lyt_Client: TLayout;
    Lyt_SysBar: TLayout;
    Lyt_AppTitle: TLayout;
    TabView: TTabControl;
    Tab_Loading: TTabItem;
    Tab_Main: TTabItem;
    Rect_AppTitle: TRectangle;
    Txt_AppTitle: TText;
    Rect_Status: TRectangle;
    Txt_Infos: TText;
    Lyt_ToolB: TLayout;
    Lyt_Infos: TLayout;
    Rect_ToolBar: TRectangle;
    Edt_ReverseStr: TEdit;
    Lyt_Request: TLayout;
    Txt_1: TText;
    Memo_Log: TMemo;
    GridLyt_Btns: TGridPanelLayout;
    Btn_GetNative_HelloWorld: TButton;
    Btn_GetNative_JavaReverseStr: TButton;
    Rectangle1: TRectangle;
    Txt_Status: TText;
    Btn_GetTest: TButton;
  {$ENDREGION}

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_GetNative_HelloWorldClick(Sender: TObject);
    procedure Btn_GetNative_JavaReverseStrClick(Sender: TObject);
    procedure Edt_ReverseStrChange(Sender: TObject);
    procedure Btn_GetTestClick(Sender: TObject);
  private

  private
    fNativeMethodCall: TNativeMethodCall;
    function GetNativeMethodCall: TNativeMethodCall;
  public
    property NativeMethodCall: TNativeMethodCall read GetNativeMethodCall;
  end;

implementation

uses
  API.Telephony.Infos;

{$R *.fmx}

function TMainView.GetNativeMethodCall: TNativeMethodCall;
begin
  if not Assigned(fNativeMethodCall) then

  fNativeMethodCall :=
    TNativeMethodCall.Create;

  Result := fNativeMethodCall;
end;

procedure TMainView.Btn_GetNative_HelloWorldClick(Sender: TObject);
begin
  NativeMethodCall.GetNativeJava_logHelloWorld;
end;

procedure TMainView.Btn_GetTestClick(Sender: TObject);
begin
  Memo_Log.Lines
    .Append(NativeMethodCall.ExecutJava_GetTest);
end;

procedure TMainView.Btn_GetNative_JavaReverseStrClick(Sender: TObject);
begin
  Edt_ReverseStr.Text := NativeMethodCall
      .ExecuteJava_reverseString(Edt_ReverseStr.Text);
end;

procedure TMainView.Edt_ReverseStrChange(Sender: TObject);
begin
  Btn_GetNative_JavaReverseStr.Enabled :=
   not Edt_ReverseStr.Text.IsEmpty;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  Txt_Status.Text := GetPhoneInfo;

  Btn_GetNative_JavaReverseStr.Enabled :=
   not Edt_ReverseStr.Text.IsEmpty;

end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  fNativeMethodCall.Free;
end;


end.
