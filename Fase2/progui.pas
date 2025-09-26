unit progUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,Unit3,
  DateTimePicker;

type

  { TForm10 }

  TForm10 = class(TForm)
    datePicker: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    messMemo: TMemo;
    reciverEdit: TEdit;
    returnButton: TButton;
    sendButton: TButton;
    subjectEdit: TEdit;
    procedure messMemoChange(Sender: TObject);
    procedure reciverEditChange(Sender: TObject);
    procedure returnButtonClick(Sender: TObject);
    procedure sendButtonClick(Sender: TObject);
    procedure subjectEditChange(Sender: TObject);
  private
      logUser: User;
  public
      procedure setUser(u:User);
      procedure refresh;
      procedure validation;
  end;

var
  Form10: TForm10;

implementation
Uses circularL,MessageClasss,Unit4;
{$R *.lfm}

procedure TForm10.reciverEditChange(Sender: TObject);
begin
   Form10.validation;
end;

procedure TForm10.returnButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form10.Hide;
end;

procedure TForm10.sendButtonClick(Sender: TObject);
var
  re: Contact;
  dateA: string;
begin
   re := logUser.contactList.findEmail(Form10.reciverEdit.Text);
   if re <> nil then
   begin
      dateA := FormatDateTime('dd/mm/yyyy',Form10.datePicker.Date);
      logUser.programList.add(Message.create(dateA,re.Email,Form10.subjectEdit.Text,Form10.messMemo.Text,False));
      Form10.refresh;
      ShowMessage('Mensaje Programado con exito');
   end
   else
     ShowMessage('NO se encontro el contacto');
end;

procedure TForm10.messMemoChange(Sender: TObject);
begin
   Form10.validation;
end;

procedure TForm10.subjectEditChange(Sender: TObject);
begin
   Form10.validation;
end;

procedure  TForm10.setUser(u: User);
begin
  logUser := u;
  Form10.datePicker.MinDate := Date;
  Form10.datePicker.Date:= Date;
  Form10.refresh;
end;

procedure TForm10.refresh;
begin
  Form10.reciverEdit.Text:='';
  Form10.subjectEdit.Text:='';
  Form10.messMemo.Text:='';
  Form10.sendButton.Enabled:= False;
end;
procedure TForm10.validation;
begin
  Form10.sendButton.Enabled:=(Trim(Form10.subjectEdit.Text)<>'')and(Trim(Form10.reciverEdit.Text)<>'')and(Trim(Form10.messMemo.Text)<>'');
end;

end.

