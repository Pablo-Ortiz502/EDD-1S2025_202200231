unit bts;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Process;

type

  CUser = class
      id: Integer;
      name: string;
      Email: string;
      constructor create(aId: Integer; aName,aEmail: string);
  end;

  CMessage = class
     public
      sender: String;
      date: String;
      message: String;
      id: integer;
      constructor create(aDate,aSender,aMessage: String; aid: Integer);
    end;

  bNode = ^rNode;
  rNode = record
    data: CUser;
    next: bNode;
  end;

  nNode = ^mNode;
  mNode = record
    data: CMEssage;
    next: nNode;
  end;

  ULinkedList = class     // lista de usuraios de la comunidad
    private
      cHead: bNode;
    public
      constructor create;
      destructor Destroy; override;
      procedure add(aUser: CUser);
      function findEmail(aEmail: string): CUser;
    end;

    MLinkedList = class      // lista de mensajes de la comunidad
    private
      wHead: nNode;
    public
      co: integer;
      constructor create;
      procedure add(aMess: CMessage);
      procedure messReport(const fileName: string);
    end;


  Comunity = class      //clase de la comunidad
  public
    id: Integer;
    name: String;
    userList: ULinkedList;
    messList: MLinkedList;
    countM: Integer;
    date: String;
    constructor Create(AId: Integer; const AName: String);
  end;


  PBSTNode = ^TBSTNode;
  TBSTNode = record
    data: Comunity;
    left, right: PBSTNode;
  end;

  BSTree = class // clase del arbol Bts
  private
    root: PBSTNode;
    procedure InsertNode(var node: PBSTNode; c: Comunity);
    procedure InOrder(node: PBSTNode);
    function SearchNode(node: PBSTNode; id: Integer): Comunity;
    procedure WriteNodeDot(node: PBSTNode; SL: TStringList);
  public
    property aRoot: PBSTNode read root;
    constructor Create;
    procedure Insert(c: Comunity);
    function SearchById(id: Integer): Comunity;
    procedure ShowInOrder;
    procedure GenerateGraph(const fileName: String);
    function SearchNodeByName(node: PBSTNode; const name: String): Comunity;
    function SearchByName(const name: String): Comunity;
  end;

implementation

constructor Comunity.Create(AId: Integer; const AName: String);
begin
  id := AId;
  name := AName;
  userList := ULinkedList.Create;
  messList := MLinkedList.create;
  countM := 0;
  date := FormatDateTime('dd/mm/yyyy', Now);
end;

{Arbol BTS}
constructor BSTree.Create;
begin
  root := nil;
end;

procedure BSTree.Insert(c: Comunity); //metodo para incertar una comunidad
begin
  InsertNode(root, c);
end;

procedure BSTree.InsertNode(var node: PBSTNode; c: Comunity);
begin
  if node = nil then
  begin
    New(node);
    node^.data := c;
    node^.left := nil;
    node^.right := nil;
  end
  else if node^.left = nil then
    InsertNode(node^.left, c)
  else if node^.right = nil then
    InsertNode(node^.right, c)
  else if (node^.right <> nil) and (node^.left <> nil) then
    InsertNode(node^.left, c)
  else
    Writeln('Comunidad duplicada con ID: ', c.id);
end;

procedure BSTree.ShowInOrder;
begin
  InOrder(root);
end;

procedure BSTree.InOrder(node: PBSTNode);  // imprime el arbol en consola Inorder
begin
  if node = nil then Exit;
  InOrder(node^.left);
  Writeln('ID: ', node^.data.id, ' | Nombre: ', node^.data.name, ' | Fecha: ', node^.data.date, ' | Mensajes: ', node^.data.countM);
  InOrder(node^.right);
end;

function BSTree.SearchById(id: Integer): Comunity;
begin
  Result := SearchNode(root, id);
end;

function BSTree.SearchNode(node: PBSTNode; id: Integer): Comunity;   // busca comunidad por
begin
  if node = nil then Exit(nil);
  if id = node^.data.id then
    Exit(node^.data)
  else if id < node^.data.id then
    Exit(SearchNode(node^.left, id))
  else
    Exit(SearchNode(node^.right, id));
end;


function BSTree.SearchNodeByName(node: PBSTNode; const name: String): Comunity;   // busca comunidad por id
var
  res: Comunity;
begin
  if node = nil then Exit(nil);

  if LowerCase(node^.data.name) = LowerCase(name) then
    Exit(node^.data);

  res := SearchNodeByName(node^.left, name);
  if res <> nil then Exit(res);

  res := SearchNodeByName(node^.right, name);
  Exit(res);
end;

function BSTree.SearchByName(const name: String): Comunity;
begin
  Result := SearchNodeByName(root, name);
end;

procedure BSTree.GenerateGraph(const fileName: String);    // Ejecutar Graphviz
var
  SL: TStringList;
  dotFile, pngFile: String;
  proc: TProcess;
begin
  if root = nil then
  begin
    Writeln('Árbol vacío, no se puede graficar.');
    Exit;
  end;

  dotFile := 'Reporte de comunidades'+'/'+fileName + '.dot';
  pngFile := 'Reporte de comunidades'+'/'+fileName + '.png';

  SL := TStringList.Create;
  try
    SL.Add('digraph G {');
    SL.Add('graph [splines=true, nodesep=0.6, ranksep=0.8];');
    SL.Add('node [shape=box, style="rounded,filled", fillcolor="#fdfcf5", color="#e28743", fontname="Arial"];');
    SL.Add('edge [color="#888888", arrowsize=0.7];');
    SL.Add('rankdir=TB;');
    SL.Add('labelloc="t";');
    SL.Add('label="Reporte de comunidades";');
    WriteNodeDot(root, SL);
    SL.Add('}');
    SL.SaveToFile(dotFile);


    proc := TProcess.Create(nil);
    try
      proc.Executable := 'dot';
      proc.Parameters.Add('-Tpng');
      proc.Parameters.Add(dotFile);
      proc.Parameters.Add('-o');
      proc.Parameters.Add(pngFile);
      proc.Options := [poWaitOnExit];
      proc.Execute;
    finally
      proc.Free;
    end;

    Writeln('Imagen generada: ', pngFile);
  finally
    SL.Free;
  end;
end;

procedure BSTree.WriteNodeDot(node: PBSTNode; SL: TStringList);
var
  nodeName, labelText, leftName, rightName: String;
begin
  if node = nil then Exit;

  nodeName := 'n' + IntToHex(NativeUInt(node), 8);
  labelText := Format('%s\nFecha creacion: %s\nMensajes publicados: %d',
    [node^.data.name, node^.data.date, node^.data.countM]);

  SL.Add(Format('%s [label="%s", shape=record, style="filled,rounded", fillcolor="#fdfcf5", color="#e28743"];',
    [nodeName, StringReplace(labelText, '"', '\"', [rfReplaceAll])]));


  if node^.left <> nil then
  begin
    leftName := 'n' + IntToHex(NativeUInt(node^.left), 8);
    SL.Add(Format('%s -> %s [label=" ", color="#666666", fontcolor="#888888", constraint=true];',
      [nodeName, leftName]));
    WriteNodeDot(node^.left, SL);
  end;


  if node^.right <> nil then
  begin
    rightName := 'n' + IntToHex(NativeUInt(node^.right), 8);
    SL.Add(Format('%s -> %s [label=" ", color="#666666", fontcolor="#888888", constraint=true];',
      [nodeName, rightName]));
    WriteNodeDot(node^.right, SL);
  end;
end;

{CUser}
   constructor CUser.create(aId: Integer; aName,aEmail: string);
   begin
     id := aId;
     name := aName;
     Email := aEmail;
   end;

{ULinkedList}

   constructor ULinkedList.create;
   begin
      cHead := nil;
   end;

   destructor ULinkedList.Destroy;
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

   procedure ULinkedList.add(aUser: CUser);    //agrega un usuario en la lista enlazada
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

   function ULinkedList.findEmail(aEmail: string): CUser;  //encuentra el usuario dentro de la lista enlazada
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

   constructor CMessage.create(aDate,aSender,aMessage: String; aid: Integer);
   begin
     sender := aSender;
     date := aDate;
     message := aMessage;
     id := aid;
   end;

   {MLinkedList}

      constructor MLinkedList.create;
      begin
         wHead := nil;
         co:= 0;
      end;

      procedure MLinkedList.add(aMess: CMessage);     // agrega un mensaje
        var
          newNode, current: nNode;
        begin
          New(newNode);
          newNode^.data := aMess;
          newNode^.next := nil;

          if wHead = nil then
            wHead := newNode
          else
            begin
              current := wHead;
              while current^.next <> nil do
                current := current^.next;
              current^.next := newNode;
            end;
        end;

procedure MLinkedList.messReport(const fileName: string);      // genera el grafico de los mensages
      var
        f: TextFile;
        current: nNode;
        folder, dotFile, pngFile: string;
        aProcess: TProcess;
      begin
        folder := 'Reporte de mensages de la comunidades';
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

          current := whead;
          while current <> nil do
          begin
            Writeln(f, '  "', current^.data.id, '" [label="',
              'Emisario: ', current^.data.sender, '\n',
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
