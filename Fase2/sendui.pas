unit sendUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Unit3,circularL,MessageClasss;

type

  { TForm9 }

  TForm9 = class(TForm)
    protoButton: TButton;
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
    procedure protoButtonClick(Sender: TObject);
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
Uses Unit1,Unit4,matrix,BTSTreeC;
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
  r: mNode;
  i:Integer;
  m: Message;
  u: User;
begin
   u := Form1.userList.findEmail(Form9.reciverEdit.Text);
   re := logUser.conTree.FindById(u.id);
   if re <> nil then
   begin
      dateA := FormatDateTime('dd/mm/yyyy  hh:nn',Now);
      m := Message.create(dateA,logUser.Email,Form9.subjectEdit.Text,Form9.messMemo.Text,False);
      m.id:= Form1.userList.findEmail(re.Email).messTree.countT;
      Form1.userList.findEmail(re.Email).messTree.Insert(m);
      Inc(Form1.userList.findEmail(re.Email).messTree.countT);
      r := Form1.relations.FindNode(logUser.id,re.id);
      i := r^.value;
      Inc(i);
      r^.value := i;
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

procedure TForm9.protoButtonClick(Sender: TObject);
var
  re: Contact;
  dateA: string;
  m: Message;
  u: User;
begin
if (MessageDlg('Esta seguro de Enviar a Borradores',mtWarning,[mbOk,mbCancel],0) = mrOk) then
begin
   u := Form1.userList.findEmail(Form9.reciverEdit.Text);
   if u<> nil then
    re := logUser.conTree.FindById(u.id)
   else
     re := nil;
   if re <> nil then
   begin
      dateA := FormatDateTime('dd/mm/yyyy  hh:nn',Now);
      m := Message.create(dateA,re.Email,Form9.subjectEdit.Text,Form9.messMemo.Text,False);
      m.id:= LogUSer.protoTree.countT;
      LogUser.protoTree.Insert(m);
      Inc(LogUser.protoTree.countT);
      Form9.refresh;
      ShowMessage('Mensaje enviado a Borradores');
   end
   else
     ShowMessage('NO se encontro el contacto');
end;



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
var
  b: Boolean;
begin
  b := (Trim(Form9.subjectEdit.Text)<>'')and(Trim(Form9.reciverEdit.Text)<>'')and(Trim(Form9.messMemo.Text)<>'');
  Form9.sendButton.Enabled:= b;
  Form9.protoButton.Enabled:=b;
end;

end.

