unit MessageClasss;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

    Message = class
      id: Integer;
      sender: String;
      stateR: Boolean;
      subject: String;
      date: String;
      message: String;
      constructor create(aDate,aSender,aSubject,aMessage: String; aState:Boolean);
    end;

implementation
constructor Message.create(aDate,aSender,aSubject,aMessage: String; aState:Boolean);
begin
  id := 0;
  sender := aSender;
  subject := aSubject;
  date := aDate;
  stateR := aState;
  message := aMessage;
end;

end.

