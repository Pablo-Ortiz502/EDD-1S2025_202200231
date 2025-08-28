unit Unit5;

{$mode ObjFPC}{$H+}

interface
Uses stackL,MessageClasss,Process,SysUtils;
type

    DNode = ^qNode;
    qNode = record
      data: Message;
      next: DNode;
      prev: DNode;
    end;


    DoubleList = class
      private
        head: DNode;
        countM: Integer;
      public
        property aHead: DNode read head write head;
        constructor create;
        destructor Destroy; override;
        procedure add(aMessageS: Message);
        function findById(cId: Integer): Message;
        procedure deleteItem(cId: Integer; trashL: StackList);
        procedure messageReport(const fileName: string);
      end;

implementation

{DoubleList}
      constructor DoubleList.create;
        begin
          head := nil;
          countM := 0;
        end;

      destructor DoubleList.Destroy;
        var
          temp: DNode;
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

      procedure DoubleList.deleteItem(cId: Integer; trashL: StackList);
        var
          current, prev, next: DNode;
        begin
          current := head;
          while current <> nil do
            begin
              if current^.data.id = cId then
                begin

                  if current = head then
                    begin
                      head := head^.next;
                      trashL.append(current^.data);
                      Dispose(current);
                      Exit;
                    end;

                  prev := current^.prev;
                  next := current^.next;

                  if prev <> nil then;
                    prev^.next := next;
                  if next <> nil then
                    next^.prev := prev;

                  trashL.append(current^.data);
                  Dispose(current);
                  Exit;
                end;
                current := current^.next
            end;
        end;


      procedure DoubleList.add(aMessageS: Message);
        var
          newNode, current: DNode;
        begin
          New(newNode);
          newNode^.data := aMessageS;
          newNode^.next := nil;
          newNode^.prev := nil;

          if head = nil then
            head := newNode
          else
            begin
              current := head;

              while current^.next <> nil do
                 current := current^.next;

              Inc(countM);
              current^.next := newNode;
              newNode^.prev := current;
              newNode^.data.id := countM;
            end;
        end;


     function DoubleList.findById(cId: Integer): Message;
       var
         current: DNode;
       begin
         current := head;
         while current <> nil do
           begin
             if (current^.data.id = cId) then
               begin
                 Result := current^.data;
                 Exit;
               end;
             current := current^.next;
           end;
          Result := nil;
       end;


     procedure DoubleList.messageReport(const fileName: string);
      var
        f: TextFile;
        current: DNode;
        folder, dotFile, pngFile: string;
        aProcess: TProcess;
      begin
        folder := 'messages_reports';
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
            Writeln(f, '  "', current^.data.id, '" [label="',
              'Emisor: ', current^.data.sender, '\n',
              'Asunto: ', current^.data.subject, '\n',
              'Fecha: ', current^.data.date, '\n',
              'Mensaje: ', current^.data.message, '"];');

            if current^.next <> nil then
              Writeln(f, '  "', current^.data.id, '" -> "', current^.next^.data.id, '";');
            if current^.prev <> nil then
              Writeln(f, '  "', current^.data.id, '" -> "', current^.prev^.data.id, '"[dir=back];');

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

