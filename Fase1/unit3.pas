unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Unit5,stackL,circularL,queuL,Process;

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
        contactList: CircularList;
        programList: QueuList;
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
        function findEmail(aEmail: string): User;
        function accesTo(aPassword,aEmail: string): User;
        procedure post(u: User);
        function idCount: Integer;
        procedure userReport(const fileName: string);
      end;

implementation
 Uses Unit1;
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
        contactList := CircularList.create;
        programList := QueuList.create;
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


      function LinkedList.idCount: Integer;
        var
          current: Node;
        begin
          current := head;

          while current^.next <> nil do
            current := current^.next;

          if current = nil then
            Result := -1
          else
            Result := current^.data.id + 1;
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

     function LinkedList.accesTo(aPassword,aEmail: string): User;
       var
         current: Node;
       begin
         current := head;
         while current <> nil do
           begin
             if (current^.data.Email = aEmail) and (current^.data.password= aPassword) then
               begin
                 Result := current^.data;
                 Exit;
               end;
             current := current^.next;
           end;
          Result := nil;
       end;

     procedure LinkedList.post(u: User);
      var
        current: Node;
      begin
        current := Form1.userList.aHead;
        while current <> nil do
          begin
              if current^.data.contactList.findEmail(u.Email) <> nil then
                  current^.data.contactList.findEmail(u.Email).user:=u.user;
              current := current^.next
          end;

      end;

     procedure LinkedList.userReport(const fileName: string);
      var
        f: TextFile;
        current: Node;
        folder, dotFile, pngFile: string;
        aProcess: TProcess;
      begin
        folder := 'user_report';
        if not DirectoryExists(folder) then
          CreateDir(folder);

        dotFile := folder + '/' + fileName + '.dot';
        pngFile := folder + '/' + fileName + '.png';

        AssignFile(f, dotFile);
        Rewrite(f);

        try
          Writeln(f, 'digraph G {');
          Writeln(f, '  node [shape=record, style=filled, fillcolor=lightblue];');
          Writeln(f, '  rankdir=LR;');

          current := head;
          while current <> nil do
          begin
            Writeln(f, '  "', current^.data.Email, '" [label="',
              'ID: ', current^.data.id, '\n',
              'Nombre: ', current^.data.name, '\n',
              'Usuario: ', current^.data.user, '\n',
              'Email: ', current^.data.Email, '\n',
              'Tel: ', current^.data.tel, '"];');

            if current^.next <> nil then
              Writeln(f, '  "', current^.data.Email, '" -> "', current^.next^.data.Email, '";');

            current := current^.next;
          end;

          Writeln(f, '}');
        finally
          CloseFile(f);
        end;


        aProcess := TProcess.Create(nil);
        try
          aProcess.Executable := 'dot';
          aProcess.Parameters.Add('-Tpng');
          aProcess.Parameters.Add(dotFile);
          aProcess.Parameters.Add('-o');
          aProcess.Parameters.Add(pngFile);
          aProcess.Options := aProcess.Options + [poWaitOnExit];
          aProcess.Execute;
        finally
          aProcess.Free;
        end;
      end;


end.

