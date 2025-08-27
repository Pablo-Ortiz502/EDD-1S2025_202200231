unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Menus, Unit3;

type

  { TForm1 }

  TForm1 = class(TForm)
    logButton: TButton;
    createButton: TButton;
    userEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    passEdit: TEdit;
    procedure createButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure logButtonClick(Sender: TObject);
  private

  public
    acc: User;
    userList: LinkedList;
  end;

var
  Form1: TForm1;

implementation
  uses Unit2,Unit4,createUI;
{$R *.lfm}

{ TForm1 }

//----------------------------------------------
procedure TForm1.logButtonClick(Sender: TObject);
begin

  acc := userList.accesTo(passEdit.Text, userEdit.Text);
  if (userEdit.Text = 'admin') and (passEdit.Text = '123') then
     begin
     ShowMessage('Bienvenido');
     Form2.Show;
     Form1.Hide;
     end
  else if acc <> nil then
     begin
     ShowMessage('Bienvenido');
     Form3.Show;
     Form3.setUser(acc);
     Form1.Hide;
     end
  else
     ShowMessage('Credenciales invalidas');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  userList := LinkedList.create;
    userList.add(User.create(1,41877278,'Pablo','1','1','1'));
    userList.add(User.create(2,41877278,'Pablo','EliteDragon','1234','pablo@gmail.com'));
    userList.add(User.create(3,41877278,'Cesar','Elliwood','qwer','cesar@gmail.com'));
end;

procedure TForm1.createButtonClick(Sender: TObject);
begin
   Form12.Show;
   Form12.setE;
   Form1.Hide;
end;


end.

