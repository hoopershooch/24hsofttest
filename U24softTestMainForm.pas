unit U24softTestMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UCrossThreadObjects, UPrimesThread, ExtCtrls;

type
  TTestMainForm = class(TForm)
    StartButton: TButton;
    LimitEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure StartButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FTimer: TTimer;
    FPThread1, FPThread2: TPrimeThread;
    FRecvMessHandle: Cardinal;
    FDoneCount: Integer;
    procedure RecvDoneMess(var AMessage: TMessage);
    procedure OnWatchTimer(Sender: TObject);
  public
    { Public declarations }
  end;

var
  TestMainForm: TTestMainForm;

implementation


{$R *.dfm}

procedure TTestMainForm.FormCreate(Sender: TObject);
begin
  FTimer:=TTimer.Create(Self);
  FTimer.Enabled:=False;
  FTimer.Interval:=500;
  FTimer.OnTimer:=OnWatchTimer;
  FRecvMessHandle:=AllocateHWnd(RecvDoneMess);
end;

procedure TTestMainForm.FormDestroy(Sender: TObject);
begin
  DeallocateHWnd(FRecvMessHandle);
  FTimer.Free;
end;

procedure TTestMainForm.StartButtonClick(Sender: TObject);
var
  ALimit, AFHandle: Integer;
  AFlag: Boolean;
  Initial: String;
  AWritten:Cardinal;
  AStart, ADelta: Double;
begin
  StartButton.Enabled:=False;
  try
    ALimit := StrToInt(LimitEdit.Text);
    if ALimit <= 0 then
    begin
      Application.MessageBox('Введите целое положительное число!', 'Ошибка', MB_OK+MB_ICONERROR);
      Exit;
    end;
  except
    Application.MessageBox('Введите целое положительное число!', 'Ошибка', MB_OK+MB_ICONERROR);
    Exit;
  end;

  Initial:='1 2 3 ';

  AFHandle:= CreateFile(Pchar('result.txt'),// pointer to name of the file
                        GENERIC_READ + GENERIC_WRITE,  // access (read-write) mode
                        0,                             // share mode
                        nil,                           // pointer to security attributes
                        CREATE_ALWAYS,                 // how to create
                        0,                             // file attributes
                        0);                            // handle to file with attributes to copy
  if AFHandle>0 then
  begin
    WriteFile(AFHandle, PChar(@Initial[1])^, Length(Initial), AWritten, 0);
    Closehandle(AFHandle);
  end;

  GCurrTestedNumber:=3;
  GLimit:=ALimit;
  FDoneCount:=0;
  FTimer.Enabled:=True;

  FPThread1:=TPrimeThread.Create('Thread1', FRecvMessHandle, True);
  FPThread2:=TPrimeThread.Create('Thread2', FRecvMessHandle, True);
  if FPThread1.Initialize and FPThread2.Initialize then
  begin
    FPThread1.Resume;
    FPThread2.Resume;
  end
  else
  begin
    Application.MessageBox(Pchar('Не удалось инициализировать собственные файлы потоков!'),
                           Pchar('Ошибка'), MB_OK+MB_ICONERROR);
    StartButton.Enabled:=True;
  end;

end;

procedure TTestMainForm.Button1Click(Sender: TObject);
var
  AFS: TFileStream;
  AFlag: Boolean;
  Initial: String;
  ATF: TextFile;
  ASL: TStringList;
  i,n:Integer;
begin
  PostMessageA(FRecvMessHandle, WM_DATA_CALCULATED, 0,0)
end;

procedure TTestMainForm.RecvDoneMess(var AMessage: TMessage);
begin
  if aMessage.Msg = WM_DATA_CALCULATED then
  begin
    inc(FDoneCount);
  end;
end;

procedure TTestMainForm.OnWatchTimer(Sender: TObject);
begin
  if FDoneCount>=2 then
  begin
    StartButton.Enabled:=True;
    FDoneCount:=0;
    Application.MessageBox(PChar('Расчёт выполнен, данные записаны в файлы!'),
                           PChar('Информация'), MB_OK+MB_ICONINFORMATION);
    WaitForSingleObject(FPThread1.Handle, 5000);
    WaitForSingleObject(FPThread2.Handle, 5000);
    FPThread1.Free;
    FPThread2.Free;
    FTimer.Enabled:=False;
  end;
  Label1.Caption:=IntToStr(GCurrTestedNumber);
end;


end.
