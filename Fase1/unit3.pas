unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Unit5,stackL;

type

    User = class
        id: Integer;
        name: string;
        user: string;
        password: string;
        Email: string;
        tel: Integer;
        messListU : DoubleList;
        trashList: StackList;
        constructor create(aId, aTel: Integer; aName,aUser,aPassword,aEmail: string);
    end;


    Node = ^TNode;
    TNode = record
      data: User;
      next: Node;
    end;


    LinkedList = class
      private
        head: Node;
      public
        property aHead: Node read head write head;
        constructor create;
        destructor Destroy; override;
        procedure add(aUser: User);
        procedure print;
        function findEmail(aEmail: string): User;
        function accesTo(aPassword,aUser: string): User;
      end;

implementation

{User}
      constructor User.create(aId, aTel: Integer; aName,aUser,aPassword,aEmail: string);
      begin
        id := aId;
        name := aName;
        password := aPassword;
        Email := aEmail;
        tel := aTel;
        user := aUser;
        MessListU := DoubleList.create;
        trashList := StackList.create;
      end;


{LinkedList}
      constructor LinkedList.create;
        begin
          head := nil;
        end;

      destructor LinkedList.Destroy;
        var
          temp: Node;
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


      procedure LinkedList.add(aUser: User);
        var
          newNode, current: Node;
        begin
          New(newNode);
          newNode^.data := aUser;
          newNode^.next := nil;

          if head = nil then
            head := newNode
          else
            begin
              current := head;
              while current^.next <> nil do
                current := current^.next;
              current^.next := newNode;
              Writeln('Email: ',current^.data.Email,'Nombre: ',current^.data.Name, 'id: ',current^.data.id);
            end;
        end;


      procedure LinkedList.print;
       var
         current: Node;
       begin
         current := head;
         while current <> nil do
           begin
             Writeln('Email: ',current^.data.Email,'Nombre: ',current^.data.Name, '--->');
             current := current^.next;
           end;
       end;


     function LinkedList.findEmail(aEmail: string): User;
       var
         current: Node;
       begin
         current := head;
         while current <> nil do
           begin
             if current^.data.Email = aEmail then
               begin
                 Result := current^.data;
                 Exit;
               end;
             current := current^.next;
           end;
          Result := nil;
       end;

     function LinkedList.accesTo(aPassword,aUser: string): User;
       var
         current: Node;
       begin
         current := head;
         while current <> nil do
           begin
             if (current^.data.user = aUser) and (current^.data.password = aPassword) then
               begin
                 Result := current^.data;
                 Exit;
               end;
             current := current^.next;
           end;
          Result := nil;
       end;
end.

