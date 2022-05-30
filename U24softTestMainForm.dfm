object TestMainForm: TTestMainForm
  Left = 192
  Top = 153
  Width = 507
  Height = 95
  Caption = #1058#1077#1089#1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 160
    Top = 36
    Width = 17
    Height = 13
    HelpContext = 16
    Caption = '----'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 12
    Width = 128
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1074#1077#1088#1093#1085#1080#1081' '#1087#1088#1077#1076#1077#1083':'
  end
  object Label3: TLabel
    Left = 16
    Top = 36
    Width = 126
    Height = 13
    Caption = #1057#1077#1081#1095#1072#1089' '#1086#1073#1088#1072#1073#1072#1090#1099#1074#1072#1077#1090#1089#1103':'
  end
  object StartButton: TButton
    Left = 328
    Top = 8
    Width = 153
    Height = 41
    Caption = #1057#1090#1072#1088#1090
    TabOrder = 0
    OnClick = StartButtonClick
  end
  object LimitEdit: TEdit
    Left = 160
    Top = 8
    Width = 161
    Height = 21
    TabOrder = 1
    Text = '1000000'
  end
end
