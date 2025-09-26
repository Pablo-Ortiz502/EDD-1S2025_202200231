unit avlTree;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, MessageClasss, Unit5;

type
  PAVLNode = ^AVLNode;
  AVLNode = record
    data: Message;
    height: Integer;
    left, right: PAVLNode;
  end;

  AVLTrees = class
  private
    root: PAVLNode;
    function heightNode(N: PAVLNode): Integer;
    function getBalance(N: PAVLNode): Integer;
    function rotateRight(y: PAVLNode): PAVLNode;
    function rotateLeft(x: PAVLNode): PAVLNode;
    function insertNode(N: PAVLNode; msg: Message): PAVLNode;
    function deleteNode(N: PAVLNode; id: Integer): PAVLNode;
    function minValueNode(N: PAVLNode): PAVLNode;
    function searchNode(N: PAVLNode; id: Integer): Message;
    function MaxInt(a, b: Integer): Integer;

    procedure inorderToList(N: PAVLNode; L: DoubleList);
    procedure preorderToList(N: PAVLNode; L: DoubleList);
    procedure postorderToList(N: PAVLNode; L: DoubleList);


  public
    countT: Integer;
    constructor create;
    procedure Insert(msg: Message);
    procedure Delete(id: Integer);
    function InOrderList: DoubleList;
    function PreOrderList: DoubleList;
    function PostOrderList: DoubleList;
    function FindById(id: Integer): Message;
  end;

implementation

constructor AVLTrees.create;
begin
  countT := 0;
  root := nil;
end;

function AVLTrees.MaxInt(a, b: Integer): Integer;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

function AVLTrees.heightNode(N: PAVLNode): Integer;
begin
  if N = nil then Exit(0);
  Exit(N^.height);
end;

function AVLTrees.getBalance(N: PAVLNode): Integer;
begin
  if N = nil then Exit(0);
  Exit(heightNode(N^.left) - heightNode(N^.right));
end;

function AVLTrees.rotateRight(y: PAVLNode): PAVLNode;
var
  x: PAVLNode;
  T2: PAVLNode;
begin
  x := y^.left;
  T2 := x^.right;

  x^.right := y;
  y^.left := T2;

  y^.height := 1 + MaxInt(heightNode(y^.left), heightNode(y^.right));
  x^.height := 1 + MaxInt(heightNode(x^.left), heightNode(x^.right));

  Exit(x);
end;

function AVLTrees.rotateLeft(x: PAVLNode): PAVLNode;
var
  y: PAVLNode;
  T2: PAVLNode;
begin
  y := x^.right;
  T2 := y^.left;

  y^.left := x;
  x^.right := T2;

  x^.height := 1 + MaxInt(heightNode(x^.left), heightNode(x^.right));
  y^.height := 1 + MaxInt(heightNode(y^.left), heightNode(y^.right));

  Exit(y);
end;

function AVLTrees.insertNode(N: PAVLNode; msg: Message): PAVLNode;
var
  balance: Integer;
begin
  if N = nil then
  begin
    New(N);
    N^.data := msg;
    N^.left := nil;
    N^.right := nil;
    N^.height := 1;
    Exit(N);
  end;

  if msg.id < N^.data.id then
    N^.left := insertNode(N^.left, msg)
  else if msg.id > N^.data.id then
    N^.right := insertNode(N^.right, msg)
  else
  begin

    N^.data := msg;
    Exit(N);
  end;


  N^.height := 1 + MaxInt(heightNode(N^.left), heightNode(N^.right));

  balance := getBalance(N);

  if (balance > 1) and (msg.id < N^.left^.data.id) then
    Exit(rotateRight(N));

  if (balance < -1) and (msg.id > N^.right^.data.id) then
    Exit(rotateLeft(N));

  if (balance > 1) and (msg.id > N^.left^.data.id) then
  begin
    N^.left := rotateLeft(N^.left);
    Exit(rotateRight(N));
  end;

  if (balance < -1) and (msg.id < N^.right^.data.id) then
  begin
    N^.right := rotateRight(N^.right);
    Exit(rotateLeft(N));
  end;

  Exit(N);
end;

function AVLTrees.searchNode(N: PAVLNode; id: Integer): Message;
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

function AVLTrees.FindById(id: Integer): Message;
begin
  Result := searchNode(root, id);
end;

function AVLTrees.minValueNode(N: PAVLNode): PAVLNode;
begin
  while (N^.left <> nil) do
    N := N^.left;
  Result := N;
end;

function AVLTrees.deleteNode(N: PAVLNode; id: Integer): PAVLNode;
var
  balance: Integer;
  temp: PAVLNode;
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

procedure AVLTrees.Insert(msg: Message);
begin
  root := insertNode(root, msg);
end;

procedure AVLTrees.Delete(id: Integer);
begin
  root := deleteNode(root, id);
end;


procedure AVLTrees.inorderToList(N: PAVLNode; L: DoubleList);
begin
  if N = nil then Exit;
  inorderToList(N^.left, L);
  L.add(N^.data,N^.data.id);
  inorderToList(N^.right, L);
end;

procedure AVLTrees.preorderToList(N: PAVLNode; L: DoubleList);
begin
  if N = nil then Exit;
  L.add(N^.data,N^.data.id);
  preorderToList(N^.left, L);
  preorderToList(N^.right, L);
end;

procedure AVLTrees.postorderToList(N: PAVLNode; L: DoubleList);
begin
  if N = nil then Exit;
  postorderToList(N^.left, L);
  postorderToList(N^.right, L);
  L.add(N^.data,N^.data.id);
end;


function AVLTrees.InOrderList: DoubleList;
begin
  Result := DoubleList.Create;
  inorderToList(root, Result);
end;

function AVLTrees.PreOrderList: DoubleList;
begin
  Result := DoubleList.Create;
  preorderToList(root, Result);
end;

function AVLTrees.PostOrderList: DoubleList;
begin
  Result := DoubleList.Create;
  postorderToList(root, Result);
end;

end.
