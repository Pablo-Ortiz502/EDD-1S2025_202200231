unit addCon;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,Unit3, circularL;

type

  { TForm6 }

  TForm6 = class(TForm)
    addButton: TButton;
    mailEdit: TEdit;
    returnButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure addButtonClick(Sender: TObject);
    procedure mailEditChange(Sender: TObject);
    procedure returnButtonClick(Sender: TObject);
  private
     logUser: User;
  public
     procedure  setUser(u: User);
  end;

var
  Form6: TForm6;

implementation
Uses Unit1,Unit4;
{$R *.lfm}

procedure TForm6.mailEditChange(Sender: TObject);
begin
   if Form6.mailEdit.Text <> '' then
      Form6.addButton.Enabled := True
   else
     Form6.addButton.Enabled:=False;
end;

procedure TForm6.returnButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form6.Close;
end;

procedure TForm6.addButtonClick(Sender: TObject);
var
  us: User;
begin
   if logUser.Email =  Form6.mailEdit.Text then
    begin
     ShowMessage('No se permite ser su propio contacto');
     Form6.mailEdit.Text:='';
     Exit;
    end;

    us := Form1.userList.findEmail(Form6.mailEdit.Text);

    if logUser.contactList.findEmail(Form6.mailEdit.Text) = nil then
      begin
       if us <> nil then
         begin
           logUser.contactList.add(Contact.create(us.id,us.tel,us.name,us.user,us.Email));
           us.contactList.add(Contact.create(logUser.id,logUser.tel,logUser.name,logUser.user,logUser.Email));
           ShowMessage('Contacto agregado');
           Form6.mailEdit.Text:='';

         end
       else
         begin
          ShowMessage('No se encontro el usuario');
          Form6.mailEdit.Text:='';
         end;
      end
    else
     begin
      ShowMessage('Contacto ya existente');
      Form6.mailEdit.Text:='';
     end;

end;

procedure TForm6.setUser(u:User);
begin
  logUser := u;
  Form6.mailEdit.Text:='';
end;

end.

