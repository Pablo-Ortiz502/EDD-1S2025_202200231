unit programedUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls, Unit3,queuL;

type

  { TForm11 }

  TForm11 = class(TForm)
    Label1: TLabel;
    sendButton: TButton;
    ListView1: TListView;
    returnButton: TButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure returnButtonClick(Sender: TObject);
    procedure sendButtonClick(Sender: TObject);
  private
     logUser: User;
  public
     procedure setUser(u:User);
     procedure refresh;
  end;

var
  Form11: TForm11;
  item: TlistItem;
  node: kNode;

implementation

Uses Unit1,MessageClasss,circularL,Unit4;
{$R *.lfm}

procedure TForm11.setUSer(u:User);
begin
  logUSer := u;
  Form11.refresh;
end;

{ TForm11 }

procedure TForm11.FormCreate(Sender: TObject);
begin
  listView1.ViewStyle:=  vsReport;

with listView1.Columns.Add do
  begin
    Caption := 'Receptor';
    AutoSize:= True;
  end;

with listView1.Columns.Add do
  begin
    Caption := 'Asunto';
    AutoSize:= True;
  end;

with listView1.Columns.Add do
  begin
    Caption := 'Fecha';
    AutoSize:= True;
  end;
end;

procedure TForm11.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm11.ListView1Click(Sender: TObject);
begin
  item := ListView1.Selected;
    if ListView1.Selected <> nil then
       Form11.sendButton.Enabled := True;
end;

procedure TForm11.returnButtonClick(Sender: TObject);
begin
  Form11.Hide;
  Form3.SHow;
end;

procedure TForm11.sendButtonClick(Sender: TObject);
var
  re: Contact;
  dateA: string;
  me: Message;
begin
   re := logUser.contactList.findEmail(item.Caption);
   me := logUser.programList.findById(Integer(ListView1.Selected.Data));
   if re <> nil then
   begin
      dateA := FormatDateTime('dd/mm/yy  hh:nn',Now);
      Form1.userList.findEmail(re.Email).messListU.add(Message.create(dateA,logUser.Email,me.subject,me.message,False));
      logUser.programList.removeById(Integer(ListView1.Selected.Data));
      Form11.refresh;
      ShowMessage('Mensaje enviado con exito');

   end;
end;

procedure TForm11.refresh;
begin
  Form11.ListView1.Items.Clear;
  if logUser.programList.aHead <> nil then
  begin
    node := logUser.programList.aHead;
    while node <> nil do
      begin
         item := Form11.ListView1.Items.Add;
         item.Caption:= node^.data.sender;
         item.SubItems.Add(node^.data.subject);
         item.SubItems.Add(node^.data.date);
         item.Data:= Pointer(node^.data.id);
         node := node^.next;
      end;
     Form11.sendButton.Enabled := False;
    end;
end;

end.

