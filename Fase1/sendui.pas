unit sendUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Unit3,circularL,MessageClasss;

type

  { TForm9 }

  TForm9 = class(TForm)
    returnButton: TButton;
    sendButton: TButton;
    reciverEdit: TEdit;
    subjectEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    messMemo: TMemo;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
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
  Form9: TForm9;

implementation
Uses Unit1,Unit4;
{$R *.lfm}

procedure TForm9.reciverEditChange(Sender: TObject);
begin
  Form9.validation;
end;

procedure TForm9.returnButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form9.Hide;
end;

procedure TForm9.sendButtonClick(Sender: TObject);
var
  re: Contact;
  dateA: string;
begin
   re := logUser.contactList.findEmail(Form9.reciverEdit.Text);
   if re <> nil then
   begin
      dateA := FormatDateTime('dd/mm/yyyy  hh:nn',Now);
      Form1.userList.findEmail(re.Email).messListU.add(Message.create(dateA,logUser.Email,Form9.subjectEdit.Text,Form9.messMemo.Text,False));
      Form9.refresh;
      ShowMessage('Mensaje enviado con exito');
   end
   else
     ShowMessage('NO se encontro el contacto');
end;

procedure TForm9.messMemoChange(Sender: TObject);
begin
  Form9.validation;
end;

procedure TForm9.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm9.subjectEditChange(Sender: TObject);
begin
  Form9.validation;
end;

{ TForm9 }
procedure  TForm9.setUser(u: User);
begin
  logUser := u;
  Form9.refresh;
end;

procedure TForm9.refresh;
begin
  Form9.reciverEdit.Text:='';
  Form9.subjectEdit.Text:='';
  Form9.messMemo.Text:='';
  Form9.sendButton.Enabled:=False;
end;

procedure TForm9.validation;
begin
  Form9.sendButton.Enabled:=(Trim(Form9.subjectEdit.Text)<>'')and(Trim(Form9.reciverEdit.Text)<>'')and(Trim(Form9.messMemo.Text)<>'');
end;

end.

