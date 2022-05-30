unit UPrimesThread;

interface

uses
  Classes, Windows, SysUtils, UCrossThreadObjects;

type
  TPrimeThread = class(TThread)
  protected
    FDoneHandle: Cardinal;
    FName: String;
    FLogList: TStringList;
    FStr: String;
    FOwnFileHandle: Cardinal;

    function IsPrime(ANumber: Cardinal): Boolean;
    procedure Execute; override;
  public
    constructor Create(AName: String; ADoneHandle: Cardinal; CreateSuspended: Boolean);
    destructor Destroy;
    function Initialize(): Boolean;
  end;


implementation
uses U24softTestMainForm;

{ TPrimeThread }

constructor TPrimeThread.Create(AName: String; ADoneHandle: Cardinal; CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FDoneHandle:=ADoneHandle;
  FName:=AName;
  FLogList:=TStringList.Create;
end;

destructor TPrimeThread.Destroy;
begin
//  FLogList.SaveToFile(Fname+'.txt');
  FLogList.Free;
end;

function TPrimeThread.Initialize: Boolean;
begin
  FOwnFileHandle:=CreateFile(Pchar(FName+'.txt'),// pointer to name of the file
                             GENERIC_READ + GENERIC_WRITE,  // access (read-write) mode
                             0,                             // share mode
                             nil,                           // pointer to security attributes
                             CREATE_ALWAYS,                 // how to create
                             0,                             // file attributes
                             0);                            // handle to file with attributes to copy
  Result:= FOwnFileHandle>0;
end;

procedure TPrimeThread.Execute;
var
  ANumberToCheck: Cardinal;
  AStr, AppendingStr: String;
  AFHandle, AWritten, i: Cardinal;
begin
  FLogList.Add(' ');

  While not Terminated do
  begin
    if TryEnterCriticalSection(GCommonPrimesBuffCS) then
    begin
      try
        ANumberToCheck := GCurrTestedNumber + 1;
        GCurrTestedNumber:= ANumberToCheck;
      finally
        LeaveCriticalSection(GCommonPrimesBuffCS);
      end;
    end;


    if IsPrime(ANumberToCheck) then
    begin

      while True do
      begin
        if TryEnterCriticalSection(GResultFileCS) then
        begin
          try

            AStr:= IntToStr(ANumberToCheck)+' ';
            FLogList.Add(IntToStr(ANumberToCheck));
            AFHandle:= CreateFile(Pchar('result.txt'),// pointer to name of the file
                                  GENERIC_READ + GENERIC_WRITE,  // access (read-write) mode
                                  0,                             // share mode
                                  nil,                           // pointer to security attributes
                                  OPEN_EXISTING,                 // how to create
                                  0,                             // file attributes
                                  0);                            // handle to file with attributes to copy
            if AFHandle > 0 then
            begin
              SetFilePointer(AFHandle,	// handle of file
                             0,	// number of bytes to move file pointer
                             nil,	// address of high-order word of distance to move
                             FILE_END); 	// how to move
              WriteFile(AFHandle, Pchar(@AStr[1])^, Length(AStr), AWritten, 0);
              Closehandle(AFHandle);
            end;
            Break;
          finally
            LeaveCriticalSection(GResultFileCS);
          end;
        end;

      end;

    end;


//-----------------------------


    if ANumberToCheck > GLimit then
    begin
      //FLogList.SaveToFile(FName+'.txt');
      if FOwnFileHandle > 0 then
      begin
        SetFilePointer(FOwnFileHandle,	// handle of file
                       0,	// number of bytes to move file pointer
                       nil,	// address of high-order word of distance to move
                       FILE_END); 	// how to move
        for i:=1 to FLogList.Count do
        begin
          AppendingStr:=FLogList[i-1]+' ';
          WriteFile(FOwnFileHandle, Pchar(@AppendingStr[1])^, Length(AppendingStr), AWritten, 0);
        end;
        Closehandle(FOwnFileHandle);
      end;
      PostMessage(FDoneHandle, WM_DATA_CALCULATED,0,0);
      Terminate;
    end;
  end;
end;


function TPrimeThread.IsPrime(ANumber: Cardinal): Boolean;
var
  i: Cardinal;
begin
  Result:=True;
  for i:=2 to ANumber-1 do
  begin
    if ANumber mod i = 0 then
    begin
      Result:=False;
      Break;
    end;
    if Terminated then Break;
  end;
end;




(*
    AStr:='';
    FLogList.Add('Trying enter NUMBERS CS');
    if TryEnterCriticalSection(GCommonPrimesBuffCS) then
    begin
      FLogList.Add('Entered NUMBERS CS');
      try
        ANumberToCheck := GCurrTestedNumber + 1;
        FLogList.Add('NUMBER='+IntToStr(ANumberToCheck));

      finally
        LeaveCriticalSection(GCommonPrimesBuffCS);
        FLogList.Add('Left NUMBERS CS');
      end;

    end;
//-----------------------------
    if IsPrime(ANumberToCheck) then
    begin
      AStr:= IntToStr(ANumberToCheck)+' ';
      FLogList.Add(IntToStr(ANumberToCheck)+ ' is prime!');

    end;
//-----------------------------
    FLogList.Add('ENTERING SECOND NUMBER CS');

    if TryEnterCriticalSection(GCommonPrimesBuffCS) then
    begin
      try
        GCurrTestedNumber := ANumberToCheck;
        FLogList.Add('Assigned new global');

      finally
        LeaveCriticalSection(GCommonPrimesBuffCS);
        FLogList.Add('LEFT SECOND NUMBER CS');

      end;

    end;
//---------------------------
    Inc(ANumberToCheck);
    if AStr <> '' then
    begin
      FLogList.Add('ENTERING FILE CS');

      if TryEnterCriticalSection(GResultFileCS)then
      begin
        FLogList.Add('ENTERED FILE CS');

        try
          AStr:= FName+'_prb ';
          AFHandle:= CreateFile(Pchar('result.txt'),// pointer to name of the file
                                GENERIC_READ + GENERIC_WRITE,  // access (read-write) mode
                                0,                             // share mode
                                nil,                           // pointer to security attributes
                                OPEN_EXISTING,                 // how to create
                                0,                             // file attributes
                                0);                            // handle to file with attributes to copy
          if AFHandle > 0 then
          begin
            SetFilePointer(AFHandle,	// handle of file
                           0,	// number of bytes to move file pointer
                           nil,	// address of high-order word of distance to move
                           FILE_END); 	// how to move

            WriteFile(AFHandle, Pchar(@AStr[1])^, Length(AStr), AWritten, 0);
            Closehandle(AFHandle);
          end;
          FLogList.Add('WROTE COMMON FLE');

        finally
          LeaveCriticalSection(GResultFileCS);
          FLogList.Add('LEFT FILE CS');

        end;
      end;
    end;
    if ANumberToCheck >= GLimit then Terminate;
*)


end.
