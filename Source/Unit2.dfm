object AddDialog: TAddDialog
  Left = 221
  Top = 143
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1072#1087#1086#1084#1080#1085#1072#1085#1080#1077
  ClientHeight = 223
  ClientWidth = 296
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
    Top = 140
    Width = 124
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1087#1086#1084#1080#1085#1072#1085#1080#1103':'
  end
  object DoneBtn: TButton
    Left = 7
    Top = 191
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 17
    OnClick = DoneBtnClick
  end
  object CancelBtn: TButton
    Left = 88
    Top = 191
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 18
    OnClick = CancelBtnClick
  end
  object ByDateRB: TRadioButton
    Left = 8
    Top = 15
    Width = 73
    Height = 17
    Caption = #1055#1086' '#1076#1072#1090#1077
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object DatePicker: TDateTimePicker
    Left = 116
    Top = 13
    Width = 89
    Height = 21
    Date = 0.041666666666666660
    Time = 0.041666666666666660
    TabOrder = 2
  end
  object EveryNdaysRB: TRadioButton
    Left = 8
    Top = 65
    Width = 105
    Height = 17
    Caption = #1050#1072#1078#1076#1099#1077' (n) '#1076#1085#1077#1081
    TabOrder = 9
  end
  object DayCountEdt: TEdit
    Left = 165
    Top = 63
    Width = 40
    Height = 21
    TabOrder = 11
    Text = '1'
    OnKeyUp = DayCountEdtKeyUp
  end
  object DayOfTheMonthRB: TRadioButton
    Left = 8
    Top = 90
    Width = 137
    Height = 17
    Caption = #1044#1077#1085#1100' '#1084#1077#1089#1103#1094#1072
    TabOrder = 14
  end
  object DayAndMonthRB: TRadioButton
    Left = 8
    Top = 115
    Width = 145
    Height = 17
    Caption = #1044#1077#1085#1100' '#1080' '#1084#1077#1089#1103#1094
    TabOrder = 15
  end
  object NofifyNameEdt: TEdit
    Left = 8
    Top = 159
    Width = 280
    Height = 21
    TabOrder = 16
    OnKeyDown = NofifyNameEdtKeyDown
  end
  object TimePicker: TDateTimePicker
    Left = 116
    Top = 38
    Width = 89
    Height = 21
    Date = 44872.000000000000000000
    Time = 44872.000000000000000000
    Kind = dtkTime
    TabOrder = 6
  end
  object SetNextDayBtn: TButton
    Left = 233
    Top = 12
    Width = 56
    Height = 23
    Caption = #1047#1072#1074#1090#1088#1072
    TabOrder = 4
    OnClick = SetNextDayBtnClick
  end
  object SetCurTimeBtn: TButton
    Left = 233
    Top = 37
    Width = 56
    Height = 23
    Caption = #1057#1077#1081#1095#1072#1089
    TabOrder = 8
    OnClick = SetCurTimeBtnClick
  end
  object SetDayAddBtn: TButton
    Left = 208
    Top = 12
    Width = 23
    Height = 23
    Caption = '+'
    TabOrder = 3
    OnClick = SetDayAddBtnClick
  end
  object SetDaySubBtn: TButton
    Left = 90
    Top = 12
    Width = 23
    Height = 23
    Caption = '-'
    TabOrder = 1
    OnClick = SetDaySubBtnClick
  end
  object SetTimeSubBtn: TButton
    Left = 90
    Top = 37
    Width = 23
    Height = 23
    Caption = '-'
    TabOrder = 5
    OnClick = SetTimeSubBtnClick
  end
  object SetTimeAddBtn: TButton
    Left = 208
    Top = 37
    Width = 23
    Height = 23
    Caption = '+'
    TabOrder = 7
    OnClick = SetTimeAddBtnClick
  end
  object SetEveryDaySubBtn: TButton
    Left = 139
    Top = 62
    Width = 23
    Height = 23
    Caption = '-'
    TabOrder = 10
    OnClick = SetEveryDaySubBtnClick
  end
  object SetEveryDayAddBtn: TButton
    Left = 208
    Top = 62
    Width = 23
    Height = 23
    Caption = '+'
    TabOrder = 12
    OnClick = SetEveryDayAddBtnClick
  end
  object SetEveryDayWeekBtn: TButton
    Left = 233
    Top = 62
    Width = 56
    Height = 23
    Caption = #1053#1077#1076#1077#1083#1103
    TabOrder = 13
    OnClick = SetEveryDayWeekBtnClick
  end
end
