unit merckeTree;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Process, MessageClasss, Unit5;

type
  TMerkleNode = class
  public
    HashValue: String;
    Left, Right: TMerkleNode;
    MsgData: Message;
    constructor Create(aMsg: Message);
  end;

  TMerkleTree = class
  private
    FRoot: TMerkleNode;
    function HashCombine(const leftHash, rightHash: String): String;
    function CalculateHash(const input: String): String;
    procedure FreeNode(node: TMerkleNode);
    procedure BuildTree(msgList: DoubleList);
  public
    constructor Create(msgList: DoubleList);
    destructor Destroy; override;
    procedure GraphMerkleTree(const fileName: string);
    property Root: TMerkleNode read FRoot;
  end;

implementation

uses
  md5;

{ TMerkleNode }

constructor TMerkleNode.Create(aMsg: Message);
begin
  Left := nil;
  Right := nil;
  MsgData := aMsg;
  if aMsg <> nil then
    HashValue := MD5Print(MD5String(aMsg.sender + aMsg.subject + aMsg.date + aMsg.message))
  else
    HashValue := '';
end;

{ TMerkleTree }

constructor TMerkleTree.Create(msgList: DoubleList);
begin
  FRoot := nil;
  if (msgList = nil) or (msgList.aHead = nil) then
  begin
    Exit;
  end;
  BuildTree(msgList);
end;

destructor TMerkleTree.Destroy;
begin
  FreeNode(FRoot);
  inherited;
end;

procedure TMerkleTree.FreeNode(node: TMerkleNode);
begin
  if node = nil then Exit;
  FreeNode(node.Left);
  FreeNode(node.Right);
  node.Free;
end;

function TMerkleTree.CalculateHash(const input: String): String;
begin
  Result := MD5Print(MD5String(input));
end;

function TMerkleTree.HashCombine(const leftHash, rightHash: String): String;
begin
  Result := CalculateHash(leftHash + rightHash);
end;

procedure TMerkleTree.BuildTree(msgList: DoubleList);
var
  Leaves, NextLevel: TList;
  current: DNode;
  leftNode, rightNode, parentNode, extraNode: TMerkleNode;
  i: Integer;
begin
  Leaves := TList.Create;
  try
    current := msgList.aHead;
    while current <> nil do
    begin
      Leaves.Add(TMerkleNode.Create(current^.data));
      current := current^.next;
    end;

    if Leaves.Count = 1 then
    begin
      FRoot := TMerkleNode(Leaves[0]);
      Exit;
    end;

    while Leaves.Count > 1 do
    begin
      NextLevel := TList.Create;
      try
        for i := 0 to (Leaves.Count div 2) - 1 do
        begin
          leftNode := TMerkleNode(Leaves[2 * i]);
          rightNode := TMerkleNode(Leaves[2 * i + 1]);

          parentNode := TMerkleNode.Create(nil);
          parentNode.Left := leftNode;
          parentNode.Right := rightNode;
          parentNode.HashValue := HashCombine(leftNode.HashValue, rightNode.HashValue);
          NextLevel.Add(parentNode);
        end;


        if (Leaves.Count mod 2) <> 0 then
        begin
          rightNode := TMerkleNode(Leaves.Last);
          extraNode := TMerkleNode.Create(nil);
          extraNode.Left := rightNode;
          extraNode.Right := nil;
          extraNode.HashValue := rightNode.HashValue;
          NextLevel.Add(extraNode);
        end;
      finally
        Leaves.Free;
        Leaves := NextLevel;
      end;
    end;

    FRoot := TMerkleNode(Leaves[0]);
  finally
    Leaves.Free;
  end;
end;

procedure TMerkleTree.GraphMerkleTree(const fileName: string);
var
  folder, dotFile, pngFile: string;
  f: TextFile;
  aProcess: TProcess;

  procedure WriteNode(node: TMerkleNode);
  begin
    if node = nil then Exit;

    if (node.Left = nil) and (node.Right = nil) then
    begin
      Writeln(f, '  "', node.HashValue, '" [shape=record, style=filled, fillcolor=lightgreen,',
              'label="Sender: ', node.MsgData.sender, '\nAsunto: ', node.MsgData.subject,
              '\nFecha: ', node.MsgData.date, '\nHash: ', Copy(node.HashValue, 1, 12), '..."];');
    end
    else
    begin
      Writeln(f, '  "', node.HashValue, '" [shape=ellipse, style=filled, fillcolor=lightblue,',
              'label="', Copy(node.HashValue, 1, 12), '..."];');
    end;

    if node.Left <> nil then
    begin
      Writeln(f, '  "', node.HashValue, '" -> "', node.Left.HashValue, '";');
      WriteNode(node.Left);
    end;

    if node.Right <> nil then
    begin
      Writeln(f, '  "', node.HashValue, '" -> "', node.Right.HashValue, '";');
      WriteNode(node.Right);
    end;
  end;

begin
  if FRoot = nil then
  begin
    Exit;
  end;

  folder := 'Reporte de privados';
  if not DirectoryExists(folder) then
    CreateDir(folder);

  dotFile := folder + '/' + fileName + '.dot';
  pngFile := folder + '/' + fileName + '.png';

  AssignFile(f, dotFile);
  Rewrite(f);
  try
    Writeln(f, 'digraph MerkleTree {');
    Writeln(f, '  node [fontname="Arial"];');
    WriteNode(FRoot);
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
