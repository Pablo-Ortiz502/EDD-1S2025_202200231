unit Unit6;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, Unit3, Unit5, MessageClasss;

type

  { TForm4 }

  TForm4 = class(TForm)
    discardButton: TButton;
    returnButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    messageMemo: TMemo;
    senderLabel: TLabel;
    ListView1: TListView;
    dateLabel: TLabel;
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
  Form4: TForm4;
  messList: DoubleList;
  node: DNode;
  item: TlistItem;
  i: Integer;

implementation

Uses Unit4;
{$R *.lfm}

{ TForm4 }

procedure TForm4.setUser(u:User);
begin
  bLogUser := u;
  messList := bLogUser.messListU;
  Form4.refreshList(listView1);
end;

procedure TForm4.refreshList(aListView1: TlistView);
begin

  aListView1.Items.Clear;

  if messList.aHead <> nil then
  begin
    node := messList.aHead;
    while node <> nil do
      begin
         item := aListView1.Items.Add;
         item.Caption:= node^.data.sender;
         if node^.data.stateR then
           item.SubItems.Add('L')
         else
           item.SubItems.Add('NL');
         item.SubItems.Add(node^.data.subject);
         item.SubItems.Add(node^.data.date);
         item.Data:= Pointer(node^.data.id);
         node := node^.next;
      end;
     Form4.subjecLabel.Caption :='';
     Form4.dateLabel.Caption := '';
     Form4.messageMemo.Text := '';
     Form4.senderLabel.Caption := '';
     Form4.discardButton.Enabled:=False;
    end;
end;


procedure TForm4.FormCreate(Sender: TObject);
begin
    listView1.ViewStyle:=  vsReport;

    with listView1.Columns.Add do
      begin
        Caption := 'Emisario';
        AutoSize:= True;
      end;

    with listView1.Columns.Add do
      begin
        Caption := 'Estado';
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

procedure TForm4.discardButtonClick(Sender: TObject);
begin
  if (MessageDlg('Esta seguro de descartar el mensaje',mtWarning,[mbOk,mbCancel],0) = mrOk) then
    begin
    messList.deleteItem(i,bLogUser.trashList);
    ShowMessage('Mensaje Descartado');
    Form4.refreshList(listView1);
    end;
end;

procedure TForm4.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm4.ListView1Click(Sender: TObject);
var
  mess: Message;
begin
     item := ListView1.Selected;
  if ListView1.Selected <> nil then
    begin
    i := Integer(ListView1.Selected.Data);
    discardButton.Enabled:=True;
    mess := messList.findById(Integer(ListView1.Selected.Data));
    messageMemo.Text := mess.message;
    subjecLabel.Caption := mess.subject;
    senderLabel.Caption := mess.sender;
    dateLabel.Caption := mess.date;
    mess.stateR:= True;
    item.SubItems[0] := 'L';
    end;
end;

procedure TForm4.returnButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form4.Hide;
end;


end.

