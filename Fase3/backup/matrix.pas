unit matrix;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Process;

type
  mNode = ^mmNode;
  mmNode = record
    row, col: Integer;
    value: Integer;
    right, down: mNode;
  end;

  hNode = ^hhNode;
  hhNode = record
    index: Integer;
    email: string;
    next: hNode;
    first: mNode;
  end;

  MatrixL = class
  private
    rowHeaders, colHeaders: hNode;
    function GetHeader(var head: hNode; index: Integer; email: string): hNode;
  public
    constructor create;
    procedure Insert(row, col,value: Integer; rowEmail, colEmail: string);
    function FindNode(row, col: Integer): mNode;
    procedure relationRerport(const fileName: string);
  end;

implementation


constructor MatrixL.create;
begin
  rowHeaders := nil;
  colHeaders := nil;
end;


function MatrixL.GetHeader(var head: hNode; index: Integer; email: string): hNode;
var
  current, prev, newHeader: hNode;
begin
  prev := nil;


  if head = nil then
  begin
    New(newHeader);
    newHeader^.index := index;
    newHeader^.email := email;
    newHeader^.next := nil;
    newHeader^.first := nil;

    head := newHeader;
    Result := newHeader;
    Exit;
  end;


  current := head;
  while current <> nil do
  begin
    if current^.index = index then
    begin
      Result := current;
      Exit;
    end;
    prev := current;
    current := current^.next;
  end;


  New(newHeader);
  newHeader^.index := index;
  newHeader^.email := email;
  newHeader^.next := nil;
  newHeader^.first := nil;

  prev^.next := newHeader;
  Result := newHeader;
end;

procedure MatrixL.Insert(row, col,value: Integer;rowEmail, colEmail: string);
var
  rowHeader, colHeader: hNode;
  newNode, current, prev: mNode;
begin
  rowHeader := GetHeader(rowHeaders, row, rowEmail);
  colHeader := GetHeader(colHeaders, col, colEmail);


  current := rowHeader^.first;
  while (current <> nil) and (current^.col < col) do
    current := current^.right;

  if (current <> nil) and (current^.col = col) then
  begin
    Exit;
  end;


  New(newNode);
  newNode^.row := row;
  newNode^.col := col;
  newNode^.value := value;
  newNode^.right := nil;
  newNode^.down := nil;


  current := rowHeader^.first;
  prev := nil;
  while (current <> nil) and (current^.col < col) do
  begin
    prev := current;
    current := current^.right;
  end;
  if prev = nil then
    rowHeader^.first := newNode
  else
    prev^.right := newNode;
  newNode^.right := current;


  current := colHeader^.first;
  prev := nil;
  while (current <> nil) and (current^.row < row) do
  begin
    prev := current;
    current := current^.down;
  end;
  if prev = nil then
    colHeader^.first := newNode
  else
    prev^.down := newNode;
  newNode^.down := current;
end;


function MatrixL.FindNode(row, col: Integer): mNode;
var
  rowHeader: hNode;
  current: mNode;
begin
  rowHeader := rowHeaders;
  while (rowHeader <> nil) and (rowHeader^.index <> row) do
    rowHeader := rowHeader^.next;

  if rowHeader = nil then
  begin
    Result := nil;
    Exit;
  end;

  current := rowHeader^.first;
  while (current <> nil) do
  begin
    if current^.col = col then
    begin
      Result := current;
      Exit;
    end;
    current := current^.right;
  end;

  Result := nil;
end;


procedure MatrixL.relationRerport(const fileName: string);
var
  f: TextFile;
  row, col: hNode;
  node: mNode;
  folder, dotFile, pngFile: string;
  aProcess: TProcess;
begin
  folder := 'reporte_relaciones';

  if not DirectoryExists(folder) then
    CreateDir(folder);

  dotFile := folder + '/' + fileName + '.dot';
  pngFile := folder + '/' + fileName + '.png';

  AssignFile(f, dotFile);
  Rewrite(f);

  Writeln(f, 'digraph G {');
  Writeln(f, '  rankdir=LR;');
  Writeln(f, '  node [shape=box style=filled fontname="Arial"];');


  col := colHeaders;
  while col <> nil do
  begin
    Writeln(f, '  "C', col^.index, '" [label="', col^.email, '" fillcolor=lightblue];');
    col := col^.next;
  end;


  row := rowHeaders;
  while row <> nil do
  begin
    Writeln(f, '  "R', row^.index, '" [label="', row^.email, '" fillcolor=lightgreen];');
    row := row^.next;
  end;


  row := rowHeaders;
  while row <> nil do
  begin
    node := row^.first;
    while node <> nil do
    begin
      Writeln(f, '  "N', node^.row, '_', node^.col, '" [label="', node^.value, '" fillcolor=orange];');


      Writeln(f, '  "R', node^.row, '" -> "N', node^.row, '_', node^.col, '";');
      Writeln(f, '  "C', node^.col, '" -> "N', node^.row, '_', node^.col, '";');

      node := node^.right;
    end;
    row := row^.next;
  end;

  Writeln(f, '}');
  CloseFile(f);

  { Generar PNG con Graphviz }
  aProcess := TProcess.Create(nil);
  try
    aProcess.Executable := 'dot';
    aProcess.Parameters.Add('-Tpng');
    aProcess.Parameters.Add(dotFile);
    aProcess.Parameters.Add('-o');
    aProcess.Parameters.Add(pngFile);
    aProcess.Options := [poWaitOnExit];
    aProcess.Execute;
  finally
    aProcess.Free;
  end;
end;

end.
