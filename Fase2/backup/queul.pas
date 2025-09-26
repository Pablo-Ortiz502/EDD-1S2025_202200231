unit queuL;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,MessageClasss, Process;

type

    KNode = ^mNode;
    mNode = record
      data: Message;
      next: KNode;
    end;


    QueuList = class
      private
        head: KNode;
        countM: Integer;
      public
        property aHead: KNode read head write head;
        constructor create;
        destructor Destroy; override;
        procedure add(prog: Message);
        procedure removeById(cId: Integer);
        function findById(aId: Integer): Message;
        procedure remove;
        procedure programReport(const fileName: string);
      end;

implementation


{QueuList}
      constructor QueuList.create;
        begin
          head := nil;
          countM := 0;
        end;

      destructor QueuList.Destroy;
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

      procedure QueuList.remove;
      var
        current: KNode;
      begin
         current := head;
         head := current^.next;
         current^.data.Free;
         Dispose(current)
      end;


      procedure QueuList.add(prog: Message);
        var
          newNode, current: KNode;
        begin
          New(newNode);
          newNode^.data := prog;
          newNode^.next := nil;

          if head = nil then
            head := newNode
          else
            begin
              current := head;
              while current^.next <> nil do
                current := current^.next;
              Inc(countM)
              current^.next := newNode;
              newNode^.data.id:=countM;
            end;
      end;

     procedure QueuList.removeById(cId: Integer);
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

     function QueuList.findById(aId: Integer): Message;
       var
         current: KNode;
       begin
         current := head;
         while current <> nil do
           begin
             if current^.data.id = aId then
                begin
                  Result:= current^.data;
                  Exit;
                end;
             current := current^.next;
           end;
          Result := nil;
       end;


     procedure QueuList.programReport(const fileName: string);
           var
             f: TextFile;
             current: KNode;
             folder, dotFile, pngFile: string;
             aProcess: TProcess;
           begin
             folder := 'programed_report';
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
                    'Receptor: ', current^.data.sender, '\n',
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

