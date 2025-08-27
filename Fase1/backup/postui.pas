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
    procedure FormClose(Sender: TObject);
    procedure returButtonClick(Sender: TObject);
    procedure telEditChange(Sender: TObject);
    procedure userEditChange(Sender: TObject);
  private
     logUser: User;
  public
     procedure  setUser(u: User);
     procedure refresh;
     procedure validation;
  end;

var
  Form7: TForm7;

implementation

 Uses
    Unit4, Unit1,MessageClasss;
{$R *.lfm}
procedure TForm7.validation;
begin
  Form7.editButton.Enabled:=(Trim(Form7.telEdit.Text)<>'')and(Trim(Form7.userEdit.Text)<>'');
end;

procedure TForm7.refresh;
begin
   Form7.nameEdit.Text := logUser.name;
   Form7.mailEdit.Text := LogUser.Email;
   Form7.telEdit.Text := IntToStr(logUser.tel);
   Form7.userEdit.Text := logUser.user;
   Form7.editButton.Enabled := False;
end;

procedure TForm7.returButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form7.Hide;
end;

procedure TForm7.telEditChange(Sender: TObject);
begin
  Form7.validation;
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
  logUser.user:= Form7.userEdit.Text;
  Form1.userList.post(logUser);
  Form7.refresh;
  ShowMessage('Perfil acualizado Correctamente');
end;

procedure TForm7.FormClose(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm7.userEditChange(Sender: TObject);
begin
   Form7.validation;
end;

 procedure  TForm7.setUser(u: User);
 begin
   logUser := u;
   Form7.refresh;
 end;

end.

