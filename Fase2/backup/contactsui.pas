unit contactsUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Unit3, circularL;

type

  { TForm8 }

  TForm8 = class(TForm)
    backButton: TButton;
    forwButton: TButton;
    returButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    mailEdit: TEdit;
    nameEdit: TEdit;
    telEdit: TEdit;
    userEdit: TEdit;
    procedure backButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure forwButtonClick(Sender: TObject);
    procedure returButtonClick(Sender: TObject);
  private
      logUser: User;
      current: CNode;
  public
      procedure setUser(u: User);
      procedure refresh;
  end;

var
  Form8: TForm8;

implementation
uses Unit4;

{$R *.lfm}
procedure TForm8.forwButtonClick(Sender: TObject);
begin
  current := current^.next;
  Form8.refresh;
end;

procedure TForm8.returButtonClick(Sender: TObject);
begin
  Form3.Show;
  Form8.Hide;
end;

procedure TForm8.backButtonClick(Sender: TObject);
begin
  current := current^.prev;
  Form8.refresh;
end;

procedure TForm8.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

  procedure TForm8.setUser(u: User);
  begin
    logUser := u;
    current := logUser.contactList.aHead;
    Form8.refresh;
  end;

  procedure TForm8.refresh;
  begin
    if current <> nil  then
    begin
      Form8.nameEdit.Text:= current^.data.name;
      Form8.userEdit.Text := current^.data.user;
      Form8.mailEdit.Text := current^.data.Email;
      Form8.telEdit.Text := IntToStr(current^.data.tel);
    end;
  end;
end.

