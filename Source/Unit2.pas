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
    SetCurDayBtn: TButton;
    SetCurTimeBtn: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure DoneBtnClick(Sender: TObject);
    procedure NofifyNameEdtKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DayCountEdtKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetCurDayBtnClick(Sender: TObject);
    procedure SetCurTimeBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
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

    if DateTimeToUnix(Now) >= DateTimeToUnix(Reminder.Date) + Reminder.TimeSec then begin // Проверяем не забыли ли изменять месяц
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

procedure TAddDialog.SetCurDayBtnClick(Sender: TObject);
begin
  DatePicker.Date:=Date;
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
  Caption:=Main.ListView.Column[3].Caption;
  if CurrentLanguage <> 'Russian' then begin
    ByDateRB.Caption:='By date';
    SetCurDayBtn.Caption:='Today';
    SetCurTimeBtn.Caption:='Now';
    EveryNdaysRB.Caption:='Every (n) days';
    DayOfTheMonthRB.Caption:='Day of the month';
    DayAndMonthRB.Caption:='Day and month';
    ReminderLbl.Caption:='Notification title:';
    CancelBtn.Caption:='Cancel';
  end;
end;

end.
