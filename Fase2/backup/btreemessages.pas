unit BTreeMessages;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, MessageClasss, Unit5,Process, Classes;

const
  ORDER = 5;

type
  PBTreeNode = ^TBTreeNode;
  TBTreeNode = record
    keys: array[0..ORDER-2] of Message;
    children: array[0..ORDER-1] of PBTreeNode;
    n: Integer;
    leaf: Boolean;
  end;

  B5Tree = class
  private
    root: PBTreeNode;
    function NewNode(leaf: Boolean): PBTreeNode;
    procedure SplitChild(x: PBTreeNode; i: Integer; y: PBTreeNode);
    procedure InsertNonFull(x: PBTreeNode; k: Message);
    procedure InOrderTraverse(x: PBTreeNode; L: DoubleList);
    procedure DeleteNode(x: PBTreeNode; k: Integer);
    function GetPredecessor(x: PBTreeNode; idx: Integer): Message;
    function GetSuccessor(x: PBTreeNode; idx: Integer): Message;
    procedure Merge(x: PBTreeNode; idx: Integer);
    procedure Fill(x: PBTreeNode; idx: Integer);
    procedure BorrowFromPrev(x: PBTreeNode; idx: Integer);
    procedure BorrowFromNext(x: PBTreeNode; idx: Integer);
  public
    property aRoot: PBTreeNode  read root;
    constructor Create;
    procedure Insert(k: Message);
    procedure Delete(k: Integer);
    function ToDoubleList: DoubleList;
    procedure GenerateGraph(const userName: string);
  end;

implementation


function B5Tree.NewNode(leaf: Boolean): PBTreeNode;
var
  i: Integer;
  node: PBTreeNode;
begin
  New(node);
  node^.leaf := leaf;
  node^.n := 0;
  for i := 0 to ORDER-1 do
    node^.children[i] := nil;
  Result := node;
end;

constructor B5Tree.Create;
begin
  root := nil;
end;


procedure B5Tree.Insert(k: Message);
var
  r, s: PBTreeNode;
begin
  if root = nil then
  begin
    root := NewNode(True);
    root^.keys[0] := k;
    root^.n := 1;
  end
  else
  begin
    r := root;
    if r^.n = ORDER-1 then
    begin
      s := NewNode(False);
      root := s;
      s^.children[0] := r;
      SplitChild(s, 0, r);
      InsertNonFull(s, k);
    end
    else
      InsertNonFull(r, k);
  end;
end;

procedure B5Tree.SplitChild(x: PBTreeNode; i: Integer; y: PBTreeNode);
var
  z: PBTreeNode;
  j: Integer;
  mid: Integer;
begin
  z := NewNode(y^.leaf);
  mid := (ORDER-1) div 2;

  z^.n := (ORDER-1) - mid - 1;


  for j := 0 to z^.n-1 do
    z^.keys[j] := y^.keys[j+mid+1];


  if not y^.leaf then
  begin
    for j := 0 to z^.n do
      z^.children[j] := y^.children[j+mid+1];
  end;

  y^.n := mid;


  for j := x^.n downto i+1 do
    x^.children[j+1] := x^.children[j];
  x^.children[i+1] := z;


  for j := x^.n-1 downto i do
    x^.keys[j+1] := x^.keys[j];
  x^.keys[i] := y^.keys[mid];
  Inc(x^.n);
end;

procedure B5Tree.InsertNonFull(x: PBTreeNode; k: Message);
var
  i: Integer;
begin
  i := x^.n-1;

  if x^.leaf then
  begin
    while (i >= 0) and (k.id < x^.keys[i].id) do
    begin
      x^.keys[i+1] := x^.keys[i];
      Dec(i);
    end;
    x^.keys[i+1] := k;
    Inc(x^.n);
  end
  else
  begin
    while (i >= 0) and (k.id < x^.keys[i].id) do
      Dec(i);
    Inc(i);

    if (x^.children[i] <> nil) and (x^.children[i]^.n = ORDER-1) then
    begin
      SplitChild(x, i, x^.children[i]);
      if k.id > x^.keys[i].id then
        Inc(i);
    end;

    if x^.children[i] = nil then
      x^.children[i] := NewNode(True);

    InsertNonFull(x^.children[i], k);
  end;
end;


procedure B5Tree.Delete(k: Integer);
begin
  if root = nil then Exit;
  DeleteNode(root, k);

  if (root^.n = 0) then
  begin
    if root^.leaf then
    begin
      Dispose(root);
      root := nil;
    end
    else
    begin
      root := root^.children[0];
    end;
  end;
end;

procedure B5Tree.DeleteNode(x: PBTreeNode; k: Integer);
var
  idx: Integer;
  key: Message;
begin
  idx := 0;
  while (idx < x^.n) and (k > x^.keys[idx].id) do
    Inc(idx);

  if (idx < x^.n) and (x^.keys[idx].id = k) then
  begin
    if x^.leaf then
    begin

      Dec(x^.n);
      while idx < x^.n do
      begin
        x^.keys[idx] := x^.keys[idx+1];
        Inc(idx);
      end;
    end
    else
    begin

      if (x^.children[idx]^.n >= (ORDER div 2)) then
      begin
        key := GetPredecessor(x, idx);
        x^.keys[idx] := key;
        DeleteNode(x^.children[idx], key.id);
      end
      else if (x^.children[idx+1]^.n >= (ORDER div 2)) then
      begin
        key := GetSuccessor(x, idx);
        x^.keys[idx] := key;
        DeleteNode(x^.children[idx+1], key.id);
      end
      else
      begin
        Merge(x, idx);
        DeleteNode(x^.children[idx], k);
      end;
    end;
  end
  else
  begin
    if x^.leaf then Exit;

    if (x^.children[idx]^.n < (ORDER div 2)) then
      Fill(x, idx);

    if idx > x^.n then
      DeleteNode(x^.children[idx-1], k)
    else
      DeleteNode(x^.children[idx], k);
  end;
end;

function B5Tree.GetPredecessor(x: PBTreeNode; idx: Integer): Message;
var
  cur: PBTreeNode;
begin
  cur := x^.children[idx];
  while not cur^.leaf do
    cur := cur^.children[cur^.n];
  Result := cur^.keys[cur^.n-1];
end;

function B5Tree.GetSuccessor(x: PBTreeNode; idx: Integer): Message;
var
  cur: PBTreeNode;
begin
  cur := x^.children[idx+1];
  while not cur^.leaf do
    cur := cur^.children[0];
  Result := cur^.keys[0];
end;

procedure B5Tree.Merge(x: PBTreeNode; idx: Integer);
var
  child, sibling: PBTreeNode;
  i: Integer;
begin
  child := x^.children[idx];
  sibling := x^.children[idx+1];

  child^.keys[(ORDER div 2)-1] := x^.keys[idx];

  for i := 0 to sibling^.n-1 do
    child^.keys[i+(ORDER div 2)] := sibling^.keys[i];

  if not child^.leaf then
    for i := 0 to sibling^.n do
      child^.children[i+(ORDER div 2)] := sibling^.children[i];

  for i := idx+1 to x^.n-1 do
    x^.keys[i-1] := x^.keys[i];

  for i := idx+2 to x^.n do
    x^.children[i-1] := x^.children[i];

  child^.n := child^.n + sibling^.n + 1;
  Dec(x^.n);

  Dispose(sibling);
end;

procedure B5Tree.Fill(x: PBTreeNode; idx: Integer);
begin
  if (idx <> 0) and (x^.children[idx-1]^.n >= (ORDER div 2)) then
    BorrowFromPrev(x, idx)
  else if (idx <> x^.n) and (x^.children[idx+1]^.n >= (ORDER div 2)) then
    BorrowFromNext(x, idx)
  else
  begin
    if idx <> x^.n then
      Merge(x, idx)
    else
      Merge(x, idx-1);
  end;
end;

procedure B5Tree.BorrowFromPrev(x: PBTreeNode; idx: Integer);
var
  child, sibling: PBTreeNode;
  i: Integer;
begin
  child := x^.children[idx];
  sibling := x^.children[idx-1];

  for i := child^.n-1 downto 0 do
    child^.keys[i+1] := child^.keys[i];

  if not child^.leaf then
    for i := child^.n downto 0 do
      child^.children[i+1] := child^.children[i];

  child^.keys[0] := x^.keys[idx-1];

  if not child^.leaf then
    child^.children[0] := sibling^.children[sibling^.n];

  x^.keys[idx-1] := sibling^.keys[sibling^.n-1];

  Inc(child^.n);
  Dec(sibling^.n);
end;

procedure B5Tree.BorrowFromNext(x: PBTreeNode; idx: Integer);
var
  child, sibling: PBTreeNode;
  i: Integer;
begin
  child := x^.children[idx];
  sibling := x^.children[idx+1];

  child^.keys[child^.n] := x^.keys[idx];

  if not child^.leaf then
    child^.children[child^.n+1] := sibling^.children[0];

  x^.keys[idx] := sibling^.keys[0];

  for i := 1 to sibling^.n-1 do
    sibling^.keys[i-1] := sibling^.keys[i];

  if not sibling^.leaf then
    for i := 1 to sibling^.n do
      sibling^.children[i-1] := sibling^.children[i];

  Inc(child^.n);
  Dec(sibling^.n);
end;


procedure B5Tree.InOrderTraverse(x: PBTreeNode; L: DoubleList);
var
  i: Integer;
begin
  if x = nil then Exit;

  for i := 0 to x^.n-1 do
  begin
    InOrderTraverse(x^.children[i], L);
    if x^.keys[i] <> nil then
      L.add(x^.keys[i],x^.keys[i].id);
  end;

  InOrderTraverse(x^.children[x^.n], L);
end;

function B5Tree.ToDoubleList: DoubleList;
begin
  Result := DoubleList.Create;
  InOrderTraverse(root, Result);
end;


procedure B5Tree.GenerateGraph(const userName: string);
  procedure writeNodeDot(N: PBTreeNode; SL: TStringList);
  var
    nodeName, labelText: string;
    i: Integer;
    minKeys, maxKeys: Integer;
  begin
    if N = nil then Exit;

    nodeName := 'n' + IntToHex(NativeUInt(N), 8);
    labelText := '';

    // Calcula mínimos y máximos de claves para este nodo
    if N = root then
       minkeys := 1
    else
       minkeys := (ORDER div 2)-1;
    maxKeys := ORDER - 1;

    labelText := Format('Min: %d\nMax: %d\nKeys: %d\n', [minKeys, maxKeys, N^.n]);

    for i := 0 to N^.n - 1 do
    begin
      // Truncar textos largos para que no se deformen los nodos
      labelText += Format('ID: %d\nRem: %s\nAsu: %s\nMsg: %s',
        [N^.keys[i].id,
         Copy(N^.keys[i].sender,1,10),
         Copy(N^.keys[i].subject,1,15),
         Copy(N^.keys[i].message,1,20)]);
      if i < N^.n - 1 then
        labelText += '\n---\n';
    end;

    SL.Add(Format('%s [label="%s", shape=record, style=filled, fillcolor=lightgreen, fontname="Arial"];',
      [nodeName, StringReplace(labelText, '"', '\"', [rfReplaceAll])]));

    // Conecta los hijos
    for i := 0 to N^.n do
    begin
      if N^.children[i] <> nil then
      begin
        SL.Add(Format('%s -> %s;', [nodeName, 'n' + IntToHex(NativeUInt(N^.children[i]), 8)]));
        writeNodeDot(N^.children[i], SL);
      end;
    end;
  end;

var
  SL: TStringList;
  dotFile, pngFile, userFolder: string;
  proc: TProcess;
begin
  if root = nil then Exit;

  userFolder := 'Reportes/' + userName;
  ForceDirectories(userFolder);

  dotFile := userFolder + '/BTree_' + userName + '.dot';
  pngFile := userFolder + '/BTree_' + userName + '.png';

  SL := TStringList.Create;
  try
    SL.Add('digraph G {');
    SL.Add('rankdir=TB;');
    SL.Add('labelloc="t";');
    SL.Add('label="Correos Favoritos (Árbol B de Orden 5)";');
    SL.Add('node [fontname="Arial"];');
    writeNodeDot(root, SL);
    SL.Add('}');
    SL.SaveToFile(dotFile);

    // Ejecuta Graphviz para generar PNG
    proc := TProcess.Create(nil);
    try
      proc.Executable := 'dot';
      proc.Parameters.Add('-Tpng');
      proc.Parameters.Add(dotFile);
      proc.Parameters.Add('-o');
      proc.Parameters.Add(pngFile);
      proc.Options := proc.Options + [poWaitOnExit];
      proc.Execute;
    finally
      proc.Free;
    end;
  finally
    SL.Free;
  end;
end;

end.
