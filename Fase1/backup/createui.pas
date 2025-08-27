unit createUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm12 }

  TForm12 = class(TForm)
    createButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    mailEdit: TEdit;
    nameEdit: TEdit;
    returButton: TButton;
    telEdit: TEdit;
    passEdit: TEdit;
    userEdit: TEdit;
    procedure createButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure mailEditChange(Sender: TObject);
    procedure nameEditChange(Sender: TObject);
    procedure passEditChange(Sender: TObject);
    procedure telEditChange(Sender: TObject);
    procedure userEditChange(Sender: TObject);
  private

  public
    procedure validation;
    procedure setE;
  end;

var
  Form12: TForm12;

implementation
Uses Unit1,Unit3;
{$R *.lfm}

{ TForm12 }
procedure TForm12.setE;
begin
  Form12.mailEdit.Text:='';
  Form12.passEdit.Text:='';
  Form12.telEdit.Text:='';
  Form12.nameEdit.Text:='';
  Form12.userEdit.Text:='';
end;

procedure TForm12.validation;
begin
  Form12.createButton.Enabled:=(Trim(Form12.telEdit.Text)<>'')and(Trim(Form12.userEdit.Text)<>'')and(Trim(Form12.userEdit.Text)<>'')and(Trim(Form12.mailEdit.Text)<>'')and(Trim(Form12.passEdit.Text)<>'');
end;

procedure TForm12.nameEditChange(Sender: TObject);
begin
   Form12.validation;
end;

procedure TForm12.passEditChange(Sender: TObject);
begin
   Form12.validation;
end;

procedure TForm12.telEditChange(Sender: TObject);
begin
   Form12.validation;
end;

procedure TForm12.mailEditChange(Sender: TObject);
begin
   Form12.validation;
end;

procedure TForm12.createButtonClick(Sender: TObject);
var
  n: Integer;
begin

   if (TryStrToInt(Form12.telEdit.Text,n))  and (Form1.userList.idCount <> -1) then
   begin
       Form1.userList.add(User.create(Form1.userList.idCount,StrToInt(Form12.telEdit.Text),Form12.nameEdit.Text,Form12.userEdit.Text,Form12.passEdit.Text,Form12.mailEdit.Text));
       ShowMessage('Perfil Creado Correctamente ');
       Form12.Hide;
       Form1.Show;
   end
   else
     begin
       ShowMessage('Ingrese un numero de telefono valido');
       Exit;
     end;

end;

procedure TForm12.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm12.userEditChange(Sender: TObject);
begin
  Form12.validation;
end;

end.

