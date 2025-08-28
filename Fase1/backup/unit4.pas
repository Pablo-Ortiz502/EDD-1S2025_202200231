unit Unit4;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,Unit3;

type

  { TForm3 }

  TForm3 = class(TForm)
    contactButton: TButton;
    entryButton: TButton;
    sedButton: TButton;
    trashButton: TButton;
    programButton: TButton;
    programedButton: TButton;
    addCButton: TButton;
    postButton: TButton;
    reportButton: TButton;
    exitButton: TButton;
    Label1: TLabel;
    Label2: TLabel;

    procedure addCButtonClick(Sender: TObject);
    procedure contactButtonClick(Sender: TObject);
    procedure entryButtonClick(Sender: TObject);
    procedure exitButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure postButtonClick(Sender: TObject);
    procedure programButtonClick(Sender: TObject);
    procedure programedButtonClick(Sender: TObject);
    procedure reportButtonClick(Sender: TObject);
    procedure sedButtonClick(Sender: TObject);
    procedure trashButtonClick(Sender: TObject);

  private
     aLogUser: User;
  public
     procedure setUser(fUser: User);
  end;

var
  Form3: TForm3;
implementation

uses Unit1,Unit6,trashUI,addCon,postUI,contactsUI,sendUI,progUI,programedUI,Unit5;
{$R *.lfm}

{ TForm3 }

procedure TForm3.setUser(fUser: User);
begin
   aLogUser := fUser;
   Form3.Label2.Caption := aLogUser.name;
end;

procedure TForm3.exitButtonClick(Sender: TObject);
begin
   Form1.userEdit.Text := '';
   Form1.passEdit.Text := '';
   Form1.Show;
   Form3.Hide;
end;

procedure TForm3.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm3.postButtonClick(Sender: TObject);
begin
   Form7.Show;
   Form7.setUser(aLogUser);
   Form3.Hide;
end;

procedure TForm3.programButtonClick(Sender: TObject);
begin
  Form10.Show;
  Form10.setUser(aLogUser);
  Form3.Hide;
end;

procedure TForm3.programedButtonClick(Sender: TObject);
begin
  Form11.show;
  Form11.setUser(aLogUSer);
  Form3.Hide;
end;

procedure TForm3.reportButtonClick(Sender: TObject);
begin
   aLogUser.messListU.messageReport(aLogUser.name +'__mensajes' );
   aLogUser.trashList.trashReport(aLogUser.name+'__Papelera');
   aLogUser.programList.programReport(aLogUser.name +'__Programados');
   ShowMessage('Reportes creados correctamente')
end;

procedure TForm3.sedButtonClick(Sender: TObject);
begin
   Form9.Show;
   Form9.setUser(aLogUser);
   Form3.Hide;
end;

procedure TForm3.trashButtonClick(Sender: TObject);
begin
  Form5.Show;
  Form5.setUser(aLogUser);
  Form3.Hide;
end;

procedure TForm3.entryButtonClick(Sender: TObject);
begin
   Form4.Show;
   Form4.setUser(aLogUser);
   Form3.Hide;
end;

procedure TForm3.addCButtonClick(Sender: TObject);
begin
  Form6.Show;
  Form6.setUser(aLogUser);
  Form3.Hide;
end;

procedure TForm3.contactButtonClick(Sender: TObject);
begin
  Form8.Show;
  Form8.setUser(aLogUser);
  Form3.hide;
end;

end.

