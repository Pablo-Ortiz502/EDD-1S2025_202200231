unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    loadButton: TButton;
    repUserB: TButton;
    repReB: TButton;
    exitButton: TButton;
    Root: TLabel;
    procedure exitButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  Form2: TForm2;

implementation
 uses Unit1;

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

end.

