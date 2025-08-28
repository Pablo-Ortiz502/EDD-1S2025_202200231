unit circularL;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Process;

type

    Contact = class
      id: Integer;
      name: string;
      user: string;
      Email: string;
      tel: Integer;
      constructor create(aId, aTel: Integer; aName,aUser,aEmail: string);
    end;


    CNode = ^PNode;
    PNode = record
      data: Contact;
      next: CNode;
      prev: CNode;
    end;


    CircularList = class
      private
        head: CNode;
      public
        property bHead: CNode read head write head;
        constructor create;
        destructor Destroy; override;
        procedure add(aContact: Contact);
        function findEmail(aEmail: string): Contact;
        procedure contactReport(const fileName: string);
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
          newNode, last: CNode;
        begin
          New(newNode);
          newNode^.data := aContact;

          if head = nil then
           begin
            head := newNode;
            head^.next:= head;
            head^.prev := head;
           end
          else
            begin
              last := head^.prev;
              newNode^.next := head;
              newNode^.prev := last;
              last^.next := newNode;
              head^.prev := newNode;
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

      procedure CircularList.contactReport(const fileName: string);
       var
         f: TextFile;
         current: CNode;
         folder, dotFile, pngFile: string;
         aProcess: TProcess;
       begin
         folder := 'contact_reports';
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

           if head <> nil then
           begin
           repeat
             Writeln(f, '  "', current^.data.id, '" [label="',
             'ID: ', current^.data.id, '\n',
             'Nombre: ', current^.data.name, '\n',
             'Usuario: ', current^.data.user, '\n',
             'Email: ', current^.data.Email, '\n',
             'Tel: ', current^.data.tel, '"];');

             if current^.next <> nil then
               Writeln(f, '  "', current^.data.id, '" -> "', current^.next^.data.id, '"[dir=both];');

             current := current^.next;
           until current = head;
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

