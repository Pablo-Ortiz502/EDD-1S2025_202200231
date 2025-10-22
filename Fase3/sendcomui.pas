unit sendComUi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,Unit3;

type

  { TForm18 }

  TForm18 = class(TForm)
    sendButton: TButton;
    returnButton: TButton;
    comEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    messMemo: TMemo;
    procedure comEditChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure messMemoChange(Sender: TObject);
    procedure returnButtonClick(Sender: TObject);
    procedure sendButtonClick(Sender: TObject);
  private
     logUser: User;
  public
      countM: integer;
      procedure setUser(u:User);
      procedure refresh;
      procedure validation;
  end;

var
  Form18: TForm18;

implementation
uses bts, Unit1,Unit4;
 {$R *.lfm}

procedure TForm18.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TForm18.FormCreate(Sender: TObject);
begin
  countM := 0;
end;

procedure TForm18.messMemoChange(Sender: TObject);
begin
  Form18.validation;
end;

procedure TForm18.comEditChange(Sender: TObject);
begin
  Form18.validation;
end;

procedure TForm18.returnButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form18.Hide;
end;

procedure TForm18.sendButtonClick(Sender: TObject);
var
  com: Comunity;
  dateA: String;
begin
  com := Form1.communitiesTree.SearchByName(Form18.comEdit.Text);
  if com <> nil then
   begin
      if com.userList.findEmail(logUser.Email) <> nil then
       begin
         dateA := FormatDateTime('dd/mm/yyyy  hh:nn:ss',Now);
         com.messList.add(CMessage.create(dateA,logUser.Email,Form18.messMemo.Text,com.messList.co));
         Inc(com.messList.co);
         Inc(com.countM);
         Form18.refresh;
         ShowMessage('Mensage enviado a la comunidad');
       end
      else
        ShowMessage('no eres parte de esa comunidad');
   end
  else
     ShowMessage('Comunidad no enconrada');
end;

procedure  TForm18.setUser(u: User);
begin
  logUser := u;
  Form18.refresh;
end;

procedure TForm18.refresh;
begin
  Form18.comEdit.Text:='';
  Form18.messMemo.Text:='';
  Form18.sendButton.Enabled:=False;
end;

procedure TForm18.validation;
var
  b: Boolean;
begin
  b := (Trim(Form18.comEdit.Text)<>'')and(Trim(Form18.messMemo.Text)<>'');
  Form18.sendButton.Enabled:= b;
end;


end.

