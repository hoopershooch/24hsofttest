program Test24hsoft;

uses
  Forms,
  U24softTestMainForm in 'U24softTestMainForm.pas' {TestMainForm},
  UPrimesThread in 'UPrimesThread.pas',
  UCrossThreadObjects in 'UCrossThreadObjects.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTestMainForm, TestMainForm);
  Application.Run;
end.
