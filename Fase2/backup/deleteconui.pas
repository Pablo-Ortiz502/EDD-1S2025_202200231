unit deleteConUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,Unit3,circularL;

type

  { TForm17 }

  TForm17 = class(TForm)
    addButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    mailEdit: TEdit;
    returnButton: TButton;
    procedure addButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure returnButtonClick(Sender: TObject);
  private
    logUser: User;
  public
    procedure  setUser(u: User);
  end;

var
  Form17: TForm17;

implementation
Uses Unit1,Unit4;
{$R *.lfm}

{ TForm17 }

procedure TForm17.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   Application.Terminate;
end;

procedure TForm17.addButtonClick(Sender: TObject);
var
  us: User;
begin
   if logUser.Email =  Form17.mailEdit.Text then
    begin
     ShowMessage('No se permite ser su propio contacto');
     Form17.mailEdit.Text:='';
     Exit;
    end;

    us := Form1.userList.findEmail(Form17.mailEdit.Text);

    if us <> nil then
      begin
       if logUser.conTree.FindById(us.id) <> nil then
         begin
           logUser.conTree.Delete(us.id);
           us.conTree.Delete(logUser.id);
           ShowMessage('Contacto Eliminado');
           Form17.mailEdit.Text:='';
         end
       else
          ShowMessage('Contacto NO existe');
      end
    else
     begin
      ShowMessage('No se encontro el usuario');
     end;

end;

procedure TForm17.returnButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form17.Hide;
end;

procedure TForm17.setUser(u: User);
begin
   logUser := u;
   Form17.mailEdit.Text:='';
end;

end.

