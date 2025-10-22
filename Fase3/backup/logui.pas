unit logUi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls;

type

  { TForm21 }

  TForm21 = class(TForm)
    exportButton: TButton;
    Label5: TLabel;
    ListView1: TListView;
    returnButton: TButton;
    procedure exportButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure returnButtonClick(Sender: TObject);
  private

  public
     procedure refreshList;
  end;

var
  Form21: TForm21;
  item: TlistItem;

implementation
Uses Unit1,Unit2,logclass;
{$R *.lfm}

{ TForm21 }

procedure TForm21.returnButtonClick(Sender: TObject);
begin
  Form21.Hide;
  Form2.Show;
end;

procedure TForm21.exportButtonClick(Sender: TObject);
begin
  Form1.logManager.ExportToJSON('Reporte de ingresos');
  ShowMessage('Archivo cargado correctamente');
end;

procedure TForm21.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm21.FormCreate(Sender: TObject);
begin
  listView1.ViewStyle:=  vsReport;

with listView1.Columns.Add do
  begin
    Caption := 'Usuario';
    AutoSize:= True;
  end;

with listView1.Columns.Add do
  begin
    Caption := 'Entrada';
    AutoSize:= True;
  end;

with listView1.Columns.Add do
  begin
    Caption := 'Salida';
    AutoSize:= True;
  end;
end;
procedure TForm21.refreshList;
var
  loged: Log;
  i: integer;
begin
  for loged in Form1.logManager.Logs do
  begin
    listView1.Items.Clear;
    item := listView1.Items.Add;
    item.Caption:= loged.usuario;
    item.SubItems.Add(loged.entrada);
    item.SubItems.Add(loged.salida);
    item.Data:= Pointer(i);
    Inc(i);
  end;

end;

end.
