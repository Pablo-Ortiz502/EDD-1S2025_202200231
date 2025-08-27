unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    loadButton: TButton;
    OpenDialog1: TOpenDialog;
    repUserB: TButton;
    repReB: TButton;
    exitButton: TButton;
    Root: TLabel;
    procedure exitButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure loadButtonClick(Sender: TObject);
    procedure repUserBClick(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation
 uses Unit1, userLoad;

{$R *.lfm}

 { TForm2 }

 procedure TForm2.exitButtonClick(Sender: TObject);
 begin
   Form1.userEdit.Text := '';
   Form1.passEdit.Text := '';
   Form1.Show;
   Form2.Hide;
 end;

procedure TForm2.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   Application.Terminate;
end;

procedure TForm2.loadButtonClick(Sender: TObject);

begin
  Form2.OpenDialog1.Filter:='JSON File|*.json|all|*.*';
  if Form2.OpenDialog1.Execute then
  begin
    UserLoader.readFile(Form2.OpenDialog1.FileName,Form1.userList);
    ShowMessage('Archivo cargado correctamente')
  end;

end;

procedure TForm2.repUserBClick(Sender: TObject);
begin
  Form1.userList.userReport('Users_report','Users_report');
  ShowMessage('Reportes creados')
end;

end.

