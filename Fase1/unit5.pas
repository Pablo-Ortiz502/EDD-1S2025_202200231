unit Unit5;

{$mode ObjFPC}{$H+}

interface
Uses stackL,MessageClasss;
type

    DNode = ^TNode;
    TNode = record
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

end.

