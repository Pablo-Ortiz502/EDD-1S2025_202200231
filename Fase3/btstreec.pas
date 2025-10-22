unit BTSTreeC;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,circularL;

type
  PBTSNode = ^BTSNode;
  BTSNode = record
    data: Contact;
    height: Integer;
    left, right: PBTSNode;
  end;

  BTSTree = class
  private
    root: PBTSNode;
    function heightNode(N: PBTSNode): Integer;
    function getBalance(N: PBTSNode): Integer;
    function rotateRight(y: PBTSNode): PBTSNode;
    function rotateLeft(x: PBTSNode): PBTSNode;
    function insertNode(N: PBTSNode; con: Contact): PBTSNode;
    function deleteNode(N: PBTSNode; id: Integer): PBTSNode;
    function minValueNode(N: PBTSNode): PBTSNode;
    function searchNode(N: PBTSNode; id: Integer): Contact;
    function MaxInt(a, b: Integer): Integer;

    procedure inorderToList(N: PBTSNode; L: CircularList);
    procedure preorderToList(N: PBTSNode; L: CircularList);
    procedure postorderToList(N: PBTSNode; L: CircularList);


  public
    countT: Integer;
    constructor create;
    procedure Insert(con: Contact);
    procedure Delete(id: Integer);
    function InOrderList: CircularList;
    function PreOrderList: CircularList;
    function PostOrderList: CircularList;
    function FindById(id: Integer): Contact;
  end;

implementation

constructor BTSTree.create;
begin
  countT := 0;
  root := nil;
end;

function BTSTree.MaxInt(a, b: Integer): Integer;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

function BTSTree.heightNode(N: PBTSNode): Integer;
begin
  if N = nil then Exit(0);
  Exit(N^.height);
end;

function BTSTree.getBalance(N: PBTSNode): Integer;
begin
  if N = nil then Exit(0);
  Exit(heightNode(N^.left) - heightNode(N^.right));
end;

function BTSTree.rotateRight(y: PBTSNode): PBTSNode;
var
  x: PBTSNode;
  T2: PBTSNode;
begin
  x := y^.left;
  T2 := x^.right;

  x^.right := y;
  y^.left := T2;

  y^.height := 1 + MaxInt(heightNode(y^.left), heightNode(y^.right));
  x^.height := 1 + MaxInt(heightNode(x^.left), heightNode(x^.right));

  Exit(x);
end;

function BTSTree.rotateLeft(x: PBTSNode): PBTSNode;
var
  y: PBTSNode;
  T2: PBTSNode;
begin
  y := x^.right;
  T2 := y^.left;

  y^.left := x;
  x^.right := T2;

  x^.height := 1 + MaxInt(heightNode(x^.left), heightNode(x^.right));
  y^.height := 1 + MaxInt(heightNode(y^.left), heightNode(y^.right));

  Exit(y);
end;

function BTSTree.insertNode(N: PBTSNode; con: Contact): PBTSNode;
var
  balance: Integer;
begin
  if N = nil then
  begin
    New(N);
    N^.data := con;
    N^.left := nil;
    N^.right := nil;
    N^.height := 1;
    Exit(N);
  end;

  if con.id < N^.data.id then
    N^.left := insertNode(N^.left, con)
  else if con.id > N^.data.id then
    N^.right := insertNode(N^.right, con)
  else
  begin

    N^.data := con;
    Exit(N);
  end;


  N^.height := 1 + MaxInt(heightNode(N^.left), heightNode(N^.right));

  balance := getBalance(N);

  if (balance > 1) and (con.id < N^.left^.data.id) then
    Exit(rotateRight(N));

  if (balance < -1) and (con.id > N^.right^.data.id) then
    Exit(rotateLeft(N));

  if (balance > 1) and (con.id > N^.left^.data.id) then
  begin
    N^.left := rotateLeft(N^.left);
    Exit(rotateRight(N));
  end;

  if (balance < -1) and (con.id < N^.right^.data.id) then
  begin
    N^.right := rotateRight(N^.right);
    Exit(rotateLeft(N));
  end;

  Exit(N);
end;

function BTSTree.searchNode(N: PBTSNode; id: Integer): Contact;
begin
  if N = nil then
    Exit(nil);

  if id = N^.data.id then
    Exit(N^.data)
  else if id < N^.data.id then
    Exit(searchNode(N^.left, id))
  else
    Exit(searchNode(N^.right, id));
end;

function BTSTree.FindById(id: Integer): Contact;
begin
  Result := searchNode(root, id);
end;

function BTSTree.minValueNode(N: PBTSNode): PBTSNode;
begin
  while (N^.left <> nil) do
    N := N^.left;
  Result := N;
end;

function BTSTree.deleteNode(N: PBTSNode; id: Integer): PBTSNode;
var
  balance: Integer;
  temp: PBTSNode;
begin
  if N = nil then Exit(nil);

  if id < N^.data.id then
    N^.left := deleteNode(N^.left, id)
  else if id > N^.data.id then
    N^.right := deleteNode(N^.right, id)
  else
  begin

    if (N^.left = nil) or (N^.right = nil) then
    begin
      if N^.left <> nil then
        temp := N^.left
      else
        temp := N^.right;

      if temp = nil then
      begin

        Dispose(N);
        Exit(nil);
      end
      else
      begin

        N^ := temp^;
        Dispose(temp);
      end;
    end
    else
    begin

      temp := minValueNode(N^.right);
      N^.data := temp^.data;
      N^.right := deleteNode(N^.right, temp^.data.id);
    end;
  end;


  N^.height := 1 + MaxInt(heightNode(N^.left), heightNode(N^.right));

  balance := getBalance(N);

  if (balance > 1) and (getBalance(N^.left) >= 0) then
    Exit(rotateRight(N));

  if (balance > 1) and (getBalance(N^.left) < 0) then
  begin
    N^.left := rotateLeft(N^.left);
    Exit(rotateRight(N));
  end;

  if (balance < -1) and (getBalance(N^.right) <= 0) then
    Exit(rotateLeft(N));

  if (balance < -1) and (getBalance(N^.right) > 0) then
  begin
    N^.right := rotateRight(N^.right);
    Exit(rotateLeft(N));
  end;

  Exit(N);
end;

procedure BTSTree.Insert(con: Contact);
begin
  root := insertNode(root, con);
end;

procedure BTSTree.Delete(id: Integer);
begin
  root := deleteNode(root, id);
end;


procedure BTSTree.inorderToList(N: PBTSNode; L: CircularList);
begin
  if N = nil then Exit;
  inorderToList(N^.left, L);
  L.add(N^.data);
  inorderToList(N^.right, L);
end;

procedure BTSTree.preorderToList(N: PBTSNode; L: CircularList);
begin
  if N = nil then Exit;
  L.add(N^.data);
  preorderToList(N^.left, L);
  preorderToList(N^.right, L);
end;

procedure BTSTree.postorderToList(N: PBTSNode; L: CircularList);
begin
  if N = nil then Exit;
  postorderToList(N^.left, L);
  postorderToList(N^.right, L);
  L.add(N^.data);
end;


function BTSTree.InOrderList: CircularList;
begin
  Result := CircularList.Create;
  inorderToList(root, Result);
end;

function BTSTree.PreOrderList: CircularList;
begin
  Result := CircularList.Create;
  preorderToList(root, Result);
end;

function BTSTree.PostOrderList: CircularList;
begin
  Result := CircularList.Create;
  postorderToList(root, Result);
end;

end.
