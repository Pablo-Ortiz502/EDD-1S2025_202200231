unit block;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Process, MessageClasss, DCPsha256, DCPcrypt2;

type
  PBlock = ^TBlock;
  TBlock = record
    Index: Integer;
    Timestamp: String;
    Data: Message;
    Nonce: Integer;
    PreviousHash: String;
    Hash: String;
    Next: PBlock;
  end;

  TBlockChain = class
  private
    FHead: PBlock;
    function CalculateHash(aBlock: PBlock): String;
    procedure FreeAll;
    function ProofOfWork(aBlock: PBlock; difficulty: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddBlock(aMessage: Message; difficulty: Integer = 4);
    procedure PrintChain;
    procedure GraphChain(const fileName: string);
    property Head: PBlock read FHead;
  end;

implementation

{ TBlockChain }

constructor TBlockChain.Create;
begin
  inherited Create;
  FHead := nil;
end;

destructor TBlockChain.Destroy;
begin
  FreeAll;
  inherited Destroy;
end;

procedure TBlockChain.FreeAll;
var
  tmp: PBlock;
begin
  while FHead <> nil do
  begin
    tmp := FHead;
    FHead := FHead^.Next;
    Dispose(tmp);
  end;
end;

function TBlockChain.CalculateHash(aBlock: PBlock): String;
var
  input: String;
  SHA: TDCP_sha256;
  Digest: array[0..31] of byte;
  i: Integer;
  s: String;
begin
  input := IntToStr(aBlock^.Index) +
           aBlock^.Timestamp +
           IntToStr(aBlock^.Data.id) +
           aBlock^.Data.sender +
           aBlock^.Data.subject +
           aBlock^.Data.message +
           IntToStr(aBlock^.Nonce) +
           aBlock^.PreviousHash;

  SHA := TDCP_sha256.Create(nil);
  try
    SHA.Init;
    SHA.UpdateStr(input);
    SHA.Final(Digest);
  finally
    SHA.Free;
  end;

  s := '';
  for i := 0 to 31 do
    s := s + IntToHex(Digest[i],2);
  Result := LowerCase(s);
end;

function TBlockChain.ProofOfWork(aBlock: PBlock; difficulty: Integer): Integer;
var
  target: String;
begin
  target := StringOfChar('0', difficulty);
  aBlock^.Nonce := 0;
  while True do
  begin
    aBlock^.Hash := CalculateHash(aBlock);
    if Copy(aBlock^.Hash,1,difficulty) = target then
      Break;
    Inc(aBlock^.Nonce);
  end;
  Result := aBlock^.Nonce;
end;

procedure TBlockChain.AddBlock(aMessage: Message; difficulty: Integer);
var
  newBlock: PBlock;
begin
  New(newBlock);
  newBlock^.Data := aMessage;
  newBlock^.Next := FHead;

  if FHead = nil then
    newBlock^.Index := 0
  else
    newBlock^.Index := FHead^.Index + 1;

  newBlock^.Timestamp := FormatDateTime('dd-mm-yy::hh:nn:ss', Now);
  if FHead = nil then
    newBlock^.PreviousHash := '0000'
  else
    newBlock^.PreviousHash := FHead^.Hash;

  newBlock^.Nonce := 0;
  newBlock^.Hash := '';
  ProofOfWork(newBlock, difficulty);

  FHead := newBlock;
end;

procedure TBlockChain.PrintChain;
var
  cur: PBlock;
begin
  cur := FHead;
  while cur <> nil do
  begin
    Writeln('--- Block ', cur^.Index, ' ---');
    Writeln('Timestamp: ', cur^.Timestamp);
    Writeln('Data.ID: ', cur^.Data.id);
    Writeln('Sender: ', cur^.Data.sender);
    Writeln('Subject: ', cur^.Data.subject);
    Writeln('Message: ', cur^.Data.message);
    Writeln('Nonce: ', cur^.Nonce);
    Writeln('Previous Hash: ', cur^.PreviousHash);
    Writeln('Hash: ', cur^.Hash);
    Writeln;
    cur := cur^.Next;
  end;
end;

procedure TBlockChain.GraphChain(const fileName: string);
var
  folder, dotFile, pngFile: string;
  f: TextFile;
  cur: PBlock;
  proc: TProcess;
  labelText: string;
begin
  if FHead = nil then Exit;

  folder := 'blockchain';
  if not DirectoryExists(folder) then
    if not CreateDir(folder) then
      raise Exception.CreateFmt('No se pudo crear la carpeta: %s', [folder]);

  dotFile := folder + PathDelim + fileName + '.dot';
  pngFile := folder + PathDelim + fileName + '.png';

  AssignFile(f, dotFile);
  Rewrite(f);
  try
    Writeln(f,'digraph Blockchain {');
    Writeln(f,'rankdir=LR;');
    Writeln(f,'node [shape=record, style=filled, fillcolor=lightyellow, fontname="Arial"];');

    cur := FHead;
    while cur <> nil do
    begin
      labelText := Format('Index: %d\nTimestamp: %s\nID: %d\nSender: %s\nSubject: %s\nMessage: %s\nNonce: %d\nPrevHash: %s\nHash: %s',
        [cur^.Index, cur^.Timestamp, cur^.Data.id,
         StringReplace(cur^.Data.sender,'"','\"',[rfReplaceAll]),
         StringReplace(cur^.Data.subject,'"','\"',[rfReplaceAll]),
         StringReplace(cur^.Data.message,'"','\"',[rfReplaceAll]),
         cur^.Nonce, cur^.PreviousHash, cur^.Hash]);

      Writeln(f, Format('"%d" [label="%s"];',[cur^.Index,labelText]));

      if cur^.Next <> nil then
        Writeln(f, Format('"%d" -> "%d";',[cur^.Index, cur^.Next^.Index]));

      cur := cur^.Next;
    end;

    Writeln(f,'}');
  finally
    CloseFile(f);
  end;

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

  Writeln('✅ Gráfico generado: ', pngFile);
end;

end.
