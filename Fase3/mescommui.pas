unit mesCommUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm19 }

  TForm19 = class(TForm)
    addButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    mailEdit: TEdit;
    returnButton: TButton;
    procedure addButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure mailEditChange(Sender: TObject);
    procedure returnButtonClick(Sender: TObject);
  private

  public

  end;

var
  Form19: TForm19;

implementation
Uses Unit2, Unit1;
{$R *.lfm}

{ TForm19 }

procedure TForm19.mailEditChange(Sender: TObject);
begin
  if Form19.mailEdit.Text = '' then
     Form19.addButton.Enabled:=False
  else
     Form19.addButton.Enabled:=True;
end;

procedure TForm19.returnButtonClick(Sender: TObject);
begin
     Form19.Hide;
     Form2.Show;
end;

procedure TForm19.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm19.addButtonClick(Sender: TObject);
begin
   if Form1.communitiesTree.SearchByName(Form19.mailEdit.Text) <> nil then
    begin
      Form1.communitiesTree.SearchByName(Form19.mailEdit.Text).messList.messReport('reporte Mensajes_'+Form19.mailEdit.Text);
      ShowMessage('Reporte generado Exitosamente');
      Form19.mailEdit.Text:='';
    end
   else
     ShowMessage('No se encontro la comunidad');
end;

end.

