unit logclass;


{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fgl, fpjson, jsonparser;

type

  Log = class
  public
    usuario: String;
    entrada: String;
    salida: String;
    constructor Create(aNombre, aEntrada, aSalida: String);
  end;


  TLogList = specialize TFPGObjectList<Log>;

  LogListManager = class
  private
    FLogs: TLogList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddLog(aUsuario, aEntrada, aSalida: String);
    function FindByUsuario(const aUsuario: String): Log;
    procedure ExportToJSON(const fileName: String);

    property Logs: TLogList read FLogs;
  end;

implementation


constructor Log.Create(aNombre, aEntrada, aSalida: String);
begin
  usuario := aNombre;
  entrada := aEntrada;
  salida := aSalida;
end;


constructor LogListManager.Create;
begin
  FLogs := TLogList.Create(True);
end;

destructor LogListManager.Destroy;
begin
  FLogs.Free;
  inherited Destroy;
end;

procedure LogListManager.AddLog(aUsuario, aEntrada, aSalida: String);
begin
  FLogs.Add(Log.Create(aUsuario, aEntrada, aSalida));
end;


procedure LogListManager.ExportToJSON(const fileName: String);
var
  jsonArray: TJSONArray;
  jsonObj: TJSONObject;
  loged: Log;
  jsonStr: TStringList;
  folder, filePath: String;
begin
  folder := 'logs';
  if not DirectoryExists(folder) then
    CreateDir(folder);

  filePath := folder + '/' + fileName;

  jsonArray := TJSONArray.Create;
  try
    for loged in FLogs do
    begin
      jsonObj := TJSONObject.Create;
      jsonObj.Add('usuario', loged.usuario);
      jsonObj.Add('entrada', loged.entrada);
      jsonObj.Add('salida', loged.salida);
      jsonArray.Add(jsonObj);
    end;

    jsonStr := TStringList.Create;
    try
      jsonStr.Text := jsonArray.FormatJSON([foSingleLineArray, foUseTabChar]);
      jsonStr.SaveToFile(filePath);
    finally
      jsonStr.Free;
    end;

  finally
    jsonArray.Free;
  end;

  Writeln('Archivo JSON generado en: ', filePath);
end;

end.

