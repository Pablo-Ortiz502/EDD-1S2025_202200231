unit comUI;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm13 }

  TForm13 = class(TForm)
    addButton: TButton;
    Button1: TButton;
    Comunidad1: TLabel;
    createButton: TButton;
    comEdit: TEdit;
    addComEdit: TEdit;
    mailEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Comunidad: TLabel;
    procedure comEditChange(Sender: TObject);
  private

  public
      procedure refresh;
      procedure validation;
  end;

var
  Form13: TForm13;

implementation

{$R *.lfm}

{ TForm13 }

procedure TForm13.comEditChange(Sender: TObject);
begin

end;

procedure TForm13.refresh;
begin
end;

end;

end.

