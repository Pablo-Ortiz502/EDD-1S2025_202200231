unit MessLoader;

{$mode ObjFPC}{$H+}

interface


uses
  Classes, SysUtils, fpjson, jsonparser, MessageClasss;

type
  MessLoad = class
  public
    class procedure readFile(const fileName: string);
  end;

implementation
uses Unit1, Unit3,matrix,circularL;
{ UserLoader }

class procedure MessLoad.readFile(const fileName: string);
var
  JSONData: TJSONData;
  JSONObject, MessObject: TJSONObject;
  JSONArray: TJSONArray;
  Parser: TJSONParser;
  FileStream: TFileStream;
  i: Integer;
  NewMessage: Message;
  dateA: String;
  remitent: User;
  reciver: User;
  r: mNode;
  k :Integer;

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
        JSONArray := JSONObject.Arrays['correos'];
        dateA := FormatDateTime('dd/mm/yyyy  hh:nn',Now);
        for i := 0 to JSONArray.Count - 1 do
        begin
          MessObject := JSONArray.Objects[i];
          remitent := Form1.userList.findEmail(MessObject.Strings['remitente']);
          reciver :=  Form1.userList.findEmail(MessObject.Strings['destinatario']);
          if(remitent <>nil) and(reciver <>nil) then
           begin
             if(remitent.contactList.findEmail(MessObject.Strings['destinatario']) = nil) then
              begin
                reciver.contactList.add(Contact.create(remitent.id,remitent.tel,remitent.name,remitent.user,remitent.Email));
                remitent.contactList.add(Contact.create(reciver.id,reciver.tel,reciver.name,reciver.user,reciver.Email));
                Form1.relations.Insert(reciver.id,remitent.id,0,reciver.Email,remitent.Email);
                Form1.relations.Insert(remitent.id,reciver.id,0,remitent.Email,reciver.Email);

                NewMessage := Message.create(dateA,MessObject.Strings['remitente'], MessObject.Strings['asunto'], MessObject.Strings['mensaje'], False);
                NewMessage.id:=reciver.messTree.countT;
                reciver.messTree.Insert(NewMessage);
                Inc(reciver.messTree.countT);


                r := Form1.relations.FindNode(remitent.id,reciver.id);
                k := r^.value;
                Inc(k);
                r^.value:=k;
              end
             else
              begin
                NewMessage := Message.create(dateA,MessObject.Strings['remitente'], MessObject.Strings['asunto'], MessObject.Strings['mensaje'], False);
                newMessage.id:=reciver.messTree.countT;
                reciver.messTree.Insert(NewMessage);
                Inc(reciver.messTree.countT);

                r := Form1.relations.FindNode(remitent.id,reciver.id);
                k := r^.value;
                Inc(k);
                r^.value:=k;
              end;
           end;
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
