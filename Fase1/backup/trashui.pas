unit trashUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, stackL, Unit3, MessageClasss;

type

  { TForm5 }

  TForm5 = class(TForm)
    returnButton: TButton;
    deleteButton: TButton;
    findButton: TButton;
    findEdit: TEdit;
    Label1: TLabel;
    ListView1: TListView;
    procedure deleteButtonClick(Sender: TObject);
    procedure findButtonClick(Sender: TObject);
    procedure findEditChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure returnButtonClick(Sender: TObject);
  private
    tLogUser: User;
  public
    procedure refreshList(aListView1: TlistView);
    procedure  setUser(u: User);
  end;

var
  Form5: TForm5;
  node: KNode;
  item: TlistItem;
  messList: StackList;

implementation
Uses Unit4;
{$R *.lfm}

{ TForm5 }

procedure TForm5.setUser(u:User);
begin
  tLogUser := u;
  messList := tLogUser.trashList;
  Form5.refreshList(listView1);
end;


procedure TForm5.refreshList(aListView1: TlistView);
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
     Form5.findButton.Enabled := False;
     Form5.deleteButton.Enabled := False;
    end;
end;

procedure TForm5.FormCreate(Sender: TObject);
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

procedure TForm5.ListView1Click(Sender: TObject);
begin
    item := ListView1.Selected;
    if ListView1.Selected <> nil then
       Form5.deleteButton.Enabled := True;
end;

procedure TForm5.returnButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form5.Hide;
end;

procedure TForm5.findEditChange(Sender: TObject);
begin
  if Form5.findEdit.Text <> '' then
      Form5.findButton.Enabled := True
  else
    begin
      messList := tLogUser.trashList;
      Form5.refreshList(ListView1);
    end;
end;

procedure TForm5.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm5.findButtonClick(Sender: TObject);
begin
  messList := tLogUser.trashList.findBySubject(Form5.findEdit.Text);       // arreglar el metodo no filtra
  Form5.refreshList(ListView1);
end;

procedure TForm5.deleteButtonClick(Sender: TObject);
begin
  if (MessageDlg('Esta seguro de descartar el mensaje',mtWarning,[mbOk,mbCancel],0) = mrOk) then
    begin
      tLogUser.trashList.deleteById(Integer(ListView1.Selected.Data));
      ShowMessage('Mensaje Descartado');
      messList := tLogUser.trashList;
      Form5.findEdit.Text:='';
      Form5.refreshList(listView1);
    end;
end;

end.

