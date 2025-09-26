unit prototypeUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,Unit3,Unit5, MessageClasss,avlTree;

type

  { TForm15 }

  TForm15 = class(TForm)
    deleteButton: TButton;
    messMemo: TMemo;
    sendButton: TButton;
    subjectEdit: TEdit;
    inButton: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListView1: TListView;
    postButton: TButton;
    preButton: TButton;
    returnButton: TButton;
    procedure deleteButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure inButtonClick(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure postButtonClick(Sender: TObject);
    procedure preButtonClick(Sender: TObject);
    procedure returnButtonClick(Sender: TObject);
    procedure sendButtonClick(Sender: TObject);
  private
    bLogUser: User;
  public
    procedure refreshList(aListView1: TlistView);
    procedure  setUser(u: User);
  end;

var
  Form15: TForm15;
  messList: DoubleList;
  node: DNode;
  item: TlistItem;
  i: Integer;

implementation
uses Unit1,circularL,Unit4,matrix;
{$R *.lfm}

procedure TForm15.setUser(u:User);
begin
  bLogUser := u;
  messList := bLogUser.protoTree.InOrderList;
  Form15.messMemo.Text:='';
  Form15.refreshList(listView1);
  Form15.subjectEdit.Text:='';
  Form15.messMemo.Enabled:=False;
  Form15.subjectEdit.Enabled:=False;
  Form15.sendButton.Enabled:=False;
  deleteButton.Enabled:=False;
end;

procedure TForm15.FormCreate(Sender: TObject);
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

end;

procedure TForm15.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm15.deleteButtonClick(Sender: TObject);
begin
  if (MessageDlg('Esta seguro de descartar el mensaje',mtWarning,[mbOk,mbCancel],0) = mrOk) then
    begin
        bLogUser.protoTree.Delete(i);
        messList := blogUser.protoTree.InOrderList();
        Form15.refreshList(listView1);
    end;

end;

procedure TForm15.inButtonClick(Sender: TObject);
begin
  messList := bLogUser.protoTree.InOrderList();
  Form15.refreshList(listView1);
end;

procedure TForm15.ListView1Click(Sender: TObject);
var
  mess: Message;
begin
     item := ListView1.Selected;
     if ListView1.Selected <> nil then
     begin
        i := Integer(ListView1.Selected.Data);
        sendButton.Enabled:=True;
        mess := messList.findById(i);
        messMemo.Text := mess.message;
        subjectEdit.Text:=mess.subject;
        deleteButton.Enabled:=True;
        messMemo.Enabled:=True;
        subjectEdit.Enabled:=True;
     end;
end;

procedure TForm15.postButtonClick(Sender: TObject);
begin
  messList := bLogUser.protoTree.PostOrderList();
  Form15.refreshList(listView1);
end;

procedure TForm15.preButtonClick(Sender: TObject);
begin
  messList := bLogUser.protoTree.PreOrderList();
  Form15.refreshList(listView1);
end;

procedure TForm15.returnButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form15.Hide;
end;

procedure TForm15.sendButtonClick(Sender: TObject);
var
  re: Contact;
  dateA: string;
  r: mNode;
  k: Integer;
  m : message;
begin
   re := blogUser.contactList.findEmail(item.Caption);
   if re <> nil then
   begin
      dateA := FormatDateTime('dd/mm/yyyy  hh:nn',Now);
      m :=  Message.create(dateA,blogUser.Email,subjectEdit.Text,messMemo.Text,False);
      m.id:= Form1.userList.findEmail(re.Email).messTree.countT;
      Form1.userList.findEmail(re.Email).messTree.Insert(m);
      Inc(Form1.userList.findEmail(re.Email).messTree.countT);

      blogUser.protoTree.Delete(i);
      messList := blogUser.protoTree.InOrderList();
      r := Form1.relations.FindNode(blogUser.id,re.id);
      k := r^.value;
      Inc(k);
      r^.value := k;
      Form15.messMemo.Text:='';
      Form15.refreshList(listView1);
      Form15.subjectEdit.Text:='';
      Form15.messMemo.Enabled:=False;
      Form15.subjectEdit.Enabled:=False;
      Form15.sendButton.Enabled:=False;
      deleteButton.Enabled:=False;
      Form15.refreshList(listView1);
      ShowMessage('Mensaje enviado con exito');
   end;
end;

procedure TForm15.refreshList(aListView1: TlistView);
begin

  aListView1.Items.Clear;

  if messList.aHead <> nil then
  begin
    node := messList.aHead;
    while node <> nil do
      begin
         item := aListView1.Items.Add;
         item.Caption:= node^.data.sender;
         item.SubItems.Add(node^.data.subject);
         item.Data:= Pointer(node^.data.id);
         node := node^.next;
      end;
     Form15.subjectEdit.Text:='';
     Form15.messMemo.Text := '';
     Form15.sendButton.Enabled:=False;
     messMemo.Enabled:=False;
     subjectEdit.Enabled:=False;
     deleteButton.Enabled:=False;
    end;
end;



end.

