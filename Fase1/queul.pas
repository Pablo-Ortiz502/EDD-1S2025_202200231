unit queuL;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,MessageClasss;

type

    KNode = ^mNode;
    mNode = record
      data: Message;
      next: KNode;
    end;


    QueuList = class
      private
        head: KNode;
      public
        property aHead: KNode read head write head;
        constructor create;
        destructor Destroy; override;
        procedure add(prog: Message);
        procedure removeById(cId: Integer);
        function findById(aId: Integer): Message;
        procedure remove;
      end;

implementation


{QueuList}
      constructor QueuList.create;
        begin
          head := nil;
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
              current^.next := newNode;
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

end.

