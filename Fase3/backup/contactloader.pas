unit contactLoader;
{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, process;

type
  TContactGraph = class
  private
    FOutputDir: string;
    procedure crateDir(const Dir: string);
  public
    constructor Create;
    procedure readJson(const fileName: string);
  end;

implementation

{ TContactGraph }

constructor TContactGraph.Create;
begin
  FOutputDir := 'relacion de contactos';
end;

procedure TContactGraph.crateDir(const Dir: string);
begin
  if not DirectoryExists(Dir) then
    if not CreateDir(Dir) then
      raise Exception.CreateFmt('No se pudo crear el directorio: %s', [Dir]);
end;

procedure TContactGraph.readJson(const fileName: string);
var
  FileStream: TFileStream;
  Parser: TJSONParser;
  JSONData: TJSONData;
  JSONObject, UserObject: TJSONObject;
  JSONArray, ContactArray: TJSONArray;
  i, j: Integer;
  Usuario, Contacto: string;
  DotLines: TStringList;
  Nodos: TStringList;
  ArchivoDOT, ArchivoPNG: string;
  Proceso: TProcess;
begin
  if not FileExists(fileName) then
    raise Exception.Create('Archivo JSON no encontrado: ' + fileName);

  crateDir(FOutputDir);

  FileStream := TFileStream.Create(fileName, fmOpenRead or fmShareDenyWrite);
  try
    Parser := TJSONParser.Create(FileStream);
    try
      JSONData := Parser.Parse;
      try
        JSONObject := TJSONObject(JSONData);
        JSONArray := JSONObject.Arrays['Usuarios'];

        DotLines := TStringList.Create;
        Nodos := TStringList.Create;
        try
          Nodos.Sorted:=True;
          Nodos.Duplicates:=dupIgnore;
          Nodos.CaseSensitive:=False;
          DotLines.Add('graph G {');
          DotLines.Add('  node [shape=circle, style=filled, color=lightblue];');

          for i := 0 to JSONArray.Count - 1 do
          begin
            UserObject := JSONArray.Objects[i];
            Usuario := lowerCase(UserObject.Strings['Usuario']);  // aqui sacan el del usuario que se le asignan los contactos

            if Nodos.IndexOf(Usuario) = -1 then
              Nodos.Add(Usuario);

            ContactArray := UserObject.Arrays['Contactos'];
            for j := 0 to ContactArray.Count - 1 do
            begin
              Contacto := lowerCase(ContactArray.Strings[j]);  /// aqui sacan los nombres de los contactos
              if Nodos.IndexOf(Contacto) = -1 then
                Nodos.Add(Trim(Contacto));

              DotLines.Add(Format('  "%s" -- "%s";', [Usuario, Contacto]));
            end;
          end;

          DotLines.Add('}');

          ArchivoDOT := IncludeTrailingPathDelimiter(FOutputDir) + 'contactos.dot';
          DotLines.SaveToFile(ArchivoDOT);

          ArchivoPNG := IncludeTrailingPathDelimiter(FOutputDir) + 'contactos.png';
          Proceso := TProcess.Create(nil);
          try
            Proceso.Executable := 'dot';
            Proceso.Parameters.Add('-Tpng');
            Proceso.Parameters.Add(ArchivoDOT);
            Proceso.Parameters.Add('-o');
            Proceso.Parameters.Add(ArchivoPNG);
            Proceso.Options := [poWaitOnExit];
            Proceso.Execute;
          finally
            Proceso.Free;
          end;

        finally
          DotLines.Free;
          Nodos.Free;
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
