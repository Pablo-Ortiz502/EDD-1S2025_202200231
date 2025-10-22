unit privUi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls, Unit3, Unit5, MessageClasss;

type

  { TForm20 }

  TForm20 = class(TForm)
    dateLabel: TLabel;
    discardButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListView1: TListView;
    messageMemo: TMemo;
    returnButton: TButton;
    senderLabel: TLabel;
    subjecLabel: TLabel;
    procedure discardButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure returnButtonClick(Sender: TObject);
  private
      bLogUser: User;
  public
      procedure refreshList(aListView1: TlistView);
      procedure  setUser(u: User);
  end;

var
  Form20: TForm20;
  messList: DoubleList;
  node: DNode;
  item: TlistItem;
  i: Integer;

implementation
Uses Unit4;
{$R *.lfm}

procedure TForm20.FormCreate(Sender: TObject);
begin
      listView1.ViewStyle:=  vsReport;

    with listView1.Columns.Add do
      begin
        Caption := 'Emisario';
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

procedure TForm20.ListView1Click(Sender: TObject);
var
  mess: Message;
begin
     item := ListView1.Selected;
  if ListView1.Selected <> nil then
    begin
    i := Integer(ListView1.Selected.Data);
    discardButton.Enabled:=True;
    mess := messList.findById(i);
    messageMemo.Text := mess.message;
    subjecLabel.Caption := mess.subject;
    senderLabel.Caption := mess.sender;
    dateLabel.Caption := mess.date;
    end;
end;

procedure TForm20.returnButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form20.Hide;
end;

procedure TForm20.discardButtonClick(Sender: TObject);
begin
    if (MessageDlg('Esta seguro de Eliminar el mensaje de favoritos',mtWarning,[mbOk,mbCancel],0) = mrOk) then
    begin
    bLogUser.favTree.Delete(i);
    messList := bLogUser.favTree.ToDoubleList();
    ShowMessage('Mensaje Descartado');
    Form20.refreshList(listView1);
    Form20.subjecLabel.Caption :='';
    Form20.dateLabel.Caption := '';
    Form20.messageMemo.Text := '';
    Form20.senderLabel.Caption := '';
    Form20.discardButton.Enabled:=False;
    end;
end;

procedure TForm20.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    Application.Terminate;
end;

procedure TForm20.refreshList(aListView1: TlistView);
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
         item.SubItems.Add(node^.data.date);
         item.Data:= Pointer(node^.data.id);
         node := node^.next;
      end;
     Form20.subjecLabel.Caption :='';
     Form20.dateLabel.Caption := '';
     Form20.messageMemo.Text := '';
     Form20.senderLabel.Caption := '';
     Form20.discardButton.Enabled:=False;
    end;
end;

procedure TForm20.setUser(u: User);
begin
  bLogUser := u;
  messList := bLogUser.favTree.ToDoubleList();
  Form20.messageMemo.Text:='';
  Form20.refreshList(listView1);
  Form20.subjecLabel.Caption :='';
  Form20.dateLabel.Caption := '';
  Form20.messageMemo.Text := '';
  Form20.senderLabel.Caption := '';
  Form20.discardButton.Enabled:=False;
end;

end.

