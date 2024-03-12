unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, XPMan, ShellAPI, DateUtils, Registry, Menus,
  ExtCtrls, IniFiles;

type
  TReminder = record
    Name: string;
    RType: string;
    CountDays: integer;
    Date: TDateTime;
    TimeSec: int64;
    LastNoticeDate: string;
end;

type
  TMain = class(TForm)
    AddBtn: TButton;
    XPManifest1: TXPManifest;
    ListView: TListView;
    RemBtn: TButton;
    AboutBtn: TButton;
    PopupMenu1: TPopupMenu;
    CloseMenuBtn: TMenuItem;
    TimerChecker: TTimer;
    ListViewPopupMenu: TPopupMenu;
    MoveBtn: TMenuItem;
    MoveUpBtn: TMenuItem;
    MoveDownBtn: TMenuItem;
    ChangeMenuBtn: TMenuItem;
    N1: TMenuItem;
    ChangeBtn: TButton;
    N2: TMenuItem;
    AboutMenuBtn: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure RemBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CloseMenuBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ChangeMenuBtnClick(Sender: TObject);
    procedure TimerCheckerTimer(Sender: TObject);
    procedure MoveUpBtnClick(Sender: TObject);
    procedure MoveDownBtnClick(Sender: TObject);
    procedure ChangeBtnClick(Sender: TObject);
    procedure AboutMenuBtnClick(Sender: TObject);
    procedure ListViewKeyPress(Sender: TObject; var Key: Char);
  private
    procedure DefaultHandler(var Message); override;
    { Private declarations }
  public
    procedure AppShow;
    procedure AppHide;
    function ReminderTypeToStr(TypeStr: string): string;
    procedure AddReminder(Reminder: TReminder);
    procedure LoadReminders(FileName: string);
    procedure UpdateRemindersView;
    procedure SaveReminders;
    procedure Check;
    { Public declarations }
  protected
    procedure IconMouse(var Msg: TMessage); message WM_USER + 1;
    procedure WMActivate(var Msg: TMessage); message WM_ACTIVATE;
  end;

var
  Main: TMain;
  NoticeFormMode: integer;
  WM_TASKBARCREATED: cardinal;
  NotificationApp: string;
  Reminders: array of TReminder;
  DBFileName: string;
  CurReminderIndex: integer; // ��� ��������� ���������� �����������
  AllowClose: boolean = false;
  AllowHide: boolean = true;
  AddDefaultTime: TTime; // ����� �� ��������� � ����������
  CurrentLanguage: string;

  IDS_ADD, IDS_CHANGE, IDS_REMOVE_CONFIRM, IDS_ABOUT, IDS_LAST_UPDATE: string;

  IDS_REMINDER, IDS_CURRENT_DAY_TYPE, IDS_EVERY_FEW_DAYS_TYPE, IDS_EVERY_FEW_DAYS_TYPE2,
  IDS_EVERY_MONTH_AND_DAY_TYPE, IDS_CURRENT_DAY_MONTH_TYPE: string;

  IDS_NOTIFICATION_DATE, IDS_LAST_NOTIFICATION_DATE, IDS_LEFT_DAYS, IDS_DAYS_HAVE_PASSED: string;

  IDS_NOTIFICATION_APP_NOT_FOUND, IDS_NEED_ENTER_REMINDER_TITLE, IDS_ADD_OLD_REMINDER: string;

const
  EveryFewDaysType = 'ED';      // ������ ��������� ����
  CurrentDayType = 'CD';        // ������������ ����
  EveryMonthAndDayType = 'EMD'; // ���� ������
  CurrentDayMonthType = 'EDM';  // ������������ ���� � ������������ �����

implementation

uses Unit2;

{$R *.dfm}

function GetNotificationAppPath: string;
var
  Reg: TRegistry;
begin
  Result:='';
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\r57zone\Notification', false) then begin
      Result:=Reg.ReadString('Path');
    Reg.CloseKey;
  end;
  Reg.Free;
end;

procedure SendNotfication(NotifyTitle, NotifyDescription: string);
begin
  if NotificationApp = '' then Exit;
  WinExec(PChar(NotificationApp + ' -t "' + NotifyTitle + '" -d "' + NotifyDescription + '" -b "Reminder.png" -c 2'), SW_SHOWNORMAL);
end;

procedure TMain.AddReminder(Reminder: TReminder);
begin
  SetLength(Reminders, Length(Reminders) + 1);
  Reminders[Length(Reminders) - 1].Name:=Reminder.Name;
  Reminders[Length(Reminders) - 1].RType:=Reminder.RType;
  Reminders[Length(Reminders) - 1].CountDays:=Reminder.CountDays;
  Reminders[Length(Reminders) - 1].Date:=Reminder.Date;
  Reminders[Length(Reminders) - 1].TimeSec:=Reminder.TimeSec;
  Reminders[Length(Reminders) - 1].LastNoticeDate:=Reminder.LastNoticeDate;
end;

procedure RemReminder(ReminderIndex: integer);
var
  i: integer;
begin
  if (ReminderIndex > -1) and (ReminderIndex <= Length(Reminders)) then begin
    for i:=ReminderIndex to Length(Reminders) - 2 do begin
      Reminders[i].Name:=Reminders[i + 1].Name;
      Reminders[i].RType:=Reminders[i + 1].RType;
      Reminders[i].CountDays:=Reminders[i + 1].CountDays;
      Reminders[i].Date:=Reminders[i + 1].Date;
      Reminders[i].TimeSec:=Reminders[i + 1].TimeSec;
      Reminders[i].LastNoticeDate:=Reminders[i + 1].LastNoticeDate;
    end;
    if Length(Reminders) > 0 then
        SetLength(Reminders, Length(Reminders) - 1);
  end;
end;

procedure TMain.LoadReminders(FileName: string);
var
  i: integer;
  ReminderStr: string;
  Reminder: TReminder;
  RemindersFile: TStringList;
begin
  RemindersFile:=TStringList.Create;
  RemindersFile.LoadFromFile(FileName);
  for i:=0 to RemindersFile.Count - 1 do begin
    ReminderStr:=RemindersFile.Strings[i];

    // ����
    Reminder.Date:=StrToDate(Copy(ReminderStr, 1, Pos(#9, ReminderStr) - 1));

    // �����
    Delete(ReminderStr, 1, Pos(#9, ReminderStr));
    Reminder.TimeSec:=SecondOfTheDay(StrToTime(Copy(ReminderStr, 1, Pos(#9, ReminderStr) - 1)));

    // ���
    Delete(ReminderStr, 1, Pos(#9, ReminderStr));
    Reminder.RType:=Copy(ReminderStr, 1, Pos(#9, ReminderStr) - 1);

    // ���������� ���� ��� ����������� ����� n ����
    Delete(ReminderStr, 1, Pos(#9, ReminderStr));
    Reminder.CountDays:=StrToIntDef( Copy(ReminderStr, 1, Pos(#9, ReminderStr) - 1), 0);

    // ���� ���������� ����������� �����������, ����� �� �������� ����������� ������ ���
    Delete(ReminderStr, 1, Pos(#9, ReminderStr));
    Reminder.LastNoticeDate:=Copy(ReminderStr, 1, Pos(#9, ReminderStr) - 1);

    // ��������
    Delete(ReminderStr, 1, Pos(#9, ReminderStr));
    Reminder.Name:=ReminderStr;

    AddReminder(Reminder);
  end;

  RemindersFile.Free;
end;

procedure TMain.SaveReminders;
var
  RemindersFile: TStringList; i: integer; TimeStr: string;
begin
  RemindersFile:=TStringList.Create;

  for i:=0 to Length(Reminders) - 1 do begin
    TimeStr:=FormatDateTime('hh:nn:ss', Reminders[i].TimeSec / SecsPerDay);
    RemindersFile.Add(DateToStr(Reminders[i].Date) + #9 + TimeStr + #9 + Reminders[i].RType + #9 + IntToStr(Reminders[i].CountDays) + #9 + Reminders[i].LastNoticeDate + #9 + Reminders[i].Name);
  end;

  RemindersFile.SaveToFile(DBFileName);
  RemindersFile.Free;
end;

function TMain.ReminderTypeToStr(TypeStr: string): string;
begin
  if TypeStr = CurrentDayType then
    Result:=IDS_CURRENT_DAY_TYPE;

  if Copy(TypeStr, 1, 3) = EveryFewDaysType + '=' then
    Result:=Format(IDS_EVERY_FEW_DAYS_TYPE, [Copy(TypeStr, 4, Length(TypeStr))]);

  if TypeStr = EveryMonthAndDayType then // ���� ������
    Result:=IDS_EVERY_MONTH_AND_DAY_TYPE;

  if TypeStr = CurrentDayMonthType then // ���� � �����
    Result:=IDS_CURRENT_DAY_MONTH_TYPE;
end;

procedure TMain.Check;
var
  i, RemindersCount: integer;
  RemoveReminder: boolean;
  ChangeReminders: boolean;
begin
  ChangeReminders:=false;
  for i:=Length(Reminders) - 1 downto 0 do begin

    RemoveReminder:=false; // ���������� �������� �����������

    // ���� (�������)
    if Reminders[i].RType = CurrentDayType then
      if DateTimeToUnix(Now) >= DateTimeToUnix(Reminders[i].Date) + Reminders[i].TimeSec then begin
        SendNotfication(IDS_REMINDER, Reminders[i].Name);
        RemoveReminder:=true; // ��������� ��������
        ChangeReminders:=true;
      end;

    if (Reminders[i].LastNoticeDate = DateToStr(Date)) then Continue; // ���� ����������� � ������� ���� ��� ����

    // ������ n ����
    if Reminders[i].RType = EveryFewDaysType then begin
      if (DaysBetween(Reminders[i].Date, Date) >= Reminders[i].CountDays) and (SecondOfTheDay(Time) > Reminders[i].TimeSec) then begin
        SendNotfication(IDS_REMINDER, Reminders[i].Name);
        Reminders[i].Date:=IncDay(Reminders[i].Date, Reminders[i].CountDays); // ��������� ���� ����������
        Reminders[i].LastNoticeDate:=DateToStr(Date); // ����������, ��� ��� �������� � ������� ����
        ChangeReminders:=true;
      end;

    // ���� ������
    end else if (Reminders[i].RType = EveryMonthAndDayType) and (SecondOfTheDay(Time) > Reminders[i].TimeSec) then begin
      if (DayOfTheMonth(Date) = DayOfTheMonth(Reminders[i].Date)) or
          // ���� ������� ���� ������, ��� � ���� ������ ����, �� ���������� � ���� ���� (����� ������)
         ( (DayOfTheMonth(Reminders[i].Date) > DayOfTheMonth(Date) ) and // ����������� ������ ������� ����
         (DayOfTheMonth(Date) = DaysInAMonth(YearOf(Date), MonthOf(Date)) )) // ���� ������� ���� ����� ���-�� ���� � ������

      then begin
        SendNotfication(IDS_REMINDER, Reminders[i].Name);
        Reminders[i].LastNoticeDate:=DateToStr(Date);
        ChangeReminders:=true;
      end;

    // ���� � �����
    end else if (Reminders[i].RType = CurrentDayMonthType) and (SecondOfTheDay(Time) > Reminders[i].TimeSec) then begin
      if (MonthOf(Date) = MonthOf(Reminders[i].Date)) and
         ( (DayOfTheMonth(Date) = DayOfTheMonth(Reminders[i].Date)) or
            (
              (DayOfTheMonth(Reminders[i].Date) > DayOfTheMonth(Date) ) and // ����������� ������ ������� ����
              (DayOfTheMonth(Date) = DaysInAMonth(YearOf(Date), MonthOf(Date)) ) // ���� ������� ���� ����� ���-�� ���� � ������
            )
         ) // ���� ������� ���� ������, ��� � ��� ������ ����, �� ���������� � ���� ���� (������ ������)
       then begin
        SendNotfication(IDS_REMINDER, Reminders[i].Name);
        Reminders[i].LastNoticeDate:=DateToStr(Date);
        ChangeReminders:=true;
      end;
    end;

    if (RemoveReminder) then // ���� ���������� �� �������� ����, �� ������� �������
      RemReminder(i);

  end;

  if ChangeReminders then begin
    SaveReminders;
    UpdateRemindersView;
  end;

end;

function GetLocaleInformation(Flag: Integer): string;
var
  pcLCA: array [0..20] of Char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, Flag, pcLCA, 19) <= 0 then
    pcLCA[0]:=#0;
  Result:=pcLCA;
end;

procedure Tray(ActInd: integer);  // 1 - ��������, 2 - ��������, 3 - �������
var
  NIM: TNotifyIconData;
begin
  with NIM do begin
    cbSize:=SizeOf(NIM);
    Wnd:=Main.Handle;
    uId:=1;
    uFlags:=NIF_MESSAGE or NIF_ICON or NIF_TIP;
    hIcon:=SendMessage(Application.Handle, WM_GETICON, ICON_SMALL2, 0);
    uCallBackMessage:=WM_USER + 1;
    StrCopy(szTip, PChar(Application.Title));
  end;
  case ActInd of
    1: Shell_NotifyIcon(NIM_ADD, @NIM);
    2: Shell_NotifyIcon(NIM_MODIFY, @NIM);
    3: Shell_NotifyIcon(NIM_DELETE, @NIM);
  end;
end;

procedure TMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile; i: integer;
begin
  WM_TASKBARCREATED:=RegisterWindowMessage('TaskbarCreated');
  AppHide;

  DBFileName:=ExtractFilePath(ParamStr(0)) + 'Reminders.txt';
  for i:=1 to ParamCount do
    if (LowerCase(ParamStr(i)) = '-db') and (Trim(ParamStr(i + 1)) <> '') then begin
      DBFileName:=ParamStr(i + 1);
      break;
    end;

  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini');
  AddDefaultTime:=StrToTime(Ini.ReadString('Main', 'DefaultTime', '13:00:00'));
  Ini.Free;

  CurrentLanguage:=GetLocaleInformation(LOCALE_SENGLANGUAGE);
  if CurrentLanguage <> 'Russian' then begin
    IDS_ADD:='Add';
    AddBtn.Caption:=IDS_ADD;
    IDS_CHANGE:='Change';
    ChangeBtn.Caption:=IDS_CHANGE;
    RemBtn.Caption:='Remove';
    IDS_REMOVE_CONFIRM:='Remove this reminder?' + #13#10#13#10 + 'Name: %s' + #13#10 + 'Type: %s' + #13#10 + 'Date and time: %s';

    Caption:='Reminders';
    ListView.Column[0].Caption:='Date';
    ListView.Column[1].Caption:='Time';
    ListView.Column[2].Caption:='Type';
    ListView.Column[3].Caption:='Reminder';

    IDS_REMINDER:='Reminder';
    IDS_CURRENT_DAY_TYPE:='Date';
    IDS_EVERY_FEW_DAYS_TYPE:='After %s day(s)';
    IDS_EVERY_MONTH_AND_DAY_TYPE:='Day of the month';
    IDS_CURRENT_DAY_MONTH_TYPE:='Day and month';

    IDS_NOTIFICATION_DATE:='Notification date';
    IDS_LAST_NOTIFICATION_DATE:='Last notification date';
    IDS_LEFT_DAYS:='Days left';
    IDS_DAYS_HAVE_PASSED:='Days have passed';

    IDS_ABOUT:='About...';
    IDS_LAST_UPDATE:='Last update:';
    AboutMenuBtn.Caption:=IDS_ABOUT;
    CloseMenuBtn.Caption:='Exit';
    ChangeMenuBtn.Caption:=IDS_CHANGE;
    MoveBtn.Caption:='Move';
    MoveUpBtn.Caption:='Up';
    MoveDownBtn.Caption:='Down';

    IDS_NOTIFICATION_APP_NOT_FOUND:='Notification app not found';
    IDS_NEED_ENTER_REMINDER_TITLE:='You must enter a reminder title';
    IDS_ADD_OLD_REMINDER:='Do you want to add an old reminder?';
  end else begin
    IDS_ADD:='��������';
    IDS_CHANGE:='��������';
    IDS_REMOVE_CONFIRM:='������� ��� �����������?' + #13#10#13#10 + '��������: %s' + #13#10 + '���: %s' + #13#10 + '���� � �����: %s';

    IDS_REMINDER:='�����������';
    IDS_CURRENT_DAY_TYPE:='����';
    IDS_EVERY_FEW_DAYS_TYPE:='����� %s ��.';
    IDS_EVERY_MONTH_AND_DAY_TYPE:='���� ������';
    IDS_CURRENT_DAY_MONTH_TYPE:='���� � �����';

    IDS_NOTIFICATION_DATE:='���� ����������';
    IDS_LAST_NOTIFICATION_DATE:='���� ���������� ����������';
    IDS_LEFT_DAYS:='�������� ����';
    IDS_DAYS_HAVE_PASSED:='������ ����';

    IDS_ABOUT:='� ���������...';
    IDS_LAST_UPDATE:='��������� ����������:';

    IDS_NOTIFICATION_APP_NOT_FOUND:='���������� ��� ����������� �� �������';
    IDS_NEED_ENTER_REMINDER_TITLE:='���������� ������ �������� �����������';
    IDS_ADD_OLD_REMINDER:='�� �������, ��� ������ �������� ������ �����������?';
  end;

  Application.Title:=Caption;
  Tray(1);

  NotificationApp:=GetNotificationAppPath;
  if NotificationApp = '' then Application.MessageBox(PChar(IDS_NOTIFICATION_APP_NOT_FOUND), PChar(Caption), MB_ICONWARNING);

  if FileExists(DBFileName) then begin
    LoadReminders(DBFileName);
    UpdateRemindersView;
  end;

  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
end;

procedure TMain.AddBtnClick(Sender: TObject);
begin
  AllowHide:=false;
  CurReminderIndex:=-1; // ���� -1 �� ����������, ���� ������, �� ���������
  AddDialog.Show;
  AddDialog.DayCountEdt.Text:='1';
  AddDialog.NofifyNameEdt.Text:='';
  AddDialog.ByDateRB.Checked:=true;
  AddDialog.DatePicker.Date:=Date;
  AddDialog.TimePicker.Time:=AddDefaultTime;
  AddDialog.DoneBtn.Caption:=IDS_ADD;
end;

procedure TMain.RemBtnClick(Sender: TObject);
begin
  AllowHide:=false;
  if (ListView.ItemIndex <> -1) and (MessageBox(Handle, PChar(Format(IDS_REMOVE_CONFIRM, [ListView.Items.Item[ListView.ItemIndex].SubItems[2], ListView.Items.Item[ListView.ItemIndex].SubItems[1], ListView.Items.Item[ListView.ItemIndex].Caption + ', ' + ListView.Items.Item[ListView.ItemIndex].SubItems[0] ])), PChar(IDS_REMINDER), 35) = 6) then begin
    RemReminder(ListView.ItemIndex);
    UpdateRemindersView;
    SaveReminders;
  end;
  AllowHide:=true;
end;

procedure TMain.AboutBtnClick(Sender: TObject);
begin
  AllowHide:=false;
  Application.MessageBox(PChar(Caption + ' 0.5.1' + #13#10 +
  IDS_LAST_UPDATE + ' 12.03.24' + #13#10 +
  'https://r57zone.github.io' + #13#10 +
  'r57zone@gmail.com'), PChar(IDS_ABOUT), MB_ICONINFORMATION);
  AllowHide:=true;
end;

procedure TMain.ListViewDblClick(Sender: TObject);
var
  Str: string; DayC: integer;
begin
  if ListView.ItemIndex = -1 then Exit;
  AllowHide:=false;

  Str:=#13#10 + IDS_NOTIFICATION_DATE + ': ' + DateToStr(Reminders[ListView.ItemIndex].Date);

  if Reminders[ListView.ItemIndex].RType = EveryFewDaysType then begin
    DayC:=Reminders[ListView.ItemIndex].CountDays;
    Str:=Str + #13#10 + IDS_LAST_NOTIFICATION_DATE + ': ' + DateToStr(IncDay(Reminders[ListView.ItemIndex].Date, DayC));
    Str:=Str + #13#10 + IDS_LEFT_DAYS + ': ' + IntToStr(DaysBetween( IncDay( Reminders[ListView.ItemIndex].Date, DayC ), Date ));

    Str:=Str + #13#10 + IDS_DAYS_HAVE_PASSED + ': ' + IntToStr(DaysBetween( Reminders[ListView.ItemIndex].Date , Date ));
  end else begin
    if Reminders[ListView.ItemIndex].Date > Date then
      Str:=Str + #13#10 + IDS_LEFT_DAYS + ': ' + IntToStr(DaysBetween( Reminders[ListView.ItemIndex].Date, Date ));
  end;

  Application.MessageBox(PChar(IDS_REMINDER + ':' + #13#10 + Reminders[ListView.ItemIndex].Name + #13#10 + Str), PChar(IDS_REMINDER), MB_ICONINFORMATION);
  AllowHide:=true;
end;

procedure TMain.UpdateRemindersView;
var
  i: integer;
begin
  ListView.Clear;
  for i:=0 to Length(Reminders) - 1 do begin
    ListView.AddItem(DateToStr(Reminders[i].Date), nil);
    ListView.Items.Item[ListView.Items.Count - 1].SubItems.Add( FormatDateTime('hh:nn:ss', Reminders[i].TimeSec / SecsPerDay) );
    if Reminders[i].RType <> EveryFewDaysType then
      ListView.Items.Item[ListView.Items.Count - 1].SubItems.Add( ReminderTypeToStr( Reminders[i].RType ) )
    else
      ListView.Items.Item[ListView.Items.Count - 1].SubItems.Add( ReminderTypeToStr( Reminders[i].RType + '=' + IntToStr(Reminders[i].CountDays)) );
    ListView.Items.Item[ListView.Items.Count - 1].SubItems.Add(Reminders[i].Name);
  end;
end;

procedure TMain.DefaultHandler(var Message);
begin
  if TMessage(Message).Msg = WM_TASKBARCREATED then
    Tray(1);
  inherited;
end;

procedure TMain.IconMouse(var Msg: TMessage);
begin
  case Msg.LParam of
    WM_LBUTTONDOWN: //WM_LBUTTONDBLCLK:
      begin
        // �������� PopupMenu, ���� �������
        PostMessage(Handle, WM_LBUTTONDOWN, MK_LBUTTON, 0);
        PostMessage(Handle, WM_LBUTTONUP, MK_LBUTTON, 0);

        if IsWindowVisible(Main.Handle) then AppHide else AppShow;
      end;

    WM_RBUTTONDOWN:
      PopupMenu1.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  end;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  TimerChecker.Enabled:=false;
  Tray(3);
  AllowClose:=true;
end;

procedure TMain.AppHide;
begin
  AllowClose:=true;
  ShowWindow(Handle, SW_HIDE);
end;

procedure TMain.AppShow;
begin
  AllowClose:=false;
  if Main.AlphaBlend then begin
    Main.AlphaBlendValue:=255;
    Main.AlphaBlend:=false;
  end;
  ShowWindow(Handle, SW_SHOW);
  SetForegroundWindow(Handle);
  if AddDialog.Showing then
    SetForegroundWindow(AddDialog.Handle);
end;

procedure TMain.CloseMenuBtnClick(Sender: TObject);
begin
  AllowClose:=true;
  Close;
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if AllowClose = false then CanClose:=false;
  AppHide;
end;

procedure TMain.ChangeMenuBtnClick(Sender: TObject);
begin
  ChangeBtn.Click;
end;

procedure TMain.TimerCheckerTimer(Sender: TObject);
begin
  Check;
end;

procedure TMain.MoveUpBtnClick(Sender: TObject);
var
  TempReminder: TReminder;
begin
  if ListView.ItemIndex > 0 then begin
    TempReminder:=Reminders[ListView.ItemIndex - 1];
    Reminders[ListView.ItemIndex - 1]:=Reminders[ListView.ItemIndex];
    Reminders[ListView.ItemIndex]:=TempReminder;
    UpdateRemindersView;
    SaveReminders;
  end;
end;

procedure TMain.MoveDownBtnClick(Sender: TObject);
var
  TempReminder: TReminder;
begin
  if (ListView.ItemIndex <> -1) and (ListView.ItemIndex < ListView.Items.Count - 1) then begin
    TempReminder:=Reminders[ListView.ItemIndex + 1];
    Reminders[ListView.ItemIndex + 1]:=Reminders[ListView.ItemIndex];
    Reminders[ListView.ItemIndex]:=TempReminder;
    UpdateRemindersView;
    SaveReminders;
  end;
end;

procedure TMain.ChangeBtnClick(Sender: TObject);
begin
  if ListView.ItemIndex = -1 then Exit;
  AllowHide:=false;
  CurReminderIndex:=ListView.ItemIndex; // ��� ���������
  AddDialog.Show;

  AddDialog.NofifyNameEdt.Text:=Reminders[CurReminderIndex].Name;
  AddDialog.DatePicker.Date:=Reminders[CurReminderIndex].Date;
  AddDialog.TimePicker.Time:=StrToTime(FormatDateTime('hh:nn:ss', Reminders[CurReminderIndex].TimeSec / SecsPerDay));

  if Reminders[CurReminderIndex].RType = CurrentDayType then
    AddDialog.ByDateRB.Checked:=true
  else if Reminders[CurReminderIndex].RType = EveryFewDaysType then begin
    AddDialog.EveryNdaysRB.Checked:=true;
    AddDialog.DayCountEdt.Text:=IntToStr(Reminders[CurReminderIndex].CountDays);
  end else if Reminders[CurReminderIndex].RType = EveryMonthAndDayType then
    AddDialog.DayOfTheMonthRB.Checked:=true
  else if Reminders[CurReminderIndex].RType = CurrentDayMonthType then
    AddDialog.DayAndMonthRB.Checked:=true;

  AddDialog.DoneBtn.Caption:=IDS_CHANGE;
end;

procedure TMain.AboutMenuBtnClick(Sender: TObject);
begin
  AboutBtn.Click;
end;

procedure TMain.WMActivate(var Msg: TMessage);
begin
  if (AllowHide) and (Msg.WParam = WA_INACTIVE) then
    AppHide;
  inherited;
end;

procedure TMain.ListViewKeyPress(Sender: TObject; var Key: Char);
begin
  if ListView.ItemIndex <> -1 then begin
    if Key = #13 then
      ListViewDblClick(Sender);
  end;
end;

end.
