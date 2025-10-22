unit MessageClasss;

{$mode ObjFPC}{$H+}

interface


uses
  Classes, SysUtils, FileUtil;

type
  Message = class
  public
    id: Integer;
    sender: String;
    subject: String;
    date: String;
    stateR: Boolean;
    message: String;
    fav:Boolean;

    constructor Create(aDate, aSender, aSubject, aMessage: String; aState: Boolean);
    procedure DownloadCompressed;
    function Decompress(const fileName: string): string;
  end;

implementation

constructor Message.Create(aDate, aSender, aSubject, aMessage: String; aState: Boolean);
begin
  id := 0;
  fav:= false;
  sender := aSender;
  subject := aSubject;
  date := aDate;
  stateR := aState;
  message := aMessage;
end;

procedure Message.DownloadCompressed;
var
  folder, fileName: string;
  compressedData: TStringList;
  compressedText: string;

  function LZWCompress(const input: string): string;
  var
    dict: TStringList;
    s, c, sc: string;
    i, code: Integer;
    output: array of Integer;
  begin
    dict := TStringList.Create;
    dict.Sorted := False;
    dict.Duplicates := dupIgnore;

    for i := 0 to 255 do
      dict.Add(Char(i));

    s := '';
    SetLength(output, 0);

    for i := 1 to Length(input) do
    begin
      c := input[i];
      sc := s + c;
      if dict.IndexOf(sc) <> -1 then
        s := sc
      else
      begin
        code := dict.IndexOf(s);
        if code <> -1 then
        begin
          SetLength(output, Length(output) + 1);
          output[High(output)] := code;
        end;
        dict.Add(sc);
        s := c;
      end;
    end;

    if s <> '' then
    begin
      code := dict.IndexOf(s);
      SetLength(output, Length(output) + 1);
      output[High(output)] := code;
    end;

    Result := '';
    for i := 0 to High(output) do
      Result := Result + IntToStr(output[i]) + ' ';
    dict.Free;
  end;

begin
  folder := 'descargas de mensajes';
  if not DirectoryExists(folder) then
    CreateDir(folder);

  compressedText := LZWCompress(Self.message);

  fileName := folder + PathDelim + 'mensaje_' + Self.subject + '.txt';
  compressedData := TStringList.Create;
  try
    compressedData.Text := compressedText;
    compressedData.SaveToFile(fileName);
  finally
    compressedData.Free;
  end;

  WriteLn('Archivo comprimido guardado en: ', fileName);
end;

function message.Decompress(const fileName: string): string;
var
  dict: TStringList;
  inputText: TStringList;
  codes: TStringList;
  s, c, entry: string;
  i, code, prevCode: Integer;
  output: string;
begin
  Result := '';
  if not FileExists(fileName) then Exit;

  inputText := TStringList.Create;
  codes := TStringList.Create;
  dict := TStringList.Create;
  try
    inputText.LoadFromFile(fileName);
    codes.Delimiter := ' ';
    codes.DelimitedText := inputText.Text;

    // Inicializar diccionario con caracteres ASCII
    dict.Sorted := False;
    dict.Duplicates := dupIgnore;
    for i := 0 to 255 do
      dict.Add(Char(i));

    prevCode := -1;
    output := '';

    for i := 0 to codes.Count - 1 do
    begin
      code := StrToIntDef(codes[i], -1);
      if code = -1 then Continue;

      if code < dict.Count then
        entry := dict[code]
      else if (code = dict.Count) and (prevCode <> -1) then
        entry := dict[prevCode] + dict[prevCode][1]
      else
        entry := '';

      output := output + entry;

      if (prevCode <> -1) and (entry <> '') then
        dict.Add(dict[prevCode] + entry[1]);

      prevCode := code;
    end;

    Result := output;

  finally
    inputText.Free;
    codes.Free;
    dict.Free;
  end;
end;

end.

