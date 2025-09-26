unit comuUi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm14 }

  TForm14 = class(TForm)
    addButton: TButton;
    addComEdit: TEdit;
    exitButton: TButton;
    comEdit: TEdit;
    Comunidad: TLabel;
    Comunidad1: TLabel;
    createButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    mailEdit: TEdit;
    procedure addButtonClick(Sender: TObject);
    procedure addComEditChange(Sender: TObject);
    procedure comEditChange(Sender: TObject);
    procedure createButtonClick(Sender: TObject);
    procedure exitButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure mailEditChange(Sender: TObject);
  private

  public
    procedure refresh;
    procedure validation;
  end;

var
  Form14: TForm14;


implementation
Uses Unit1,Unit3,listsL,Unit2;
{$R *.lfm}

procedure TForm14.validation;
begin
  Form14.addButton.Enabled := (Trim(Form14.mailEdit.Text) <> '') and (Trim(Form14.addComEdit.Text)<>'')and(Form1.comunities.aHead <> nil);
  Form14.createButton.Enabled:= (Trim(Form14.comEdit.Text) <> '');
end;

procedure TForm14.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm14.mailEditChange(Sender: TObject);
begin
  Form14.validation;
end;

procedure TForm14.comEditChange(Sender: TObject);
begin
  Form14.validation;
end;

procedure TForm14.createButtonClick(Sender: TObject);
begin
  if Form1.comunities.findByName(Form14.comEdit.Text) = nil then
     begin
       Form1.comunities.add(Form14.comEdit.Text);
       ShowMessage('Comunidad '+Form14.comEdit.Text+' creada exitosamente');
       Form14.refresh;
     end
  else
       ShowMessage('Comunidad YA EXISTE');
  Form14.refresh;
end;

procedure TForm14.exitButtonClick(Sender: TObject);
begin
  Form14.Hide;
  Form2.Show;
end;

procedure TForm14.addComEditChange(Sender: TObject);
begin
  Form14.validation;
end;

procedure TForm14.addButtonClick(Sender: TObject);
var
  u: User;
begin
  if Form1.comunities.findByName(Form14.addComEdit.Text) = nil then
     begin
       ShowMessage('Comunidad NO encontrada');
       Exit;
     end;
  if Form1.userList.findEmail(Form14.mailEdit.Text) = nil then
     begin
       ShowMessage('Usuario no encontrado');
       Exit;
     end;
  if Form1.comunities.findByEmail(Form14.mailEdit.Text,Form14.addComEdit.Text) = nil then
    begin
      u := Form1.userList.findEmail(Form14.mailEdit.Text);
      Form1.comunities.incert(CUser.create(u.id,u.name,u.Email),Form14.addComEdit.Text);
      ShowMessage('Usuario agregado exitosamente');
      Form14.refresh;
    end
   else
     ShowMessage('Usuario ya existente en esa comunidad');


end;

procedure TForm14.refresh;
begin
  Form14.comEdit.Text:='';
  Form14.addComEdit.Text:='';
  Form14.mailEdit.Text:='';
  Form14.validation;
end;

end.

