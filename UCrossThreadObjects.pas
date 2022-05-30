unit UCrossThreadObjects;

interface

uses Windows,Classes;

var
  GResultFileCS: TRTLCriticalSection;
  GCommonPrimesBuffCS: TRTLCriticalSection;
  GCommonPrimes: TStringList;
  GCurrTestedNumber: Cardinal;
  GLimit: Cardinal;
  WM_DATA_CALCULATED: Cardinal;

implementation

initialization
  InitializeCriticalSection(GResultFileCS);
  InitializeCriticalSection(GCommonPrimesBuffCS);
  WM_DATA_CALCULATED:=RegisterWindowMessage('DATA_CALCULATED');


finalization
  DeleteCriticalSection(GResultFileCS);
  DeleteCriticalSection(GCommonPrimesBuffCS);
end.
