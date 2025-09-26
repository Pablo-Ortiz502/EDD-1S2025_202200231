unit listsL;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,Process;

type

    CUser = class
        id: Integer;
        name: string;
        Email: string;
        constructor create(aId: Integer; aName,aEmail: string);
    end;

    bNode = ^rNode;
    rNode = record
      data: CUser;
      next: bNode;
    end;

    CLinkedList = class
      private
        cHead: bNode;
      public
        constructor create;
        destructor Destroy; override;
        procedure add(aUser: CUser);
        function findEmail(aEmail: string): CUser;
      end;

    zNode = ^iNode;
    iNode = record
      data: CLinkedList;
      next: zNode;
      id: Integer;
      name: String;
    end;

    ListList = class
      private
        head :  zNode;
        countI : integer;
      public
        property aHead: zNode read head write head;
        constructor create;
        procedure add(comunityName: String);
        procedure incert(u: CUser; comunityName: String);
        function findByEmail(eMail,comunityName: String): CUser;
        function findByName(comunityName: String): CLinkedList;
        procedure comunityReport;
      end;



implementation
{ListList}

   constructor ListList.create;
   begin
     head:= nil;
     countI := 0;
   end;

   procedure ListList.add(comunityName: String);  // agrega una lista en la lista de listas
   var
     current, newNode: zNode;
   begin


     New(newNode);
     newNode^.data := CLinkedList.create;
     newNode^.next := nil;
     newNode^.id := countI;
     newNode^.name := comunityName;

     if head = nil then
     begin
        head := newNode;
        Inc(countI);
        Exit;
     end
     else
     begin
       current := head;
       while current^.next <> nil do
         current := current^.next;
       current^.next := newNode;
       Inc(countI);
     end;
   end;


   function ListList.findByName(comunityName: String): CLinkedList;  // encuentra una lista en la lista de listas
   var
     current: zNode;
   begin
     current := head;
     while current <> nil do
     begin
       if current^.name = comunityName then
       begin
          Result := current^.data;
          Exit;
       end;
       current:= current^.next;
     end;
     Result := nil;
   end;


   procedure ListList.incert(u: CUser;comunityName: String);   //incerta un usuario en la lista de listas
   var
     list: CLinkedList;
   begin
     list := findByName(comunityName);
     if list <> nil then
       list.add(u);
   end;





   function ListList.findByEmail(eMail,comunityName: String): CUser;   //devuelve un usuario en la lista de listas
   var
     list: CLinkedList;
   begin
     list := findByName(comunityName);
     Result := list.findEmail(eMail);
     Exit;
   end;


   procedure ListList.comunityReport;
   var
     dotFile: TextFile;
     currentCom: zNode;
     currentUser: bNode;
     comNodeName, userNodeName: string;
     userCount: Integer;
     folderPath, dotPath, pngPath: string;
     proc: TProcess;
   begin
     // Crea carpeta
     folderPath := 'Reporte de comunidades';
     if not DirectoryExists(folderPath) then
       CreateDir(folderPath);

     dotPath := folderPath + PathDelim + 'comunidades.dot';
     pngPath := folderPath + PathDelim + 'comunidades.png';

     // Genera archivo de Graphviz
     AssignFile(dotFile, dotPath);
     Rewrite(dotFile);

     Writeln(dotFile, 'digraph G {');
     Writeln(dotFile, '  rankdir=LR;');
     Writeln(dotFile, '  node [shape=record, style=filled, fontname="Helvetica"];');

     currentCom := head;
     while currentCom <> nil do
     begin
       // Nodo comunidad
       comNodeName := 'com' + IntToStr(currentCom^.id);
       Writeln(dotFile, Format('  %s [label=" %s", fillcolor=lightblue, shape=box];',[comNodeName,currentCom^.name]));

       // Recorre usuarios
       currentUser := currentCom^.data.cHead;
       userCount := 0;
       while currentUser <> nil do
       begin
         userNodeName := comNodeName + '_u' + IntToStr(userCount);

         Writeln(dotFile, Format('  %s [label="%s", fillcolor=lightyellow, shape=box];',[userNodeName, currentUser^.data.Email]));

         // Conecta comunidad con primer usuario o entre usuarios
         if userCount = 0 then
           Writeln(dotFile, Format('  %s -> %s;', [comNodeName, userNodeName]))
         else
           Writeln(dotFile, Format('  %s_u%d -> %s;', [comNodeName, userCount - 1, userNodeName]));

         currentUser := currentUser^.next;
         Inc(userCount);
       end;

       // Conecta comunidades
       if currentCom^.next <> nil then
         Writeln(dotFile, Format('  %s -> com%d;', [comNodeName, currentCom^.next^.id]));

       currentCom := currentCom^.next;
     end;

     Writeln(dotFile, '}');
     CloseFile(dotFile);

     // Ejecuta Graphviz
     proc := TProcess.Create(nil);
     try
       proc.Executable := 'dot';
       proc.Parameters.Add('-Tpng');
       proc.Parameters.Add(dotPath);
       proc.Parameters.Add('-o');
       proc.Parameters.Add(pngPath);
       proc.Options := proc.Options + [poWaitOnExit];
       proc.Execute;
     finally
       proc.Free;
     end;
   end;


{CUser}
   constructor CUser.create(aId: Integer; aName,aEmail: string);
   begin
     id := aId;
     name := aName;
     Email := aEmail;
   end;

{CLinkedList}

   constructor CLinkedList.create;
   begin
      cHead := nil;
   end;

   destructor CLinkedList.Destroy;
     var
       temp: bNode;
     begin
       while cHead <> nil do
         begin
           temp := cHead;
           cHead := cHead^.next;
           temp^.data.Free;
           Dispose(temp);
         end;
         inherited;
     end;

   procedure CLinkedList.add(aUser: CUser);    //agrega un usuario en la lista enlazada
     var
       newNode, current: bNode;
     begin
       New(newNode);
       newNode^.data := aUser;
       newNode^.next := nil;

       if cHead = nil then
         cHead := newNode
       else
         begin
           current := cHead;
           while current^.next <> nil do
             current := current^.next;
           current^.next := newNode;
         end;
     end;

   function CLinkedList.findEmail(aEmail: string): CUser;  //encuentra el usuario dentro de la lista enlazada
     var
       current: bNode;
     begin
       current := cHead;
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


end.

