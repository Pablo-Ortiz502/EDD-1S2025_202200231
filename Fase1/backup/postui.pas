unit postUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Unit3;

type

  { TForm7 }

  TForm7 = class(TForm)
    returButton: TButton;
    nameEdit: TEdit;
    editButton: TButton;
    userEdit: TEdit;
    mailEdit: TEdit;
    telEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure editButtonClick(Sender: TObject);
    procedure mailEditChange(Sender: TObject);
    procedure nameEditChange(Sender: TObject);
    procedure returButtonClick(Sender: TObject);
    procedure telEditChange(Sender: TObject);
    procedure userEditChange(Sender: TObject);
  private
     logUser: User;
  public
     procedure  setUser(u: User);
     procedure refresh;
  end;

var
  Form7: TForm7;

implementation

 Uses
   circularL, Unit4;
{$R *.lfm}
procedure TForm7.refresh;
begin
   Form7.nameEdit.Text := logUser.name;
   Form7.mailEdit.Text := LogUser.Email;
   Form7.telEdit.Text := IntToStr(logUser.tel);
   Form7.userEdit.Text := logUser.user;
   Form7.editButton.Enabled := False;
   Form7.editButton.Enabled := False;
end;

procedure TForm7.nameEditChange(Sender: TObject);
begin

   if Form7.nameEdit.Text <> '' then
     Form7.editButton.Enabled := True
   else
     Form7.editButton.Enabled := False;

end;

procedure TForm7.returButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form7.Close;
end;

procedure TForm7.telEditChange(Sender: TObject);
begin

   if Form7.telEdit.Text <> '' then
     Form7.editButton.Enabled := True
   else
     Form7.editButton.Enabled := False;

end;

procedure TForm7.mailEditChange(Sender: TObject);
begin

   if Form7.mailEdit.Text <> '' then
     Form7.editButton.Enabled := True
   else
     Form7.editButton.Enabled := False;

end;

procedure TForm7.editButtonClick(Sender: TObject);
var
  n: Integer;
begin

   if TryStrToInt(Form7.telEdit.Text,n) then
     logUser.tel := StrToInt(Form7.telEdit.Text)
   else
     begin
       ShowMessage('Ingrese un numero de telefono valido');
       Exit;
     end;
  logUser.name:= Form7.nameEdit.Text;
  logUser.user:= Form7.userEdit.Text;
  logUser.Email:=Form7.mailEdit.Text;
  Form7.refresh;
  ShowMessage('Perfil acualizado Correctamente');
end;

procedure TForm7.userEditChange(Sender: TObject);
begin

   if Form7.userEdit.Text <> '' then
     Form7.editButton.Enabled := True
   else
     Form7.editButton.Enabled := False;

end;

 procedure  TForm7.setUser(u: User);
 begin
   logUser := u;
   Form7.refresh;
 end;

end.

