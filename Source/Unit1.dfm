object Main: TMain
  Left = 192
  Top = 124
  AlphaBlend = True
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1053#1072#1087#1086#1084#1080#1085#1072#1085#1080#1103
  ClientHeight = 303
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object AddBtn: TButton
    Left = 7
    Top = 271
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 1
    OnClick = AddBtnClick
  end
  object ListView: TListView
    Left = 8
    Top = 8
    Width = 456
    Height = 256
    Columns = <
      item
        Caption = #1044#1072#1090#1072
        Width = 70
      end
      item
        Caption = #1042#1088#1077#1084#1103
        Width = 54
      end
      item
        Caption = #1058#1080#1087
        Width = 100
      end
      item
        Caption = #1053#1072#1087#1086#1084#1080#1085#1072#1085#1080#1077
        Width = 210
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = ListViewPopupMenu
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListViewDblClick
    OnKeyPress = ListViewKeyPress
  end
  object RemBtn: TButton
    Left = 169
    Top = 271
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 3
    OnClick = RemBtnClick
  end
  object AboutBtn: TButton
    Left = 438
    Top = 271
    Width = 27
    Height = 25
    Caption = '?'
    TabOrder = 4
    OnClick = AboutBtnClick
  end
  object ChangeBtn: TButton
    Left = 88
    Top = 271
    Width = 75
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 2
    OnClick = ChangeBtnClick
  end
  object SearchEdt: TEdit
    Left = 251
    Top = 273
    Width = 180
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnChange = SearchEdtChange
    OnKeyDown = SearchEdtKeyDown
    OnKeyUp = SearchEdtKeyUp
    OnMouseDown = SearchEdtMouseDown
  end
  object XPManifest1: TXPManifest
    Left = 16
    Top = 32
  end
  object PopupMenuApp: TPopupMenu
    Left = 48
    Top = 32
    object AboutMenuBtn: TMenuItem
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'...'
      OnClick = AboutMenuBtnClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object CloseMenuBtn: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = CloseMenuBtnClick
    end
  end
  object TimerChecker: TTimer
    Interval = 6000
    OnTimer = TimerCheckerTimer
    Left = 80
    Top = 32
  end
  object ListViewPopupMenu: TPopupMenu
    Left = 112
    Top = 32
    object ChangeMenuBtn: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      OnClick = ChangeMenuBtnClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MoveBtn: TMenuItem
      Caption = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100
      object MoveUpBtn: TMenuItem
        Caption = #1042#1074#1077#1088#1093
        OnClick = MoveUpBtnClick
      end
      object MoveDownBtn: TMenuItem
        Caption = #1042#1085#1080#1079
        OnClick = MoveDownBtnClick
      end
    end
  end
end
