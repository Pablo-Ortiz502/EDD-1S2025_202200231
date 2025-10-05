unit favUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls, Unit3, Unit5, MessageClasss;

type

  { TForm16 }

  TForm16 = class(TForm)
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
  Form16: TForm16;
  messList: DoubleList;
  node: DNode;
  item: TlistItem;
  i: Integer;

implementation
Uses Unit4;
{$R *.lfm}

procedure TForm16.FormCreate(Sender: TObject);
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

procedure TForm16.ListView1Click(Sender: TObject);
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

procedure TForm16.returnButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form16.Hide;
end;

procedure TForm16.discardButtonClick(Sender: TObject);
begin
    if (MessageDlg('Esta seguro de Eliminar el mensaje de favoritos',mtWarning,[mbOk,mbCancel],0) = mrOk) then
    begin
    bLogUser.favTree.Delete(i);
    messList := bLogUser.favTree.ToDoubleList();
    ShowMessage('Mensaje Descartado');
    Form16.refreshList(listView1);
    Form16.subjecLabel.Caption :='';
    Form16.dateLabel.Caption := '';
    Form16.messageMemo.Text := '';
    Form16.senderLabel.Caption := '';
    Form16.discardButton.Enabled:=False;
    end;
end;

procedure TForm16.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    Application.Terminate;
end;

procedure TForm16.refreshList(aListView1: TlistView);
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
     Form16.subjecLabel.Caption :='';
     Form16.dateLabel.Caption := '';
     Form16.messageMemo.Text := '';
     Form16.senderLabel.Caption := '';
     Form16.discardButton.Enabled:=False;
    end;
end;

procedure TForm16.setUser(u: User);
begin
  bLogUser := u;
  messList := bLogUser.favTree.ToDoubleList();
  Form16.messageMemo.Text:='';
  Form16.refreshList(listView1);
  Form16.subjecLabel.Caption :='';
  Form16.dateLabel.Caption := '';
  Form16.messageMemo.Text := '';
  Form16.senderLabel.Caption := '';
  Form16.discardButton.Enabled:=False;
end;

end.

