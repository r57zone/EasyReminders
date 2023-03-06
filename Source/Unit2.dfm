object AddDialog: TAddDialog
  Left = 221
  Top = 143
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1072#1087#1086#1084#1080#1085#1072#1085#1080#1077
  ClientHeight = 233
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object ReminderLbl: TLabel
    Left = 8
    Top = 152
    Width = 124
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1087#1086#1084#1080#1085#1072#1085#1080#1103':'
  end
  object DoneBtn: TButton
    Left = 8
    Top = 200
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 0
    OnClick = DoneBtnClick
  end
  object CancelBtn: TButton
    Left = 88
    Top = 200
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object ByDateRB: TRadioButton
    Left = 8
    Top = 16
    Width = 73
    Height = 17
    Caption = #1055#1086' '#1076#1072#1090#1077
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object DatePicker: TDateTimePicker
    Left = 88
    Top = 14
    Width = 89
    Height = 21
    Date = 0.041666666666666660
    Time = 0.041666666666666660
    TabOrder = 3
  end
  object EveryNdaysRB: TRadioButton
    Left = 8
    Top = 72
    Width = 105
    Height = 17
    Caption = #1050#1072#1078#1076#1099#1077' (n) '#1076#1085#1077#1081
    TabOrder = 4
  end
  object DayCountEdt: TEdit
    Left = 184
    Top = 68
    Width = 55
    Height = 21
    TabOrder = 5
    Text = '1'
    OnKeyUp = DayCountEdtKeyUp
  end
  object DayOfTheMonthRB: TRadioButton
    Left = 8
    Top = 96
    Width = 137
    Height = 17
    Caption = #1044#1077#1085#1100' '#1084#1077#1089#1103#1094#1072
    TabOrder = 6
  end
  object DayAndMonthRB: TRadioButton
    Left = 8
    Top = 120
    Width = 145
    Height = 17
    Caption = #1044#1077#1085#1100' '#1080' '#1084#1077#1089#1103#1094
    TabOrder = 7
  end
  object NofifyNameEdt: TEdit
    Left = 8
    Top = 168
    Width = 234
    Height = 21
    TabOrder = 8
    OnKeyDown = NofifyNameEdtKeyDown
  end
  object TimePicker: TDateTimePicker
    Left = 88
    Top = 38
    Width = 89
    Height = 21
    Date = 44872.981311840270000000
    Time = 44872.981311840270000000
    Kind = dtkTime
    TabOrder = 9
  end
  object SetCurDayBtn: TButton
    Left = 184
    Top = 14
    Width = 57
    Height = 21
    Caption = #1057#1077#1075#1086#1076#1085#1103
    TabOrder = 10
    OnClick = SetCurDayBtnClick
  end
  object SetCurTimeBtn: TButton
    Left = 184
    Top = 38
    Width = 57
    Height = 21
    Caption = #1057#1077#1081#1095#1072#1089
    TabOrder = 11
    OnClick = SetCurTimeBtnClick
  end
end
