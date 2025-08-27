unit userLoad;

{$mode ObjFPC}{$H+}

interface


uses
  Classes, SysUtils, fpjson, jsonparser, Unit3;

type
  UserLoader = class
  public
    class procedure LoadFromFile(const fileName: string; List: LinkedList);
  end;

implementation

{ UserLoader }

class procedure UserLoader.LoadFromFile(const fileName: string; List: LinkedList);
var
  JSONData: TJSONData;
  JSONObject, UserObject: TJSONObject;
  JSONArray: TJSONArray;
  Parser: TJSONParser;
  FileStream: TFileStream;
  i: Integer;
  NewUser: User;
begin
  if not FileExists(fileName) then
    raise Exception.Create('Archivo JSON no encontrado: ' + fileName);

  FileStream := TFileStream.Create(fileName, fmOpenRead or fmShareDenyWrite);
  try
    Parser := TJSONParser.Create(FileStream);
    try
      JSONData := Parser.Parse;
      try
        JSONObject := TJSONObject(JSONData);
        JSONArray := JSONObject.Arrays['usuarios'];

        for i := 0 to JSONArray.Count - 1 do
        begin
          UserObject := JSONArray.Objects[i];
          NewUser := User.Create(UserObject.Integers['id'],StrToInt(UserObject.Strings['telefono']), UserObject.Strings['nombre'], UserObject.Strings['usuario'], UserObject.Strings['password'], UserObject.Strings['email']);
          List.add(NewUser);
        end;
      finally
        JSONData.Free;
      end;
    finally
      Parser.Free;
    end;
  finally
    FileStream.Free;
  end;
end;


end.

