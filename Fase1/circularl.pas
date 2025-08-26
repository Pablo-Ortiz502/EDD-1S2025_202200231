unit circularL;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

    Contact = class
      id: Integer;
      name: string;
      user: string;
      Email: string;
      tel: Integer;
      constructor create(aId, aTel: Integer; aName,aUser,aEmail: string);
    end;


    CNode = ^TNode;
    TNode = record
      data: Contact;
      next: CNode;
    end;


    CircularList = class
      private
        head: CNode;
      public
        property aHead: CNode read head write head;
        constructor create;
        destructor Destroy; override;
        procedure add(aContact: Contact);
        function findEmail(aEmail: string): Contact;
      end;

implementation

{Contact}
      constructor Contact.create(aId, aTel: Integer; aName,aUser,aEmail: string);
      begin
        id := aId;
        name := aName;
        Email := aEmail;
        tel := aTel;
        user := aUser
      end;

{CircularList}
      constructor CircularList.create;
        begin
          head := nil;
        end;

      destructor CircularList.Destroy;
        var
          temp: CNode;
        begin
          while head <> nil do
            begin
              temp := head;
              head := head^.next;
              temp^.data.Free;
              Dispose(temp);
            end;
            inherited;
        end;


      procedure CircularList.add(aContact: Contact);
        var
          newNode, current: CNode;
        begin
          New(newNode);
          newNode^.data := aContact;
          newNode^.next := head;

          if head = nil then
           begin
            head := newNode;
            newNode^.next:= head;
           end
          else
            begin
              current := head;
              while current^.next <> head do
                current := current^.next;
              current^.next := newNode;
              newNode^.next := head;

            end;
        end;

     function CircularList.findEmail(aEmail: string): Contact;
       var
         current: CNode;
       begin

       if head = nil then
           begin
             Result := nil;
             Exit;
           end;
       current := head;

       repeat
         if current^.data.Email = aEmail then
           begin
             Result := current^.data;
             Exit;
           end;
           current := current^.next;
       until current = head;

          Result := nil;
       end;
end.

