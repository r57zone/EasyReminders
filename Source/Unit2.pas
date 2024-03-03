unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DateUtils;

type
  TAddDialog = class(TForm)
    DoneBtn: TButton;
    CancelBtn: TButton;
    DatePicker: TDateTimePicker;
    EveryNdaysRB: TRadioButton;
    DayCountEdt: TEdit;
    DayOfTheMonthRB: TRadioButton;
    DayAndMonthRB: TRadioButton;
    NofifyNameEdt: TEdit;
    ReminderLbl: TLabel;
    TimePicker: TDateTimePicker;
    ByDateRB: TRadioButton;
    SetNextDayBtn: TButton;
    SetCurTimeBtn: TButton;
    SetDayAddBtn: TButton;
    SetDaySubBtn: TButton;
    SetTimeSubBtn: TButton;
    SetTimeAddBtn: TButton;
    SetEveryDaySubBtn: TButton;
    SetEveryDayAddBtn: TButton;
    SetEveryDayWeekBtn: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure DoneBtnClick(Sender: TObject);
    procedure NofifyNameEdtKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DayCountEdtKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetNextDayBtnClick(Sender: TObject);
    procedure SetCurTimeBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SetDaySubBtnClick(Sender: TObject);
    procedure SetDayAddBtnClick(Sender: TObject);
    procedure SetTimeSubBtnClick(Sender: TObject);
    procedure SetTimeAddBtnClick(Sender: TObject);
    procedure SetEveryDaySubBtnClick(Sender: TObject);
    procedure SetEveryDayAddBtnClick(Sender: TObject);
    procedure SetEveryDayWeekBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddDialog: TAddDialog;

implementation

uses Unit1;

{$R *.dfm}

procedure TAddDialog.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TAddDialog.DoneBtnClick(Sender: TObject);
var
  RType: string; Reminder: TReminder;
begin
  if Trim(NofifyNameEdt.Text)='' then begin
    AllowHide:=false;
    Application.MessageBox(PChar(IDS_NEED_ENTER_REMINDER_TITLE), PChar(Main.Caption), MB_ICONWARNING);
    AllowHide:=true;
    Exit;
  end;

  if ByDateRB.Checked then
    RType:='CD';

  if EveryNdaysRB.Checked then
    RType:='ED'
  else
    DayCountEdt.Text:='0';

  if DayOfTheMonthRB.Checked then
    RType:='EMD';
  if DayAndMonthRB.Checked then
    RType:='EDM';

  Reminder.Name:=NofifyNameEdt.Text;
  Reminder.RType:=RType;
  Reminder.CountDays:=StrToIntDef(DayCountEdt.Text, 0);

  Reminder.Date:=StrToDateTime(DateToStr(DatePicker.Date) + '00:00:00'); // Если просто присвоить DatePicker.Date, то добавляет также время;

  Reminder.TimeSec:=SecondOfTheDay(TimePicker.Time);
  Reminder.LastNoticeDate:='00.00.0000';

  if CurReminderIndex = -1 then begin// Добавление

    if (ByDateRB.Checked) and (DateTimeToUnix(Now) >= DateTimeToUnix(Reminder.Date) + Reminder.TimeSec) then begin // Проверяем не забыли ли изменять месяц (только в режиме по конкретной дате)
      case MessageBox(Handle, PChar(IDS_ADD_OLD_REMINDER), PChar(Caption), 35) of
        6: Main.AddReminder(Reminder);
        7: Exit;
        2: Exit;
      end;
    end else
      Main.AddReminder(Reminder);

  end else //Изменение
    Reminders[CurReminderIndex]:=Reminder;

  Main.UpdateRemindersView;

  Main.SaveReminders;
  SetForegroundWindow(Main.Handle);
  Close;
end;

procedure TAddDialog.NofifyNameEdtKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Убираем баг скрытия контролов
  if Key = VK_MENU then
    Key:=0
  else if Key = VK_RETURN then
    DoneBtn.Click;
end;

procedure TAddDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Убираем баг скрытия контролов
  if Key = VK_MENU then
    Key:=0;
end;

procedure TAddDialog.DayCountEdtKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if DayCountEdt.Text = '0' then
    DayCountEdt.Clear;
end;

procedure TAddDialog.SetNextDayBtnClick(Sender: TObject);
begin
  DatePicker.Date:=IncDay(Date, 1);
end;

procedure TAddDialog.SetCurTimeBtnClick(Sender: TObject);
begin
  TimePicker.Time:=Time;
end;

procedure TAddDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AllowHide:=true;
end;

procedure TAddDialog.FormCreate(Sender: TObject);
begin
  SetWindowLong(DayCountEdt.Handle, GWL_STYLE, GetWindowLong(DayCountEdt.Handle, GWL_STYLE) or ES_NUMBER);
  Caption:=Main.ListView.Column[3].Caption;
  if CurrentLanguage <> 'Russian' then begin
    ByDateRB.Caption:='By date';
    SetNextDayBtn.Caption:='Tomorrow';
    SetCurTimeBtn.Caption:='Now';
    SetEveryDayWeekBtn.Caption:='Week';
    EveryNdaysRB.Caption:='Every (n) days';
    DayOfTheMonthRB.Caption:='Day of the month';
    DayAndMonthRB.Caption:='Day and month';
    ReminderLbl.Caption:='Notification title:';
    CancelBtn.Caption:='Cancel';
  end;
end;

procedure TAddDialog.SetDaySubBtnClick(Sender: TObject);
begin
  DatePicker.Date:=IncDay(DatePicker.Date, -1);
end;

procedure TAddDialog.SetDayAddBtnClick(Sender: TObject);
begin
  DatePicker.Date:=IncDay(DatePicker.Date, 1);
end;

procedure TAddDialog.SetTimeSubBtnClick(Sender: TObject);
begin
  TimePicker.Time:=IncHour(TimePicker.Time, -1);
end;

procedure TAddDialog.SetTimeAddBtnClick(Sender: TObject);
begin
  TimePicker.Time:=IncHour(TimePicker.Time, 1);
end;

procedure TAddDialog.SetEveryDaySubBtnClick(Sender: TObject);
begin
  if StrToIntDef(DayCountEdt.Text, 1) > 1 then
    DayCountEdt.Text:=IntToStr(StrToIntDef(DayCountEdt.Text, 1) - 1);
end;

procedure TAddDialog.SetEveryDayAddBtnClick(Sender: TObject);
begin
  DayCountEdt.Text:=IntToStr(StrToIntDef(DayCountEdt.Text, 1) + 1);
end;

procedure TAddDialog.SetEveryDayWeekBtnClick(Sender: TObject);
begin
  DayCountEdt.Text:='7';
end;

end.
