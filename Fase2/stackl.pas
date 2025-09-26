unit stackL;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, MessageClasss,Process;

type

    KNode = ^mNode;
    mNode = record
      data: Message;
      next: KNode;
    end;


    StackList = class
      private
        head: KNode;
      public
        property aHead: KNode read head write head;
        constructor create;
        destructor Destroy; override;
        procedure append(trashed: Message);
        function findBySubject(aSubject: string): StackList;
        procedure deleteById(cId: Integer);
        procedure pop;
        procedure trashReport(const fileName: string);
      end;

implementation


{StackList}
      constructor StackList.create;
        begin
          head := nil;
        end;

      destructor StackList.Destroy;
        var
          temp: KNode;
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

      procedure StackList.pop;
      var
        current: KNode;
      begin
         current := head;
         while current^.next <> nil do
           current := current^.next;
         current^.data.Free;
         Dispose(current)
      end;


      procedure StackList.append(trashed: Message);
        var
          newNode, current: KNode;
        begin
          New(newNode);
          newNode^.data := trashed;
          newNode^.next := nil;

          if head = nil then
            head := newNode
          else
            begin
              current := head;
              while current^.next <> nil do
                current := current^.next;
              current^.next := newNode;
            end;
      end;




     function StackList.findBySubject(aSubject: string): StackList;
       var
         current: KNode;
         sL : StackList;
       begin
         sL := StackList.create;
         current := head;
         while current <> nil do
           begin

             if Pos(aSubject, current^.data.subject)>0 then
                sL.append(current^.data);

             current := current^.next;
           end;
          Result := sL;
       end;

     procedure StackList.deleteById(cId: Integer);
       var
        current, prev: KNode;
       begin
         current := head;
         prev := nil;

         while current <> nil do
           begin
             if current^.data.id = cId then
              begin

                if prev = nil then
                  head := current^.next
                else
                  prev^.next := current^.next;

                current^.data.Free;
                Dispose(current);
                Exit;
              end;

           prev := current;
           current := current^.next;
         end;
       end;

     procedure StackList.trashReport(const fileName: string);
           var
             f: TextFile;
             current: KNode;
             folder, dotFile, pngFile: string;
             aProcess: TProcess;
           begin
             folder := 'trash_report';
             if not DirectoryExists(folder) then
               CreateDir(folder);

             dotFile := folder + '/' + fileName + '.dot';
             pngFile := folder + '/' + fileName + '.png';

             AssignFile(f, dotFile);
             Rewrite(f);

             try
               Writeln(f, 'digraph G {');
               WriteLn(f,'rankdir=TB;');
               Writeln(f, '  node [shape=record, style=filled, fillcolor=lightblue];');
               Writeln(f, '  rankdir=LR;');

               current := head;
               while current <> nil do
               begin
                 Writeln(f, '  "', current^.data.id, '" [label="',
                    'Emisor: ', current^.data.sender, '\n',
                    'Asunto: ', current^.data.subject, '\n',
                    'Fecha: ', current^.data.date, '\n',
                    'Mensaje: ', current^.data.message, '"];');

                 if current^.next <> nil then
                   Writeln(f, '  "', current^.data.id, '" -> "', current^.next^.data.id, '";');

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

