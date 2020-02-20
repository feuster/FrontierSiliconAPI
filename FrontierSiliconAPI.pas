unit FrontierSiliconAPI;

{$mode objfpc}{$H+}
{$MACRO ON}

{____________________________________________________________
|  _______________________________________________________  |
| |                                                       | |
| |     Remote API for Frontier Silicon based devices     | |
| | (c) 2019 Alexander Feuster (alexander.feuster@web.de) | |
| |            https://www.github.com/feuster             | |
| |_______________________________________________________| |
|___________________________________________________________}

//define API basics
{$DEFINE APIVERSION:='2.9'}
{$DEFINE INDY10}
//{$DEFINE FSAPI_DEBUG}
{___________________________________________________________}

interface

uses
  Classes, SysUtils, StrUtils, DateUtils, LazUTF8, fphttpclient, XMLRead, DOM
  {$IFDEF LCL}, Forms{$IFDEF FSAPI_DEBUG}, Dialogs{$ENDIF}{$ENDIF}
  {$IFDEF INDY10},IdUDPClient, IdStack, IdHTTP{$ENDIF}
  ;

function fsapi_HexStrToStr(Value: String): String;

function fsapi_CheckStatus(XMLBuffer: String): String;
function fsapi_HTTP(COMMAND: String): String;
function fsapi_CreateSession(URL: String; PIN: String; const ReUseSessionID: Boolean = false): String;
function fsapi_DeleteSession(URL: String; PIN: String): Boolean;
function fsapi_RAW(URL: String; PIN: String; COMMAND: String; const MODE_SET: Boolean = false; const MODE_SET_VALUE: String = ''): String;
function fsapi_RAW_URL(URL: String): String;
function fsapi_LIST_GET_NEXT(URL: String; PIN: String; COMMAND: String; const MAXITEMS: Integer = 10): String;
function fsapi_FACTORY_RESET(URL: String; PIN: String): Boolean;

function fsapi_Info_ImageVersion(URL: String; PIN: String): String;
function fsapi_Info_GetNotifies(URL: String; PIN: String): TStringList;
function fsapi_Info_FriendlyName(URL: String; PIN: String): String;
function fsapi_Info_SetFriendlyName(URL: String; PIN: String; NewName: String): Boolean;

function fsapi_Info_RadioID(URL: String; PIN: String): String;
function fsapi_Info_Artist(URL: String; PIN: String): String;
function fsapi_Info_Name(URL: String; PIN: String): String;
function fsapi_Info_Text(URL: String; PIN: String): String;
function fsapi_Info_graphicUri(URL: String; PIN: String): String;
function fsapi_Info_Duration(URL: String; PIN: String): Integer;
function fsapi_Info_Position(URL: String; PIN: String): Integer;
function fsapi_Info_PlayInfo(URL: String; PIN: String): String;
function fsapi_Info_PlayStatus(URL: String; PIN: String): Byte;
function fsapi_Info_PlayError(URL: String; PIN: String): String;

function fsapi_Info_Time(URL: String; PIN: String): String;
function fsapi_Info_Date(URL: String; PIN: String): String;
function fsapi_Info_DateTime(URL: String; PIN: String): String;

function fsapi_Info_DeviceList(TimeoutMS: Integer; const Icon_URL: Boolean = false): TStringList;
function fsapi_Info_DeviceIcon(DescriptionURL: String; DescriptionXML: String): String;
function fsapi_Info_DeviceIconStreamDownload(IconURL: String): TMemoryStream;
function fsapi_Info_DeviceFileDownload(FileURL: String; LocalFile: String; const Overwrite: Boolean = true): Boolean;
function fsapi_Info_DeviceUpdateInfo(URL: String; PIN: String): String;
function fsapi_Info_DeviceID(URL: String; PIN: String): String;

function fsapi_Info_LAN_MAC(URL: String; PIN: String): String;
function fsapi_Info_WLAN_MAC(URL: String; PIN: String): String;
function fsapi_Info_WLAN_RSSI(URL: String; PIN: String): String;
function fsapi_Info_WLAN_ConnectedSSID(URL: String; PIN: String): String;
function fsapi_Info_LAN_Enabled(URL: String; PIN: String): Boolean;
function fsapi_Info_WLAN_Enabled(URL: String; PIN: String): Boolean;
function fsapi_Info_Network_Interfaces(URL: String; PIN: String): String;

function fsapi_FM_FreqRange_LowerCap(URL: String; PIN: String): Integer;
function fsapi_FM_FreqRange_UpperCap(URL: String; PIN: String): Integer;
function fsapi_FM_FreqRange_Steps(URL: String; PIN: String): Integer;
function fsapi_FM_SetFrequency(URL: String; PIN: String; Value: Integer): Boolean;
function fsapi_FM_GetFrequency(URL: String; PIN: String): Integer;

function fsapi_Modes_Get(URL: String; PIN: String): TStringList;
function fsapi_Modes_Set(URL: String; PIN: String; Value: Integer): Boolean;
function fsapi_Modes_GetModeByIdLabel(URL: String; PIN: String; Value: String): Integer;
function fsapi_Modes_GetModeLabelById(URL: String; PIN: String; Mode: Integer): String;
function fsapi_Modes_SetModeByAlias(URL: String; PIN: String; Value: String): Boolean;
function fsapi_Modes_ActiveMode(URL: String; PIN: String): Integer;
function fsapi_Modes_ActiveModeLabel(URL: String; PIN: String): String;
function fsapi_Modes_CheckModeAlias(Mode: String): String;
function fsapi_Modes_NextMode(URL: String; PIN: String): Boolean;
function fsapi_Modes_PreviousMode(URL: String; PIN: String): Boolean;

function fsapi_PlayControl_PlayPause(URL: String; PIN: String): Boolean;
function fsapi_PlayControl_Play(URL: String; PIN: String): Boolean;
function fsapi_PlayControl_Pause(URL: String; PIN: String): Boolean;
function fsapi_PlayControl_Next(URL: String; PIN: String): Boolean;
function fsapi_PlayControl_Previous(URL: String; PIN: String): Boolean;
function fsapi_PlayControl_Value(URL: String; PIN: String; Value: Byte): Boolean;
function fsapi_PlayControl_SetPositionMS(URL: String; PIN: String; Value: Integer): Boolean;
function fsapi_PlayControl_SetPosition(URL: String; PIN: String; Value: String): Boolean;

function fsapi_Mute_State(URL: String; PIN: String): Boolean;
function fsapi_Mute(URL: String; PIN: String): Boolean;
function fsapi_Mute_Off(URL: String; PIN: String): Boolean;
function fsapi_Mute_On(URL: String; PIN: String): Boolean;
function fsapi_Mute_SetState(URL: String; PIN: String; Value: Byte): Boolean;

function fsapi_Repeat_State(URL: String; PIN: String): Boolean;
function fsapi_Repeat(URL: String; PIN: String): Boolean;
function fsapi_Repeat_On(URL: String; PIN: String): Boolean;
function fsapi_Repeat_Off(URL: String; PIN: String): Boolean;
function fsapi_Repeat_SetState(URL: String; PIN: String; Value: Byte): Boolean;

function fsapi_Shuffle_State(URL: String; PIN: String): Boolean;
function fsapi_Shuffle(URL: String; PIN: String): Boolean;
function fsapi_Shuffle_On(URL: String; PIN: String): Boolean;
function fsapi_Shuffle_Off(URL: String; PIN: String): Boolean;
function fsapi_Shuffle_SetState(URL: String; PIN: String; Value: Byte): Boolean;

function fsapi_Scrobble_State(URL: String; PIN: String): Boolean;
function fsapi_Scrobble(URL: String; PIN: String): Boolean;
function fsapi_Scrobble_On(URL: String; PIN: String): Boolean;
function fsapi_Scrobble_Off(URL: String; PIN: String): Boolean;
function fsapi_Scrobble_SetState(URL: String; PIN: String; Value: Byte): Boolean;

function fsapi_Standby_State(URL: String; PIN: String): Boolean;
function fsapi_Standby(URL: String; PIN: String): Boolean;
function fsapi_Standby_Off(URL: String; PIN: String): Boolean;
function fsapi_Standby_On(URL: String; PIN: String): Boolean;
function fsapi_Standby_SetState(URL: String; PIN: String; Value: Byte): Boolean;

function fsapi_Volume_Get(URL: String; PIN: String): Byte;
function fsapi_Volume_GetSteps(URL: String; PIN: String): Byte;
function fsapi_Volume_Set(URL: String; PIN: String; Value: Byte): Boolean;
function fsapi_Volume_Up(URL: String; PIN: String): Boolean;
function fsapi_Volume_Down(URL: String; PIN: String): Boolean;

function fsapi_DAB_Scan(URL: String; PIN: String): Boolean;
function fsapi_DAB_Prune(URL: String; PIN: String): Boolean;
function fsapi_DAB_FrequencyList(URL: String; PIN: String): TStringList;

function fsapi_Presets_List(URL: String; PIN: String): TStringList;
function fsapi_Presets_Set(URL: String; PIN: String; Value: Integer): Boolean;
function fsapi_Presets_Add(URL: String; PIN: String; Value: Integer): Boolean;
function fsapi_Presets_NextPreset(URL: String; PIN: String): Boolean;
function fsapi_Presets_PreviousPreset(URL: String; PIN: String): Boolean;

function fsapi_Nav_State(URL: String; PIN: String; STATE: Boolean): Boolean;
function fsapi_Nav_List(URL: String; PIN: String): TStringList;
function fsapi_Nav_Navigate(URL: String; PIN: String; Value: Integer): Boolean;
function fsapi_Nav_SelectItem(URL: String; PIN: String; Value: Integer): Boolean;
function fsapi_Nav_NavigateSelectItem(URL: String; PIN: String; Value: Integer; NavType: Integer): Boolean;
function fsapi_Nav_Caps(URL: String; PIN: String): Integer;
function fsapi_Nav_NumItems(URL: String; PIN: String): Integer;
function fsapi_Nav_Status(URL: String; PIN: String): Integer;

function fsapi_Sys_State(URL: String; PIN: String): Integer;
function fsapi_Sys_SetSleepTimer(URL: String; PIN: String; Value: Integer): Boolean;
function fsapi_Sys_GetSleepTimer(URL: String; PIN: String): Integer;

function fsapi_Equalizer_Presets_List(URL: String; PIN: String): TStringList;
function fsapi_Equalizer_Bands_List(URL: String; PIN: String): TStringList;
function fsapi_Equalizer_Get(URL: String; PIN: String): Byte;
function fsapi_Equalizer_Set(URL: String; PIN: String; Value: Byte): Boolean;
function fsapi_Equalizer_CustomParam0_Get(URL: String; PIN: String): Integer;
function fsapi_Equalizer_CustomParam0_Set(URL: String; PIN: String; Value: Integer): Boolean;
function fsapi_Equalizer_CustomParam1_Get(URL: String; PIN: String): Integer;
function fsapi_Equalizer_CustomParam1_Set(URL: String; PIN: String; Value: Integer): Boolean;


var
  fsapi_SessionID:            String;
  fsapi_ReUseSessionID:       Boolean = false;
  {$IFDEF FSAPI_DEBUG}
  //storage variable for last debug message
  fsapi_Debug_NoShowMessage:  Boolean;
  fsapi_Debug_Message:        String;
  {$ENDIF}

const
  API_Version:  String = APIVERSION;
  {$IFDEF FSAPI_DEBUG}
  //Debug message strings
  STR_Error:      String = 'Debug:   Error: ';
  STR_Info:       String = 'Debug:   Info: ';
  STR_Space:      String = '         ';
  //Define DEBUG constant
  FSAPI_DEBUG:    Boolean = true;
  {$ELSE}
  FSAPI_DEBUG:    Boolean = false;
  {$ENDIF}
  {$IFDEF INDY10}
  API_License:  String = '--------------------------------------------------------------------------------'+#13#10#13#10+
                         'Frontier Silicon API V'+APIVERSION+' (c) 2018 Alexander Feuster (alexander.feuster@web.de)'+#13#10+
                         'http://www.github.com/feuster'+#13#10+
                         'This API is provided "as-is" without any warranties for any data loss,'+#13#10+
                         'device defects etc. Use at own risk!'+#13#10+
                         'Free for personal use. Commercial use is prohibited without permission.'+#13#10#13#10+
                         '--------------------------------------------------------------------------------'+#13#10#13#10+
                         'Indy BSD License'+#13#10+
                         #13#10+
                         'Copyright'+#13#10+
                         #13#10+
                         'Portions of this software are Copyright (c) 1993 - 2003, Chad Z. Hower (Kudzu)'+#13#10+
                         'and the Indy Pit Crew - http://www.IndyProject.org/'+#13#10+
                         #13#10+
                         'License'+#13#10+
                         #13#10+
                         'Redistribution and use in source and binary forms, with or without modification,'+#13#10+
                         'are permitted provided that the following conditions are met: Redistributions'+#13#10+
                         'of source code must retain the above copyright notice, this list of conditions'+#13#10+
                         'and the following disclaimer.'+#13#10+
                         #13#10+
                         'Redistributions in binary form must reproduce the above copyright notice, this'+#13#10+
                         'list of conditions and the following disclaimer in the documentation, about box'+#13#10+
                         'and/or other materials provided with the distribution.'+#13#10+
                         #13#10+
                         'No personal names or organizations names associated with the Indy project may'+#13#10+
                         'be used to endorse or promote products derived from this software without'+#13#10+
                         'specific prior written permission of the specific individual or organization.'+#13#10+
                         #13#10+
                         'THIS SOFTWARE IS PROVIDED BY Chad Z. Hower (Kudzu) and the Indy Pit Crew "AS'+#13#10+
                         'IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE'+#13#10+
                         'IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE'+#13#10+
                         'DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY'+#13#10+
                         'DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES'+#13#10+
                         '(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;'+#13#10+
                         'LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON'+#13#10+
                         'ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT'+#13#10+
                         '(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS'+#13#10+
                         'SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.'+#13#10#13#10+
                         '-------------------------[scroll up for full License]--------------------------'+#13#10#13#10;
  {$ELSE}
  API_License:  String = 'Frontier Silicon API V'+APIVERSION+' (c) 2018 Alexander Feuster (alexander.feuster@web.de)'+#13#10+
                         'http://www.github.com/feuster'+#13#10+
                         'This API is provided "as-is" without any warranties for any data loss, device defects etc.'+#13#10+
                         'Use at own risk!'+#13#10+
                         'Free for personal use. Commercial use is prohibited without permission.';
  {$ENDIF}

implementation

{$IFDEF FSAPI_DEBUG}
procedure DebugPrint(DebugText: String);
//generate debug messages for Console or GUI application
begin
  fsapi_Debug_Message:=fsapi_Debug_Message+#13#10+DebugText;
  {$IFNDEF LCL}
  WriteLn(fsapi_Debug_Message);
  {$ELSE}
  if fsapi_Debug_NoShowMessage=false then
    ShowMessage(fsapi_Debug_Message);
  {$ENDIF}
end;
{$ENDIF}

//------------------------------------------------------------------------------
// Helper functions
//------------------------------------------------------------------------------

function fsapi_HexStrToStr(Value: String): String;
//convert HEX coded string into regular ASCII string
var
  Buffer: String;
  Hex:    String;
  Index:  Integer;

begin
  try
  Index:=1;
  Buffer:='';
  while Index<=Length(Value)-1 do
    begin
      Hex:=Value[Index]+Value[Index+1];
      Buffer:=Buffer+Chr(Hex2Dec(Hex));
      Index:=Index+2;
    end;
  Result:=Buffer;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_HexStrToStr -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Check Status
//------------------------------------------------------------------------------
function fsapi_CheckStatus(XMLBuffer: String): String;
//Check Status from buffer
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     TStringStream;

begin
  try
  Buffer:=TStringStream.Create(XMLBuffer);
  ReadXMLFile(XML, Buffer);
  Node:=XML.DocumentElement.FindNode('status');
  if Node<>NIL then
    Result:=String(Node.FirstChild.NodeValue)
  else
    Result:='';
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_CheckStatus -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// HTTP Command
//------------------------------------------------------------------------------
{$IFDEF INDY10}
function fsapi_HTTP(COMMAND: String): String;
//Send an API command via HTTP to device
var
  HTTPClient: TIdHTTP;

begin
  try
  if Command='' then
    begin
      Result:='';
      exit;
    end;

  if LeftStr(LowerCase(Command),7)<>'http://' then
    Command:='http://'+Command;

  if LeftStr(LowerCase(Command),7)<>'http://' then
    begin
      {$IFDEF FSAPI_DEBUG}DebugPrint(STR_Error+'fsapi_HTTP -> not allowed command "'+Command+'"');{$ENDIF}
      Result:='';
      exit;
    end;

  HTTPClient:=TIdHTTP.Create(NIL);
  {$IFDEF FSAPI_DEBUG}{$IFDEF LCL}DebugPrint(Trim(STR_Info+'fsapi_HTTP -> '+Command));{$ENDIF}{$ENDIF}
  Result:=HTTPClient.Get(COMMAND);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_HTTP -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      if Pos('404',E.Message)>0 then
        begin
          {$IFDEF FSAPI_DEBUG}DebugPrint(STR_Error+'fsapi_HTTP -> error 404: clearing stored session ID');{$ENDIF}
          fsapi_SessionID:='';
        end;
      Result:='';
      if HTTPClient<>NIL then HTTPClient.Free;
    end;
  end;
  if HTTPClient<>NIL then HTTPClient.Free;
end;
{$ELSE}
function fsapi_HTTP(COMMAND: String): String;
//Send an API command via HTTP to device
var
  HTTPClient: TFPCustomHTTPClient;

begin
  try
  if Command='' then
    begin
      Result:='';
      exit;
    end;

  if LeftStr(LowerCase(Command),7)<>'http://' then
    Command:='http://'+Command;

  if LeftStr(LowerCase(Command),7)<>'http://' then
    begin
      {$IFDEF FSAPI_DEBUG}DebugPrint(STR_Error+'fsapi_HTTP -> not allowed command "'+Command+'"');{$ENDIF}
      Result:='';
      exit;
    end;

  HTTPClient:=TFPCustomHTTPClient.Create(NIL);
  {$IFDEF FSAPI_DEBUG}{$IFDEF LCL}DebugPrint(Trim(STR_Info+'fsapi_HTTP -> '+Command));{$ENDIF}{$ENDIF}
  Result:=HTTPClient.SimpleGet(COMMAND);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_HTTP -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      if Pos('404',E.Message)>0 then
        begin
          {$IFDEF FSAPI_DEBUG}DebugPrint(STR_Error+'fsapi_HTTP -> error 404: clearing stored session ID');{$ENDIF}
          fsapi_SessionID:='';
        end;
      Result:='';
      if HTTPClient<>NIL then HTTPClient.Free;
    end;
  end;
  if HTTPClient<>NIL then HTTPClient.Free;
end;
{$ENDIF}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Session
//------------------------------------------------------------------------------
function fsapi_CreateSession(URL: String; PIN: String; const ReUseSessionID: Boolean = false): String;
//Create a session ID
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //optional use last session ID again
  if (fsapi_SessionID<>'') and ((fsapi_ReUseSessionID=true) or (ReUseSessionID=true)) then
    begin
      Result:=fsapi_SessionID;
      exit;
    end;

  //create a new session ID
  Buffer:=fsapi_HTTP(URL+'/fsapi/CREATE_SESSION?pin='+PIN);
  if Buffer='' then
    begin
      {$IFDEF FSAPI_DEBUG}DebugPrint(STR_Error+'fsapi_CreateSession -> HTTP request failed');{$ENDIF}
      fsapi_SessionID:='';
      Result:='';
      exit;
    end;
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('status');
  if Node<>NIL then
    begin
      if Node.FirstChild.NodeValue='FS_OK' then
        begin
          Node:=XML.DocumentElement.FindNode('sessionId');
          Buffer:=AnsiString(Node.FirstChild.NodeValue);
        end
      else
        begin
          Buffer:='';
        end;
    end
  else
    begin
      Buffer:='';
    end;
  fsapi_SessionID:=Buffer;
  Result:=fsapi_SessionID;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_CreateSession -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      fsapi_SessionID:='';
      Result:='';
    end;
  end;
end;

function fsapi_DeleteSession(URL: String; PIN: String): Boolean;
//Delete a session ID
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  Buffer:=fsapi_HTTP(URL+'/fsapi/DELETE_SESSION?pin='+PIN);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('status');
  if Node<>NIL then
    begin
      if Node.FirstChild.NodeValue='FS_OK' then
        begin
          fsapi_SessionID:='';
          Result:=true;
        end
      else
        begin
          Result:=false;
        end;
    end
  else
    begin
      Result:=false;
    end;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_DeleteSession -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// RAW GET/SET commands
//------------------------------------------------------------------------------
function fsapi_RAW(URL: String; PIN: String; COMMAND: String; const MODE_SET: Boolean = false; const MODE_SET_VALUE: String = ''): String;
//Get or set a raw command
begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get or set the raw command via fsapi
  if MODE_SET then
    Result:=fsapi_HTTP(URL+'/fsapi/SET/'+COMMAND+'?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+StringReplace(MODE_SET_VALUE,' ','%20',[rfReplaceAll,rfIgnoreCase])) //spaces in MODE_SET_VALUE must be replaced with %20 to create a valid URL
  else
    Result:=fsapi_HTTP(URL+'/fsapi/GET/'+COMMAND+'?pin='+PIN+'&sid='+fsapi_SessionID);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_RAW -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_RAW_URL(URL: String): String;
//Execute full raw command
begin
  try
  Result:=fsapi_HTTP(StringReplace(URL,' ','%20',[rfReplaceAll,rfIgnoreCase])); //spaces in MODE_SET_VALUE must be replaced with %20 to create a valid URL
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_RAW_URL -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// LIST_GET_NEXT commands
//------------------------------------------------------------------------------
function fsapi_LIST_GET_NEXT(URL: String; PIN: String; COMMAND: String; const MAXITEMS: Integer = 10): String;
//Execute LIST_GET_NEXT command
begin
  try
  Result:=fsapi_RAW_URL(URL+'/fsapi/LIST_GET_NEXT/'+StringReplace(COMMAND,' ','%20',[rfReplaceAll,rfIgnoreCase])+'?pin='+PIN+'&maxItems='+IntToStr(MAXITEMS)); //spaces in MODE_SET_VALUE must be replaced with %20 to create a valid URL
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_LIST_GET_NEXT -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Factory reset
//------------------------------------------------------------------------------
function fsapi_FACTORY_RESET(URL: String; PIN: String): Boolean;
//Execute LIST_GET_NEXT command
var
  Buffer: String;

begin
  try
  ///fsapi/SET/netRemote.sys.factoryReset?pin=1234&value=1
  Buffer:=fsapi_RAW_URL(URL+'/fsapi/SET/netRemote.sys.factoryReset?pin='+PIN+'&value=1');
  if Pos('FS_OK',Buffer)>0 then
    begin
      fsapi_SessionID:='';
      Result:=true;
    end
  else
  Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_FACTORY_RESET -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Info
//------------------------------------------------------------------------------
function fsapi_Info_ImageVersion(URL: String; PIN: String): String;
//Get Image Version
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get version from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.info.version?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_ImageVersion -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_GetNotifies(URL: String; PIN: String): TStringList;
//Get notifies
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Node2:      TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;
  Notifies:   TStringList;

begin
  try
  Notifies:=TStringList.Create;
  Notifies.Clear;

  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=Notifies;
      exit;
    end;

  //Get notifies from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET_NOTIFIES?pin='+PIN+'&sid='+fsapi_SessionID);
  if Buffer='' then
    begin
      Result:=Notifies;
      exit;
    end;
  if Pos('notify',LowerCase(Buffer))=0 then
    begin
      Result:=Notifies;
      exit;
    end;
  Buffer2:=TStringStream.Create(Buffer);
  Buffer2.Seek(0,0);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('notify');
  while Node<>NIL do
    begin
      Buffer:=String(Node.Attributes.Item[0].NodeValue);
      Node2:=Node.FindNode('value');
      if Node2<>NIL then
        begin
          Node2:=Node2.FirstChild;
          if Node2.FirstChild<>NIL then
            Notifies.Add(Buffer+'|'+String(Node2.FirstChild.NodeValue));
        end;
      Node:=Node.NextSibling;
      if Node=NIL then
        break;
    end;

  Result:=Notifies;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_GetNotifies -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=Notifies;
    end;
  end;
end;

function fsapi_Info_FriendlyName(URL: String; PIN: String): String;
//Get Friendly Name
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get friendly name from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.info.friendlyName?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_FriendlyName -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_SetFriendlyName(URL: String; PIN: String; NewName: String): Boolean;
//Set new Friendly Name
var
  Buffer:     String;

begin
  try
  //Check new name
  if NewName='' then
    begin
      Result:=false;
      exit;
    end;
  NewName:=StringReplace(NewName,' ','%20',[rfReplaceAll,rfIgnoreCase]); //spaces in NewName must be replaced with %20 to create a valid URL

  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Set new friendly name for device
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.sys.info.friendlyName?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+NewName);
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_SetFriendlyName -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Info_RadioID(URL: String; PIN: String): String;
//Get Radio ID
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get ID from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.info.radioId?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node.FirstChild<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_RadioID -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_Artist(URL: String; PIN: String): String;
//Get Artist
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get artist from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.info.artist?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node.FirstChild<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_Artist -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_Name(URL: String; PIN: String): String;
//Get name/title
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get name from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.info.name?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node.FirstChild<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_Name -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_Text(URL: String; PIN: String): String;
//Get text
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get text from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.info.text?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node.FirstChild<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_Text -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_graphicUri(URL: String; PIN: String): String;
//Get graphic URI
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get graphic URI from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.info.graphicUri?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node.FirstChild<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_graphicUri -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_Duration(URL: String; PIN: String): Integer;
//Get Duration
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=0;
      exit;
    end;

  //Get duration from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.info.duration?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u32');
      if Node.FirstChild<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=0;
    end
  else
    Result:=0;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_Duration -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=0;
    end;
  end;
end;

function fsapi_Info_Position(URL: String; PIN: String): Integer;
//Get Position
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=0;
      exit;
    end;

  //Get position from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.position?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u32');
      if Node.FirstChild<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=0;
    end
  else
    Result:=0;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_Position -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=0;
    end;
  end;
end;

function fsapi_Info_PlayInfo(URL: String; PIN: String): String;
//Create META info for actual play item
var
  Buffer:     String;
  Buffer2:    String;
  Buffer3:    String;

begin
  try
  Buffer:=fsapi_Info_Artist(URL, PIN);
  if Buffer<>'' then
    Buffer3:=Buffer+': ';
  Buffer:=fsapi_Info_Name(URL, PIN);
  if Buffer<>'' then
    Buffer3:=Buffer3+Buffer;
  Buffer:=fsapi_Info_Text(URL, PIN);
  if Buffer<>'' then
    Buffer3:=Buffer3+' '''+Buffer+'''';
  Buffer:=TimeToStr(fsapi_Info_Position(URL, PIN)/MSecsPerDay);
  Buffer2:=TimeToStr(fsapi_Info_Duration(URL, PIN)/MSecsPerDay);
  if (Buffer<>'') and (Buffer<>'00:00:00') then
    Buffer3:=Buffer3+' ('+Buffer;
  if (Buffer2<>'') and (Buffer2<>'00:00:00') then
    Buffer3:=Buffer3+'/'+Buffer2;
  if ((Buffer<>'') and (Buffer<>'00:00:00')) or ((Buffer2<>'') and (Buffer2<>'00:00:00')) then
    Buffer3:=Buffer3+')';
  Result:=Buffer3;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_PlayInfo -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_PlayStatus(URL: String; PIN: String): Byte;
//get actual device play status
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=255;
      exit;
    end;

  //Get play status from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.status?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node.FirstChild<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=0;
    end
  else
    Result:=0;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_PlayStatus -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=255;
    end;
  end;
end;

function fsapi_Info_PlayError(URL: String; PIN: String): String;
//Get play error text
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get error text from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.info.errorStr?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node.FirstChild<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_PlayError -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_Time(URL: String; PIN: String): String;
//Get Time
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;
  LocalTime:  TTime;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get time from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.clock.localTime?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      //Get local time from device
      Node:=Node.FindNode('c8_array');
      if Node<>NIL then
        LocalTime:=StrToTime(String(MidStr(Node.FirstChild.NodeValue,1,2)+':'+MidStr(Node.FirstChild.NodeValue,3,2)+':'+MidStr(Node.FirstChild.NodeValue,5,2)))
      else
        begin
          Result:='';
          exit;
        end;
    end
  else
    begin
      Result:='';
      exit;
    end;

  //Get time offset from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.clock.utcOffset?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('s32');
      if Node<>NIL then
        LocalTime:=IncMilliSecond(LocalTime,Int64(StrToInt(String(Node.FirstChild.NodeValue)))*1000);
    end;
  Result:=TimeToStr(LocalTime);

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_Time -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_Date(URL: String; PIN: String): String;
//Get Date
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;
  LocalDate:  TDateTime;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get date from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.clock.localDate?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node<>NIL then
        begin
          LocalDate:=StrToDate(String(MidStr(Node.FirstChild.NodeValue,7,2))+'.'+String(MidStr(Node.FirstChild.NodeValue,5,2))+'.'+String(MidStr(Node.FirstChild.NodeValue,1,4)));
          Result:=DateToStr(LocalDate);
        end
      else
        Result:='';
    end
  else
    Result:='';

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_Date -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_DateTime(URL: String; PIN: String): String;
//Get Date & Time
var
  Buffer:  String;
  Buffer2: String;
begin
  try
  Buffer:=fsapi_Info_Date(URL, PIN);
  Buffer2:=fsapi_Info_Time(URL, PIN);
  if (Buffer<>'') and (Buffer2<>'') then
    Result:=Buffer+' '+Buffer2
  else if (Buffer='') and (Buffer2<>'') then
    Result:=Buffer2
  else if (Buffer<>'') and (Buffer2='') then
    Result:=Buffer
  else
    Result:='';
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_DateTime -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

{$IFDEF INDY10}
function fsapi_Info_DeviceList(TimeoutMS: Integer; const Icon_URL: Boolean = false): TStringList;
//List available devices from network (only with INDY10)
var
  Index:          Integer;
  Buffer:         TStringList;
  DeviceList:     TStringList;
  UDPClient:      TIdUDPClient;
  UDPPeerPort:    Word;
  UDPPeerIP:      String;
  SSDP:           String;
  SSDP_Response:  String;
  Location:       String;
  Location_Icon:  String;
  Description:    String;
  UUID:           String;
  HTTPClient:     TFPCustomHTTPClient;
  XMLBuffer:      TStringStream;
  XML:            TXMLDocument;
  Node:           TDOMNode;
  Node2:          TDOMNode;

begin
  try
  UDPClient:=TIdUDPClient.Create(nil);
  DeviceList:=TStringList.Create;
  DeviceList.TextLineBreakStyle:=tlbsCRLF;
  DeviceList.Duplicates:=dupIgnore;
  DeviceList.SortStyle:=sslAuto;
  Buffer:=TStringList.Create;
  Buffer.TextLineBreakStyle:=tlbsCRLF;

  try
    //assemble SSDP broadcast command
    SSDP:='M-SEARCH * HTTP/1.1'+#13#10+
          'HOST: 239.255.255.250:1900'+#13#10+
          'MAN: "ssdp:discover"'+#13#10+
          'MX: 5'+#13#10+
          'ST: ssdp:all'+#13#10+
          //'ST: urn:schemas-frontier-silicon-com:undok:fsapi:1'+#13#10+
          //'ST: urn:schemas-frontier-silicon-com:fs_reference:fsapi:1'+#13#10+
          #13#10;

    //send SSDP broadcast
    UDPClient.BoundIP:=GStack.LocalAddress;
    UDPClient.Send('239.255.255.250',1900,SSDP);
    UDPClient.Send('239.255.255.250',1900,SSDP);
    UDPClient.Send('239.255.255.250',1900,SSDP);

    //check for SSDP answers
    if TimeoutMS>0 then
      UDPClient.ReceiveTimeout:=TimeoutMS
    else
      UDPClient.ReceiveTimeout:=3000;
    repeat
      {$IFDEF LCL}Application.ProcessMessages;{$ENDIF}
      SSDP_Response:=UDPClient.ReceiveString(UDPPeerIP, UDPPeerPort);
      //SSDP response received
      if UDPPeerPort<>0 then
        begin
          {$IFDEF FSAPI_DEBUG}{$IFNDEF LCL}
          WriteLn(STR_Info,'Response from ',Format('%s:%d', [UDPPeerIP, UDPPeerPort]));
          writeln(STR_Info,'fsapi_Info_DeviceList -> RESPONSE BEGIN');
          writeln('--------------------------------------------------------------------------------');
          Write(SSDP_Response);
          writeln('--------------------------------------------------------------------------------');
          writeln(STR_Info,'fsapi_Info_DeviceList -> RESPONSE END'+#13#10+#13#10);
          {$ENDIF}{$ENDIF}

          //extract IP and device name from SSDP response (friendlyName)
          Buffer.Text:=SSDP_Response;
          for Index:=0 to Buffer.Count-1 do
            begin
              if (Pos('LOCATION:',UpperCase(Buffer.Strings[Index]))>0) and (Pos('SPEAKER-NAME:',UpperCase(SSDP_Response))=0)then
                begin
                  Location:=Trim(StringReplace(Buffer.Strings[index],'LOCATION:','',[rfReplaceAll,rfIgnoreCase]));
                  HTTPClient:=TFPCustomHTTPClient.Create(NIL);
                  try
                  Description:=HTTPClient.SimpleGet(Location);
                  except
                  {$IFDEF FSAPI_DEBUG}DebugPrint(STR_ERROR+'fsapi_Info_DeviceList -> location error "'+Location+'"');{$ENDIF}
                  end;
                  if HTTPClient<>NIL then HTTPClient.Free;
                  {$IFDEF LCL}Application.ProcessMessages;{$ENDIF}
                  if (Pos('FRONTIER-SILICON',UpperCase(Description))>0) or (Pos('UUID:3DCC7100',UpperCase(Description))>0) then
                    begin
                      //Extract device icon URL and UUID from description
                      if Icon_URL=true then
                        begin
                          Location_Icon:=fsapi_Info_DeviceIcon(LeftStr(Location,RPos('/',Location)-1),Description);
                        end;
                      XMLBuffer:=TStringStream.Create(Description);
                      ReadXMLFile(XML, XMLBuffer);
                      Node:=XML.DocumentElement.FirstChild;
                      while Assigned(Node) do
                        begin
                          if Node.NodeName='device' then
                            begin
                              Node2:=Node.FindNode('friendlyName');
                              if Node2.FirstChild<>NIL then
                                begin
                                  Location:=Trim(AnsiString(Node2.FirstChild.NodeValue));
                                end;
                              Node2:=Node.FindNode('UDN');
                              if Node2.FirstChild<>NIL then
                                begin
                                  UUID:=Trim(StringReplace(AnsiString(Node2.FirstChild.NodeValue),'uuid:','',[rfReplaceAll,rfIgnoreCase]));
                                end;
                            end;
                          Node:=Node.NextSibling;
                        end;
                      if Icon_URL=true then
                        DeviceList.Add(UDPPeerIP+'|'+Location+'|'+UUID+'|'+Location_Icon)
                      else
                        DeviceList.Add(UDPPeerIP+'|'+Location+'|'+UUID+'|');
                    end;
                end;
            end;

        end;
    until UDPPeerPort=0;

    //sort list
    DeviceList.Sort;
  finally
    UDPClient.Free;
  end;
  {$IFDEF LCL}Application.ProcessMessages;{$ENDIF}
  Result:=DeviceList;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_DeviceList -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=DeviceList;
    end;
  end;
end;
{$ELSE}
function fsapi_Info_DeviceList(TimeoutMS: Integer; const Icon_URL: Boolean = false): TStringList;
//List device from network (dummy function without INDY10)
begin
  {$IFDEF FSAPI_DEBUG}DebugPrint(STR_Error+'fsapi_Info_DeviceList -> INDY10 not enabled');{$ENDIF}
  Result:=TStringList.Create;
end;
{$ENDIF}

function fsapi_Info_DeviceIcon(DescriptionURL: String; DescriptionXML: String): String;
//Extract device icon URL from device description XML
var
  XMLBuffer:      TStringStream;
  XML:            TXMLDocument;
  Node:           TDOMNode;
  Node2:          TDOMNode;
  Node3:          TDOMNode;
  Node4:          TDOMNode;
  Size:           Integer;
  SizeMax:        Integer;
  IconURL:        String;

begin
  try
  //check arguments
  Result:='';
  if (DescriptionURL='') or (DescriptionXML='') then
    exit;

  //Create XML document from Description string
  XMLBuffer:=TStringStream.Create(DescriptionXML);
  ReadXMLFile(XML, XMLBuffer);
  Node:=XML.DocumentElement.FirstChild;
  while Assigned(Node) do
    begin
      if Node.NodeName='device' then
        begin
          Node2:=Node.FindNode('iconList');
          if Assigned(Node2) then
            begin
              Node3:=Node2.FirstChild;
              SizeMax:=0;
              while Assigned(Node3) do
                begin
                  //analyze <icon> node
                  Node4:=Node3.FindNode('url');
                  if Assigned(Node4) then
                    begin
                      if Node4.FirstChild.NodeValue<>'' then
                        begin
                          //build icon URL
                          IconURL:=DescriptionURL+AnsiString(Node4.FirstChild.NodeValue);
                          //calculate icon size (x*y)
                          Node4:=Node3.FindNode('width');
                          if Assigned(Node4) then
                            begin
                              Size:=StrToInt(AnsiString(Node4.FirstChild.NodeValue));
                            end;
                          Node4:=Node3.FindNode('height');
                          if Assigned(Node4) then
                            begin
                              Size:=Size*StrToInt(AnsiString(Node4.FirstChild.NodeValue));
                            end;
                          //choose first found or biggest icon
                          if Size>=SizeMax then
                            begin
                              SizeMax:=Size;
                              Result:=IconURL;
                            end;
                        end;
                    end;
                  Node3:=Node3.NextSibling;
                end;
            end;
        end;
      Node:=Node.NextSibling;
    end;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_DeviceIcon -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';;
    end;
  end;
end;

function fsapi_Info_DeviceIconStreamDownload(IconURL: String): TMemoryStream;
//Extract device icon from device
var
  HTTPClient: TFPCustomHTTPClient;
  IconStream: TMemoryStream;

begin
  try
  //download device icon as stream if available
  try
  HTTPClient:=TFPCustomHTTPClient.Create(NIL);
  IconStream:=TMemoryStream.Create;
  HTTPClient.SimpleGet(IconURL,IconStream);
  except
  on E:Exception do
    begin
      IconStream.Clear;
    end;
  end;

  Result:=IconStream;
  if HTTPClient<>NIL then HTTPClient.Free;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_DeviceIconStreamDownload -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      IconStream.Clear;
      Result:=IconStream;
    end;
  end;
end;

function fsapi_Info_DeviceFileDownload(FileURL: String; LocalFile: String; const Overwrite: Boolean = true): Boolean;
//Extract file from device for e.g. cover or device icons
var
  HTTPClient: TFPCustomHTTPClient;

begin
  try
  //check URL/path arguments
  if (FileURL='') or (LocalFile='') then
    begin
      Result:=false;
      exit;
    end;

  //check for existing file
  if FileExists(LocalFile)=true then
    begin
      if Overwrite=true then
        DeleteFile(LocalFile)
      else
        begin
          Result:=false;
          exit;
        end;
    end;

  //download file if available
  try
  HTTPClient:=TFPCustomHTTPClient.Create(NIL);
  HTTPClient.SimpleGet(FileURL,LocalFile);
  Result:=FileExists(LocalFile);
  except
  on E:Exception do
    begin
      Result:=false;
    end;
  end;
  if HTTPClient<>NIL then HTTPClient.Free;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_DeviceFileDownload -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Info_DeviceUpdateInfo(URL: String; PIN: String): String;
//check device update info
var
  HTTPClient: TFPCustomHTTPClient;
  MAC:        String;
  Version:    String;
  UpdateURL:  String;

begin
  try
  //read device build info
  Version:=fsapi_Info_ImageVersion(URL,PIN);

  try
  HTTPClient:=TFPCustomHTTPClient.Create(NIL);

  //Create update URL according to example: http://update.wifiradiofrontier.com/FindUpdate.aspx?mac=002261cc46d2&customisation=ir-mmi-FS2026-0500-0335&version=2.9.10.EX63197-1A23
  if fsapi_Info_Network_Interfaces(URL,PIN)='LAN' then
    begin
      MAC:=fsapi_Info_LAN_MAC(URL,PIN);
      UpdateURL:='http://update.wifiradiofrontier.com/FindUpdate.aspx?mac='+StringReplace(MAC,':','',[rfReplaceAll,rfIgnoreCase])+'&customisation='+LeftStr(Version,Pos('_',Version)-1)+'&version='+RightStr(Version,Pos('_V',Version)-5);
      {$IFDEF FSAPI_DEBUG}{$IFNDEF LCL}DebugPrint(STR_INFO+'LAN Update URL ->'+#13#10+STR_SPACE+UpdateURL);{$ENDIF}{$ENDIF}
    end
  else if fsapi_Info_Network_Interfaces(URL,PIN)='WLAN' then
    begin
      MAC:=fsapi_Info_WLAN_MAC(URL,PIN);
      UpdateURL:='http://update.wifiradiofrontier.com/FindUpdate.aspx?mac='+StringReplace(MAC,':','',[rfReplaceAll,rfIgnoreCase])+'&customisation='+LeftStr(Version,Pos('_',Version)-1)+'&version='+RightStr(Version,Pos('_V',Version)-5);
      {$IFDEF FSAPI_DEBUG}{$IFNDEF LCL}DebugPrint(STR_INFO+'WLAN Update URL ->'+#13#10+STR_SPACE+UpdateURL);{$ENDIF}{$ENDIF}
    end
  else
    begin
      Result:='';
      exit;
    end;

  //call update URL
  Result:=HTTPClient.SimpleGet(UpdateURL);
  except
  on E:Exception do
    begin
      Result:='';
    end;
  end;
  if HTTPClient<>NIL then HTTPClient.Free;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_DeviceUpdateInfo -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_DeviceID(URL: String; PIN: String): String;
//Get device ID
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get radio ID from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.info.radioId?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_DeviceID -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_LAN_MAC(URL: String; PIN: String): String;
//LAN interface MAC address
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get MAC address from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.net.wired.macAddress?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_LAN_MAC -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_WLAN_MAC(URL: String; PIN: String): String;
//WLAN interface MAC address
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get MAC address from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.net.wlan.macAddress?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('c8_array');
      if Node<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_WLAN_MAC -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_WLAN_RSSI(URL: String; PIN: String): String;
//get actual WLAN RSSI reception strenght status
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get RSSI value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.net.wlan.rssi?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        Result:=String(Node.FirstChild.NodeValue)
      else
        Result:='';
    end
  else
    Result:='';

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_WLAN_RSSI -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Info_WLAN_ConnectedSSID(URL: String; PIN: String): String;
//WLAN interface connected SSID
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:='';
      exit;
    end;

  //Get SSID value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.net.wlan.connectedSSID?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('array');
      if Node<>NIL then
        Buffer:=String(Node.FirstChild.NodeValue)
      else
        Buffer:='';
    end
  else
    Buffer:='';

  //convert HEX coded string into regular ASCII string
  Result:=fsapi_HexStrToStr(Buffer);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_WLAN_ConnectedSSID -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;

end;

function fsapi_Info_WLAN_RSSI(URL: String; PIN: String): Byte;
//get actual WLAN RSSI reception strenght status
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=0;
      exit;
    end;

  //Get WLAN RSSI value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.net.wlan.rssi?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=0;
    end
  else
    Result:=0;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_WLAN_RSSI -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=0;
    end;
  end;
end;

function fsapi_Info_LAN_Enabled(URL: String; PIN: String): Boolean;
//check LAN interface enabled
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Get LAN interface status from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.net.wired.interfaceEnable?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          if String(Node.FirstChild.NodeValue)='1' then
            Result:=true
          else
            Result:=false;
        end
      else
        Result:=false;
    end
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_LAN_Enabled -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Info_WLAN_Enabled(URL: String; PIN: String): Boolean;
//check WLAN interface enabled
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Get WLAN interface status from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.net.wlan.interfaceEnable?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          if String(Node.FirstChild.NodeValue)='1' then
            Result:=true
          else
            Result:=false;
        end
      else
        Result:=false;
    end
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_WLAN_Enabled -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Info_Network_Interfaces(URL: String; PIN: String): String;
//check which network interfaces are enabled
var
  LAN:  Boolean;
  WLAN: Boolean;

begin
  try
  LAN:=fsapi_Info_LAN_Enabled(URL,PIN);
  WLAN:=fsapi_Info_WLAN_Enabled(URL,PIN);
  if (LAN=true) and (WLAN=false) then
    Result:='LAN'
  else if (LAN=false) and (WLAN=true) then
      Result:='WLAN'
  else
    Result:='NONE';
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Info_Network_Interfaces -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// FM
//------------------------------------------------------------------------------
function fsapi_FM_FreqRange_LowerCap(URL: String; PIN: String): Integer;
//get FM lowest allowed frequency
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=-1;
      exit;
    end;

  //enable NAV
  if fsapi_Nav_State(URL,PIN,true)=false then
    begin
      Result:=-1;
      exit;
    end;

  //Get FM lowest allowed frequency value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.caps.fmFreqRange.lower?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u32');
      if Node<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=-1;
    end
  else
    Result:=-1;

  //disable NAV
  fsapi_Nav_State(URL,PIN,false);

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_FM_FreqRange_LowerCap -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=-1;
    end;
  end;
end;

function fsapi_FM_FreqRange_UpperCap(URL: String; PIN: String): Integer;
//get FM highest allowed frequency
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=-1;
      exit;
    end;

  //enable NAV
  if fsapi_Nav_State(URL,PIN,true)=false then
    begin
      Result:=-1;
      exit;
    end;

  //Get FM highest allowed frequency value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.caps.fmFreqRange.upper?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u32');
      if Node<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=-1;
    end
  else
    Result:=-1;

  //disable NAV
  fsapi_Nav_State(URL,PIN,false);

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_FM_FreqRange_UpperCap -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=-1;
    end;
  end;
end;

function fsapi_FM_FreqRange_Steps(URL: String; PIN: String): Integer;
//get FM allowed frequency steps
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=-1;
      exit;
    end;

  //enable NAV
  if fsapi_Nav_State(URL,PIN,true)=false then
    begin
      Result:=-1;
      exit;
    end;

  //Get FM frequency steps value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.caps.fmFreqRange.stepSize?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u32');
      if Node<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=-1;
    end
  else
    Result:=-1;

  //disable NAV
  fsapi_Nav_State(URL,PIN,false);

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_FM_FreqRange_Steps -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=-1;
    end;
  end;
end;

function fsapi_FM_SetFrequency(URL: String; PIN: String; Value: Integer): Boolean;
//Set FM frequency
var
  Buffer:     String;

begin
  try
  //check for valid frequency value (<0 defined as error)
  if Value<0 then
    begin
      Result:=false;
      exit;
    end;

  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send frequency command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.play.frequency?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_FM_SetFrequency -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_FM_GetFrequency(URL: String; PIN: String): Integer;
//Get FM frequency
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=-1;
      exit;
    end;

  //Get frequency from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.frequency?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u32');
      if Node.FirstChild<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=-1;
    end
  else
    Result:=-1;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_FM_GetFrequency -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=-1;
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Modes
//------------------------------------------------------------------------------
function fsapi_Modes_Get(URL: String; PIN: String): TStringList;
//Read valid modes
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Node2:      TDOMNode;
  Node3:      TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;
  Buffer3:    TStringList;
  Buffer4:    String;
  Buffer5:    String;
  KeyIndex:   Byte;

begin
  try
  //Create result stringlist
  Buffer3:=TStringList.Create;

  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=Buffer3;
      exit;
    end;

  //Get actual volume value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/LIST_GET_NEXT/netRemote.sys.caps.validModes/-1?pin='+PIN+'&sid='+fsapi_SessionID+'&maxItems=65536');
  {$IFDEF FSAPI_DEBUG}{$IFNDEF LCL}
  writeln(STR_Info,'fsapi_Modes_Get -> XML BEGIN');
  writeln('--------------------------------------------------------------------------------');
  write(Buffer);
  writeln('--------------------------------------------------------------------------------');
  writeln(STR_Info,'fsapi_Modes_Get -> XML END'+#13#10);
  {$ENDIF}{$ENDIF}
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FirstChild;
  while Assigned(Node) do
    begin
      if Node.NodeName='item' then
        begin
          KeyIndex:=StrToInt(AnsiString(Node.Attributes.Item[0].NodeValue));
          Node2:=Node.FirstChild;
          Buffer4:='';
          Buffer5:='';
          while Assigned(Node2) do
            begin
              if Node2.NodeName='field' then
                begin
                  if Node2.Attributes.Item[0].NodeValue='label' then
                    begin
                      Node3:=Node2.FindNode('c8_array');
                      if Node3.FirstChild<>NIL then
                        Buffer4:=AnsiString(Node3.FirstChild.NodeValue);
                    end;
                  if Node2.Attributes.Item[0].NodeValue='id' then
                    begin
                      Node3:=Node2.FindNode('c8_array');
                      if Node3.FirstChild<>NIL then
                        Buffer5:=AnsiString(Node3.FirstChild.NodeValue);
                    end;
                end;
              Node2:=Node2.NextSibling;
            end;
          Buffer3.Add(IntToStr(KeyIndex)+'|'+Buffer4+'|'+Buffer5);
        end;
      Node:=Node.NextSibling;
    end;
  Result:=Buffer3;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Modes_Get -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Buffer3.Clear;
      Result:=Buffer3;
    end;
  end;
end;

function fsapi_Modes_Set(URL: String; PIN: String; Value: Integer): Boolean;
//set new active mode
var
  Buffer:     String;

begin
  try
  //check for valid mode value (<0 defined as error)
  if Value<0 then
    begin
      Result:=false;
      exit;
    end;

  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send mode command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.sys.mode?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Modes_Set -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Modes_GetModeByIdLabel(URL: String; PIN: String; Value: String): Integer;
//get mode number by known ID or label
var
  Buffer:   TStringList;
  Buffer2:  TStringList;
  Index:  Byte;

begin
  try
  result:=-1;
  Buffer:=TStringList.Create;
  Buffer:=fsapi_Modes_Get(URL,PIN);
  if Buffer.Count=0 then
    exit;

  Value:=StringReplace(Value,'"','',[rfReplaceAll,rfIgnoreCase]);
  //check aliases for mode value
  Value:=fsapi_Modes_CheckModeAlias(Value);

  Buffer2:=TStringList.Create;
  for Index:=0 to Buffer.Count-1 do
    begin
      Buffer2:=TStringList.Create;
      Buffer2.StrictDelimiter:=true;
      Buffer2.Delimiter:='|';
      Buffer2.DelimitedText:=Buffer.Strings[Index];
      if (Value=UpperCase(Buffer2.Strings[1])) or (Value=UpperCase(Buffer2.Strings[2])) then
        begin
          Result:=Index;
          break;
        end;
    end;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Modes_GetModeByIdLabel -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=-1;
    end;
  end;
end;

function fsapi_Modes_GetModeLabelById(URL: String; PIN: String; Mode: Integer): String;
//get label by known mode number
var
  Buffer:   TStringList;
  Buffer2:  TStringList;
  Index:  Byte;

begin
  try
  result:='';
  Buffer:=TStringList.Create;
  Buffer:=fsapi_Modes_Get(URL,PIN);
  if (Buffer.Count=0) or (Mode=-1) then
    exit;

  Buffer2:=TStringList.Create;
  for Index:=0 to Buffer.Count-1 do
    begin
      Buffer2:=TStringList.Create;
      Buffer2.StrictDelimiter:=true;
      Buffer2.Delimiter:='|';
      Buffer2.DelimitedText:=Buffer.Strings[Index];
      if Mode=StrToInt(Buffer2.Strings[0]) then
        begin
          Result:=Buffer2.Strings[1];
          break;
        end;
    end;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Modes_GetModeLabelById -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Modes_SetModeByAlias(URL: String; PIN: String; Value: String): Boolean;
//set new active mode using a known alias or mode value
var
  Mode: Integer;

begin
  //set defaults as false/error
  Result:=false;
  Mode:=-1;

  //check for empty value
  if Value='' then
    exit;

  //try value as number
  try
  Mode:=StrToInt(Value);
  //try value as string
  except
  //check aliases for mode value
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}DebugPrint(STR_Info+'fsapi_Modes_SetModeByAlias -> using value as String');{$ENDIF}
      Value:=fsapi_Modes_CheckModeAlias(Value);
      Mode:=fsapi_Modes_GetModeByIdLabel(URL,PIN,Value);
    end;
  end;

  //check mode value for error
  if Mode=-1 then
    exit;

  //set new active mode
  Result:=fsapi_Modes_Set(URL,PIN,Mode);
end;

function fsapi_Modes_ActiveMode(URL: String; PIN: String): Integer;
//get active mode ID from device
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=-1;
      exit;
    end;

  //Get actual mode value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.mode?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u32');
      if Node<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=-1;
    end
  else
    Result:=-1;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Modes_ActiveMode -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=-1;
    end;
  end;
end;

function fsapi_Modes_ActiveModeLabel(URL: String; PIN: String): String;
//get active mode label from device
var
  Buffer: Integer;

begin
  try
  Buffer:=fsapi_Modes_ActiveMode(URL, PIN);
  if Buffer>-1 then
    Result:=fsapi_Modes_GetModeLabelById(URL, PIN, Buffer)
  else
    Result:='';
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Modes_ActiveModeLabel -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:='';
    end;
  end;
end;

function fsapi_Modes_CheckModeAlias(Mode: String): String;
//Check aliases for mode value
begin
  Mode:=UPPERCASE(Mode);
  if (Mode='BT') or (Mode='BLUE') then Mode:='BLUETOOTH';
  if (Mode='AUX') or (Mode='AUX EINGANG') then Mode:='AUXIN';
  if (Mode='UKW') or (Mode='UKWRADIO') then Mode:='FM';
  if (Mode='RADIO') or (Mode='DABRADIO') or (Mode='DIGITALRADIO') then Mode:='DAB';
  if (Mode='MUSIK ABSPIELEN') or (Mode='MUSIK') or (Mode='MUSIC') or (Mode='MP3') then Mode:='MP';
  if (Mode='INTERNET RADIO') or (Mode='INTERNETRADIO') or (Mode='INTERNET') or (Mode='WEB RADIO') or (Mode='WEBRADIO') or (Mode='WEB') then Mode:='IR';
  if (Mode='SPOT') or (Mode='SPOTIFY CONNECT') then Mode:='SPOTIFY';
  if (Mode='CDROM') or (Mode='CD-ROM') or (Mode='DISC') or (Mode='COMPACTDISC') then Mode:='CD';
  Result:=Mode;
end;

function fsapi_Modes_NextMode(URL: String; PIN: String): Boolean;
//switch to the next available mode
var
  Buffer:   Integer;
  Buffer2:  TStringList;
begin
  try
  Buffer:=fsapi_Modes_ActiveMode(URL, PIN);
  Buffer2:=TStringList.Create;
  Buffer2:=fsapi_Modes_Get(URL,PIN);
  if Buffer<Buffer2.Count-1 then
    Result:=fsapi_Modes_Set(URL, PIN, Buffer+1)
  else
    Result:=fsapi_Modes_Set(URL, PIN, 0);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Modes_NextMode -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Modes_PreviousMode(URL: String; PIN: String): Boolean;
//switch to the previous available mode
var
  Buffer:   Integer;
  Buffer2:  TStringList;
begin
  try
  Buffer:=fsapi_Modes_ActiveMode(URL, PIN);
  Buffer2:=TStringList.Create;
  Buffer2:=fsapi_Modes_Get(URL,PIN);
  if Buffer>0 then
    Result:=fsapi_Modes_Set(URL, PIN, Buffer-1)
  else
    Result:=fsapi_Modes_Set(URL, PIN, Buffer2.Count-1);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Modes_PreviousMode -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Standby
//------------------------------------------------------------------------------
function fsapi_Standby_State(URL: String; PIN: String): Boolean;
//Get Standby state
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Get actual standby value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.power?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          if Node.FirstChild.NodeValue='1' then
            Result:=true
          else
            Result:=false;
        end
      else
        Result:=false;
    end
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Standby_State -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Standby(URL: String; PIN: String): Boolean;
//Standby on/off
begin
  try
  if fsapi_Standby_State(URL, PIN)=false then
    Result:=fsapi_Standby_On(URL, PIN)
  else
    Result:=fsapi_Standby_Off(URL, PIN);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Standby -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Standby_On(URL: String; PIN: String): Boolean;
//Standby on
begin
  try
  Result:=fsapi_Standby_SetState(URL, PIN, 1);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Standby_On -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Standby_Off(URL: String; PIN: String): Boolean;
//Standby on
begin
  try
  Result:=fsapi_Standby_SetState(URL, PIN, 0);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Standby_Off -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Standby_SetState(URL: String; PIN: String; Value: Byte): Boolean;
//set standby mode
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send STANDBY on/off command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.sys.power?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Standby_SetState -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Play Control
//------------------------------------------------------------------------------
function fsapi_PlayControl_PlayPause(URL: String; PIN: String): Boolean;
//Toggle Play/Pause
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Get actual control value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.control?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          if Node.FirstChild.NodeValue='1' then
            Result:=fsapi_PlayControl_Pause(URL, PIN)
          else if Node.FirstChild.NodeValue='2' then
            Result:=fsapi_PlayControl_Play(URL, PIN)
          else
            Result:=false;
        end
      else
        Result:=false;
    end
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_PlayControl_PlayPause -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_PlayControl_Play(URL: String; PIN: String): Boolean;
//PlayControl Play
begin
  try
  Result:=fsapi_PlayControl_Value(URL, PIN, 1);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_PlayControl_Play -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_PlayControl_Pause(URL: String; PIN: String): Boolean;
//PlayControl Pause
begin
  try
  Result:=fsapi_PlayControl_Value(URL, PIN, 2);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_PlayControl_Pause -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_PlayControl_Next(URL: String; PIN: String): Boolean;
//PlayControl Next (song/station)
begin
  try
  Result:=fsapi_PlayControl_Value(URL, PIN, 3);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_PlayControl_Next -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_PlayControl_Previous(URL: String; PIN: String): Boolean;
//PlayControl Previous (song/station)
begin
  try
  Result:=fsapi_PlayControl_Value(URL, PIN, 4);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_PlayControl_Previous -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_PlayControl_Value(URL: String; PIN: String; Value: Byte): Boolean;
//Set PlayControl mode
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send PlayControl command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.play.control?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_PlayControl_Value -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_PlayControl_SetPositionMS(URL: String; PIN: String; Value: Integer): Boolean;
//set play position in ms
var
  Buffer:     String;

begin
  try
  //check for valid position value (<0 defined as error)
  if Value<0 then
    begin
      Result:=false;
      exit;
    end;

  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send position command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.play.position?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_PlayControl_SetPositionMS -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_PlayControl_SetPosition(URL: String; PIN: String; Value: String): Boolean;
//set play position in time format hh:mm:ss
var
  Buffer: Integer;

begin
  //check for correct time format
  try
  if not ((MidStr(Value,3,1)=':') and (MidStr(Value,6,1)=':') and (Length(Value)=8)) then
    begin
      Result:=false;
      exit;
    end;

  //conver time into seconds
  Buffer:=(StrToInt(MidStr(Value,1,2))*3600)+(StrToInt(MidStr(Value,4,2))*60)+StrToInt(MidStr(Value,7,2));
  //convert seconds to millisecond
  Buffer:=Buffer*1000;

  //set new position
  Result:=fsapi_PlayControl_SetPositionMS(URL, PIN, Buffer);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_PlayControl_SetPosition -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Mute
//------------------------------------------------------------------------------
function fsapi_Mute_State(URL: String; PIN: String): Boolean;
//Get Mute state
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Get actual Mute value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.audio.mute?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          if Node.FirstChild.NodeValue='1' then
            Result:=true
          else
            Result:=false;
        end
      else
        Result:=false;
    end
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Mute_State -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Mute(URL: String; PIN: String): Boolean;
//Mute on/off
begin
  try
  if fsapi_Mute_State(URL, PIN)=false then
    Result:=fsapi_Mute_On(URL, PIN)
  else
    Result:=fsapi_Mute_Off(URL, PIN);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Mute -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Mute_On(URL: String; PIN: String): Boolean;
//Mute on
begin
  try
  Result:=fsapi_Mute_SetState(URL, PIN, 1);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Mute_On -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Mute_Off(URL: String; PIN: String): Boolean;
//Mute off
begin
  try
  Result:=fsapi_Mute_SetState(URL, PIN, 0);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Mute_Off -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Mute_SetState(URL: String; PIN: String; Value: Byte): Boolean;
//Set Mute mode
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send Mute on/off command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.sys.audio.mute?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Mute_SetState -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Repeat
//------------------------------------------------------------------------------
function fsapi_Repeat_State(URL: String; PIN: String): Boolean;
//Get Repeat state
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Get actual Repeat value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.repeat?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          if Node.FirstChild.NodeValue='1' then
            Result:=true
          else
            Result:=false;
        end
      else
        Result:=false;
    end
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Repeat_State -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Repeat(URL: String; PIN: String): Boolean;
//Repeat on/off
begin
  try
  if fsapi_Repeat_State(URL, PIN)=false then
    Result:=fsapi_Repeat_On(URL, PIN)
  else
    Result:=fsapi_Repeat_Off(URL, PIN);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Repeat -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Repeat_On(URL: String; PIN: String): Boolean;
//Repeat on
begin
  try
  Result:=fsapi_Repeat_SetState(URL, PIN, 1);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Repeat_On -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Repeat_Off(URL: String; PIN: String): Boolean;
//Repeat off
begin
  try
  Result:=fsapi_Repeat_SetState(URL, PIN, 0);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Repeat_Off -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Repeat_SetState(URL: String; PIN: String; Value: Byte): Boolean;
//Set Repeat mode
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send Repeat command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.play.repeat?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Repeat_SetState -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Shuffle
//------------------------------------------------------------------------------
function fsapi_Shuffle_State(URL: String; PIN: String): Boolean;
//Get Shuffle state
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Get actual Shuffle value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.shuffle?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          if Node.FirstChild.NodeValue='1' then
            Result:=true
          else
            Result:=false;
        end
      else
        Result:=false;
    end
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Shuffle_State -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Shuffle(URL: String; PIN: String): Boolean;
//Shuffle on/off
begin
  try
  if fsapi_Shuffle_State(URL, PIN)=false then
    Result:=fsapi_Shuffle_On(URL, PIN)
  else
    Result:=fsapi_Shuffle_Off(URL, PIN);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Shuffle -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Shuffle_On(URL: String; PIN: String): Boolean;
//Shuffle on
begin
  try
  Result:=fsapi_Shuffle_SetState(URL, PIN, 1);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Shuffle_On -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Shuffle_Off(URL: String; PIN: String): Boolean;
//Shuffle off
begin
  try
  Result:=fsapi_Shuffle_SetState(URL, PIN, 0);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Shuffle_Off -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Shuffle_SetState(URL: String; PIN: String; Value: Byte): Boolean;
//Set Shuffle mode
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send Shuffle command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.play.shuffle?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Shuffle_SetState -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Scrobble
//------------------------------------------------------------------------------
function fsapi_Scrobble_State(URL: String; PIN: String): Boolean;
//Get Scrobble state
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Get actual Scrobble value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.play.scrobble?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          if Node.FirstChild.NodeValue='1' then
            Result:=true
          else
            Result:=false;
        end
      else
        Result:=false;
    end
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Scrobble_State -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Scrobble(URL: String; PIN: String): Boolean;
//Scrobble on/off
begin
  try
  if fsapi_Scrobble_State(URL, PIN)=false then
    Result:=fsapi_Scrobble_On(URL, PIN)
  else
    Result:=fsapi_Scrobble_Off(URL, PIN);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Scrobble -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Scrobble_On(URL: String; PIN: String): Boolean;
//Scrobble on
begin
  try
  Result:=fsapi_Scrobble_SetState(URL, PIN, 1);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Scrobble_On -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Scrobble_Off(URL: String; PIN: String): Boolean;
//Scrobble off
begin
  try
  Result:=fsapi_Scrobble_SetState(URL, PIN, 0);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Scrobble_Off -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Scrobble_SetState(URL: String; PIN: String; Value: Byte): Boolean;
//Set Scrobble mode
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send Scrobble command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.play.scrobble?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Scrobble_SetState -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Volume
//------------------------------------------------------------------------------
function fsapi_Volume_Get(URL: String; PIN: String): Byte;
//Read Volume value
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;
  Volume:     Integer;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=255;
      exit;
    end;

  //Get actual volume value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.audio.volume?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          Volume:=StrToInt(AnsiString(Node.FirstChild.NodeValue));
          if Volume<0 then Volume:=0;
          if Volume>254 then Volume:=fsapi_Volume_GetSteps(URL, PIN);
          Result:=Volume;
        end
      else
        Result:=255;
    end
  else
    Result:=255;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Volume_Get -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=255;
    end;
  end;
end;

function fsapi_Volume_GetSteps(URL: String; PIN: String): Byte;
//Read Volume steps (maximum volume should be "steps - 1")
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=255;
      exit;
    end;

  //Get volume steps from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.caps.volumeSteps?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        Result:=StrToInt(AnsiString(Node.FirstChild.NodeValue))
      else
        Result:=255;
    end
  else
    Result:=255;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Volume_GetSteps -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=255;
    end;
  end;
end;

function fsapi_Volume_Set(URL: String; PIN: String; Value: Byte): Boolean;
//Set Volume value
var
  Buffer:     String;
  MaxVolume:  Byte;

begin
  try
  //check for maximum allowed volume
  MaxVolume:=fsapi_Volume_GetSteps(URL, PIN);
  if (MaxVolume=255) or (Value>MaxVolume) then
    begin
      Result:=false;
      exit;
    end;

  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send volume command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.sys.audio.volume?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Volume_Set -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Volume_Up(URL: String; PIN: String): Boolean;
//Volume up
var
  Volume: Byte;

begin
  try
  Volume:=fsapi_Volume_Get(URL, PIN);
  if Volume=255 then
    begin
      Result:=true;
      exit
    end;
  Volume:=Volume+1;
  Result:=fsapi_Volume_Set(URL, PIN, Volume);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Volume_Up -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Volume_Down(URL: String; PIN: String): Boolean;
//Volume down
var
  Volume: Byte;

begin
  try
  Volume:=fsapi_Volume_Get(URL, PIN);
  if (Volume=0) or (Volume=255) then
    begin
      Result:=true;
      exit
    end;
  Volume:=Volume-1;
  Result:=fsapi_Volume_Set(URL, PIN, Volume);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Volume_Down -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// DAB
//------------------------------------------------------------------------------
function fsapi_DAB_Scan(URL: String; PIN: String): Boolean;
//Start DAB scan
var
  Buffer: String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //enable NAV
  if fsapi_Nav_State(URL,PIN,true)=false then
    begin
      Result:=false;
      exit;
    end;

  //Check if no DAB scan is already active and send DAB scan command
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.nav.action.dabScan?pin='+PIN+'&sid='+fsapi_SessionID);
  if (fsapi_CheckStatus(Buffer)='FS_OK') and (AnsiPos('<u8>0</u8>', Buffer)>0) then
    begin
      Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.nav.action.dabScan?pin='+PIN+'&sid='+fsapi_SessionID+'&value=1');
      if fsapi_CheckStatus(Buffer)='FS_OK' then
        Result:=true
      else
        Result:=false;
    end
  else
    Result:=false;

  //disable NAV
  fsapi_Nav_State(URL,PIN,false);

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_DAB_Scan -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_DAB_Prune(URL: String; PIN: String): Boolean;
//Start DAB prune
var
  Buffer: String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //enable NAV
  if fsapi_Nav_State(URL,PIN,true)=false then
    begin
      Result:=false;
      exit;
    end;

  //Check if no DAB prune is already active and send DAB prune command
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.nav.action.dabPrune?pin='+PIN+'&sid='+fsapi_SessionID);
  if (fsapi_CheckStatus(Buffer)='FS_OK') and (AnsiPos('<u8>0</u8>', Buffer)>0) then
    begin
      Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.nav.action.dabPrune?pin='+PIN+'&sid='+fsapi_SessionID+'&value=1');
      if fsapi_CheckStatus(Buffer)='FS_OK' then
        Result:=true
      else
        Result:=false;
    end
  else
    Result:=false;

  //disable NAV
  fsapi_Nav_State(URL,PIN,false);

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_DAB_Prune -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_DAB_FrequencyList(URL: String; PIN: String): TStringList;
//List available DAB frequencies
const
  STEP:       Integer = 20;
  MAXITEMS:   Integer = 255;

var
  XMLBuffer:  String;
  Buffer:     TStringStream;
  Buffer2:    String;
  Buffer3:    String;
  FreqList:   TStringList;
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Node2:      TDOMNode;
  Node3:      TDOMNode;
  KeyIndex:   Integer;
  Round:      Integer;

begin
  try
  FreqList:=TStringList.Create;
  FreqList.Clear;

  for Round:=0 to (MAXITEMS div STEP)+1 do
    begin
      //enable NAV
      if fsapi_Nav_State(URL,PIN,true)=false then
        begin
          Result:=FreqList;
          exit;
        end;
      //read presets list part
      XMLBuffer:=fsapi_LIST_GET_NEXT(URL,PIN,'netRemote.sys.caps.dabFreqList/'+IntToStr((ROUND*STEP)-1),STEP);
      //disable NAV
      fsapi_Nav_State(URL,PIN,false);

      {$IFDEF FSAPI_DEBUG}{$IFNDEF LCL}
      writeln(STR_Info,'fsapi_LIST_GET_NEXT '+IntToStr(Round)+' -> XML BEGIN');
      writeln('--------------------------------------------------------------------------------');
      write(XMLBuffer);
      writeln('--------------------------------------------------------------------------------');
      writeln(STR_Info,'fsapi_LIST_GET_NEXT '+IntToStr(Round)+' -> XML END'+#13#10);
      {$ENDIF}{$ENDIF}
      if (fsapi_CheckStatus(XMLBuffer)='FS_OK') or (fsapi_CheckStatus(XMLBuffer)='FS_LIST_END') then
        begin
          Buffer:=TStringStream.Create(XMLBuffer);
          ReadXMLFile(XML, Buffer);
          Node:=XML.DocumentElement.FirstChild;
          while Assigned(Node) do
            begin
              if Node.NodeName='item' then
                begin
                  KeyIndex:=StrToInt(AnsiString(Node.Attributes.Item[0].NodeValue));
                  Node2:=Node.FirstChild;
                  Buffer2:='';
                  while Assigned(Node2) do
                    begin
                      if Node2.Attributes.Item[0].NodeValue='freq' then
                        begin
                          Node3:=Node2.FindNode('u32');
                          if Node3.FirstChild<>NIL then
                            Buffer2:=AnsiString(Node3.FirstChild.NodeValue);
                        end;
                      if Node2.Attributes.Item[0].NodeValue='label' then
                        begin
                          Node3:=Node2.FindNode('c8_array');
                          if Node3.FirstChild<>NIL then
                            Buffer3:=AnsiString(Node3.FirstChild.NodeValue);
                        end;
                      Node2:=Node2.NextSibling;
                    end;
                  if (Buffer2<>'') and (Buffer3<>'') then
                    FreqList.Add(IntToStr(KeyIndex)+'|'+Buffer2+'|'+Buffer3);
                end;
              Node:=Node.NextSibling;
            end;
          if Pos('<listend/>',LowerCase(XMLBuffer))>0 then
            break;
        end
      else
        break;
    end;

  Result:=FreqList;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_DAB_FrequencyList -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=FreqList;
    end;
  end;
end;

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Presets
//------------------------------------------------------------------------------
function fsapi_Presets_List(URL: String; PIN: String): TStringList;
//List available preseta
const
  STEP:       Integer = 20;
  MAXITEMS:   Integer = 255;

var
  XMLBuffer:  String;
  Buffer:     TStringStream;
  Buffer2:    String;
  PresetList: TStringList;
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Node2:      TDOMNode;
  Node3:      TDOMNode;
  KeyIndex:   Integer;
  Round:      Integer;

begin
  try
  PresetList:=TStringList.Create;
  PresetList.Clear;

  for Round:=0 to (MAXITEMS div STEP)+1 do
    begin
      //enable NAV
      if fsapi_Nav_State(URL,PIN,true)=false then
        begin
          Result:=PresetList;
          exit;
        end;
      //read presets list part
      XMLBuffer:=fsapi_LIST_GET_NEXT(URL,PIN,'netRemote.nav.presets/'+IntToStr((ROUND*STEP)-1),STEP);
      //disable NAV
      fsapi_Nav_State(URL,PIN,false);

      {$IFDEF FSAPI_DEBUG}{$IFNDEF LCL}
      writeln(STR_Info,'fsapi_LIST_GET_NEXT '+IntToStr(Round)+' -> XML BEGIN');
      writeln('--------------------------------------------------------------------------------');
      write(XMLBuffer);
      writeln('--------------------------------------------------------------------------------');
      writeln(STR_Info,'fsapi_LIST_GET_NEXT '+IntToStr(Round)+' -> XML END'+#13#10);
      {$ENDIF}{$ENDIF}
      if (fsapi_CheckStatus(XMLBuffer)='FS_OK') or (fsapi_CheckStatus(XMLBuffer)='FS_LIST_END') then
        begin
          Buffer:=TStringStream.Create(XMLBuffer);
          ReadXMLFile(XML, Buffer);
          Node:=XML.DocumentElement.FirstChild;
          while Assigned(Node) do
            begin
              if Node.NodeName='item' then
                begin
                  KeyIndex:=StrToInt(AnsiString(Node.Attributes.Item[0].NodeValue));
                  Node2:=Node.FirstChild;
                  Buffer2:='';
                  while Assigned(Node2) do
                    begin
                      if Node2.NodeName='field' then
                        begin
                          if Node2.Attributes.Item[0].NodeValue='name' then
                            begin
                              Node3:=Node2.FindNode('c8_array');
                              if Node3.FirstChild<>NIL then
                                Buffer2:=AnsiString(Node3.FirstChild.NodeValue);
                            end;
                        end;
                      Node2:=Node2.NextSibling;
                    end;
                  if Buffer2<>'' then
                    PresetList.Add(IntToStr(KeyIndex)+'|'+Buffer2);
                end;
              Node:=Node.NextSibling;
            end;
          if Pos('<listend/>',LowerCase(XMLBuffer))>0 then
            break;
        end
      else
        break;
    end;

  Result:=PresetList;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Presets_List -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=PresetList;
    end;
  end;
end;

function fsapi_Presets_Set(URL: String; PIN: String; Value: Integer): Boolean;
//Set preset
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //enable NAV
  if fsapi_Nav_State(URL,PIN,true)=false then
    begin
      Result:=false;
      exit;
    end;

  //Send preset set command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.nav.action.selectPreset?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;

  //disable NAV
  if fsapi_Nav_State(URL,PIN,false)=false then
    begin
      Result:=false;
      exit;
    end;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Presets_Set -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Presets_Add(URL: String; PIN: String; Value: Integer): Boolean;
//Add preset
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send preset add command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.play.addPreset?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Presets_Add -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Presets_NextPreset(URL: String; PIN: String): Boolean;
//switch to the next available preset
var
  Index:    Integer;
  Index2:   Integer;
  Index3:   Integer;
  Buffer:   TStringList;
  Buffer2:  String;

begin
  try
  //read list with all available presets
  Buffer:=TStringList.Create;
  Buffer:=fsapi_Presets_List(URL,PIN);
  if Buffer.Text='' then
    begin
      Result:=false;
      exit;
    end;
  //try to read the info name to determine the actual active preset
  Buffer2:=fsapi_Info_Name(URL,PIN);

  //search for the next available preset starting from the actual preset
  for Index:=0 to Buffer.Count-1 do
    begin
      if Pos(Buffer2,Buffer.Strings[Index])>0 then
        begin
          break;
        end;
    end;
  Index:=StrToInt(LeftStr(Buffer.Strings[Index],1));
  Index3:=10;
  while Index<10 do
    begin
      Index:=Index+1;
      for Index2:=0 to Buffer.Count-1 do
        begin
          if LeftStr(Buffer.Strings[Index2],1)=IntToStr(Index) then
            begin
              Index3:=Index;
              break;
            end;
        end;
      if Index3<>10 then
        break;
    end;

  //if highest preset is already selected start again with lowest preset index
  if Index3>9 then
    Index3:=StrToInt(LeftStr(Buffer.Strings[0],1));

  Result:=fsapi_Presets_Set(URL, PIN, Index3)
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Presets_NextPreset -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Presets_PreviousPreset(URL: String; PIN: String): Boolean;
//switch to the previous available preset
var
  Index:    Integer;
  Index2:   Integer;
  Index3:   Integer;
  Buffer:   TStringList;
  Buffer2:  String;

begin
  try
  //read list with all available presets
  Buffer:=TStringList.Create;
  Buffer:=fsapi_Presets_List(URL,PIN);
  if Buffer.Text='' then
    begin
      Result:=false;
      exit;
    end;
  //try to read the info name to determine the actual active preset
  Buffer2:=fsapi_Info_Name(URL,PIN);

  //search for the next available preset starting from the actual preset
  for Index:=0 to Buffer.Count-1 do
    begin
      if Pos(Buffer2,Buffer.Strings[Index])>0 then
        begin
          break;
        end;
    end;
  Index:=StrToInt(LeftStr(Buffer.Strings[Index],1));
  Index3:=-1;
  while Index>-1 do
    begin
      Index:=Index-1;
      for Index2:=0 to Buffer.Count-1 do
        begin
          if LeftStr(Buffer.Strings[Index2],1)=IntToStr(Index) then
            begin
              Index3:=Index;
              break;
            end;
        end;
      if Index3<>-1 then
        break;
    end;

  //if lowest preset is already selected start again with highest preset index
  if Index3<0 then
    Index3:=StrToInt(LeftStr(Buffer.Strings[Buffer.Count-1],1));

  Result:=fsapi_Presets_Set(URL, PIN, Index3)
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Presets_PreviousPreset -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Navigation
//------------------------------------------------------------------------------
function fsapi_Nav_State(URL: String; PIN: String; STATE: Boolean): Boolean;
//set new NAV state
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Set new NAV state
  if STATE=true then
    Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.nav.state?pin='+PIN+'&sid='+fsapi_SessionID+'&value=1')
  else
    Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.nav.state?pin='+PIN+'&sid='+fsapi_SessionID+'&value=0');
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Nav_State -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Nav_List(URL: String; PIN: String): TStringList;
//List available navigation items
const
  STEP:       Integer = 20;
  MAXITEMS:   Integer = 1000;

var
  XMLBuffer:  String;
  Buffer:     TStringStream;
  Buffer2:    String;
  Buffer3:    String;
  Buffer4:    String;
  NavList:    TStringList;
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Node2:      TDOMNode;
  Node3:      TDOMNode;
  KeyIndex:   Integer;
  Round:      Integer;

begin
  try
  NavList:=TStringList.Create;
  NavList.Clear;
  NavList.TextLineBreakStyle:=tlbsCRLF;
  NavList.Duplicates:=dupIgnore;
  NavList.SortStyle:=sslAuto;

  for Round:=0 to (MAXITEMS div STEP)+1 do
    begin
      //read list part
      XMLBuffer:=fsapi_LIST_GET_NEXT(URL,PIN,'netRemote.nav.list/'+IntToStr((ROUND*STEP)-1),STEP);

      {$IFDEF FSAPI_DEBUG}{$IFNDEF LCL}
      writeln(STR_Info,'fsapi_Nav_List '+IntToStr(Round)+' -> XML BEGIN');
      writeln('--------------------------------------------------------------------------------');
      write(XMLBuffer);
      writeln('--------------------------------------------------------------------------------');
      writeln(STR_Info,'fsapi_Nav_List '+IntToStr(Round)+' -> XML END'+#13#10);
      {$ENDIF}{$ENDIF}

      //check results
      if (fsapi_CheckStatus(XMLBuffer)='FS_OK') or (fsapi_CheckStatus(XMLBuffer)='FS_LIST_END') then
        begin
          //analyze XML output
          Buffer:=TStringStream.Create(XMLBuffer);
          ReadXMLFile(XML, Buffer);
          Node:=XML.DocumentElement.FirstChild;
          while Assigned(Node) do
            begin
              if Node.NodeName='item' then
                begin
                  KeyIndex:=StrToInt(AnsiString(Node.Attributes.Item[0].NodeValue));
                  Node2:=Node.FirstChild;
                  Buffer2:='';
                  while Assigned(Node2) do
                    begin
                      if Node2.NodeName='field' then
                        begin
                          if Node2.Attributes.Item[0].NodeValue='name' then
                            begin
                              Node3:=Node2.FindNode('c8_array');
                              if Node3.FirstChild<>NIL then
                                Buffer2:=AnsiString(Node3.FirstChild.NodeValue);
                            end;
                          if Node2.Attributes.Item[0].NodeValue='type' then
                            begin
                              Node3:=Node2.FindNode('u8');
                              if Node3.FirstChild<>NIL then
                                Buffer3:=AnsiString(Node3.FirstChild.NodeValue);
                            end;
                          if Node2.Attributes.Item[0].NodeValue='subtype' then
                            begin
                              Node3:=Node2.FindNode('u8');
                              if Node3.FirstChild<>NIL then
                                Buffer4:=AnsiString(Node3.FirstChild.NodeValue);
                            end;
                        end;
                      Node2:=Node2.NextSibling;
                    end;
                  if Buffer2<>'' then
                    NavList.Add(IntToStr(KeyIndex)+'|'+Buffer2+'|'+Buffer3+'|'+Buffer4);
                end;
              Node:=Node.NextSibling;
            end;
          if Pos('<listend/>',LowerCase(XMLBuffer))>0 then
            break;
        end
      else
        break;
    end;

  Result:=NavList;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Nav_List -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=NavList;
    end;
  end;
end;

function fsapi_Nav_Navigate(URL: String; PIN: String; Value: Integer): Boolean;
//select navigation item (must be type = 0)
var
  Buffer:     String;

begin
  try
  //check for valid mode value (<0 defined as error)
  if Value<0 then
    begin
      Result:=false;
      exit;
    end;

  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send navigate command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.nav.action.navigate?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Nav_Navigate -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Nav_SelectItem(URL: String; PIN: String; Value: Integer): Boolean;
//select navigation item (must be type > 0)
var
  Buffer:     String;

begin
  try
  //check for valid mode value (<0 defined as error)
  if Value<0 then
    begin
      Result:=false;
      exit;
    end;

  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send select command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.nav.action.selectItem?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Nav_SelectItem -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Nav_NavigateSelectItem(URL: String; PIN: String; Value: Integer; NavType: Integer): Boolean;
//Navigaten wrapper for differen navigation item types
begin
  try
  //check for valid mode and navigation type value (<0 defined as error)
  if (Value<0) or (NavType<0) then
    begin
      Result:=false;
      exit;
    end;
  if NavType=0 then
    Result:=fsapi_Nav_Navigate(URL,PIN,Value)
  else
    Result:=fsapi_Nav_SelectItem(URL,PIN,Value);
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Nav_NavigateSelectItem -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Nav_Caps(URL: String; PIN: String): Integer;
//get navigation caps
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=-1;
      exit;
    end;

  //Get navigation caps value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.nav.caps?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u32');
      if Node<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=-1;
    end
  else
    Result:=-1;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Nav_Caps -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=-1;
    end;
  end;
end;

function fsapi_Nav_NumItems(URL: String; PIN: String): Integer;
//get navigation item count
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=-1;
      exit;
    end;

  //Get navigation item count value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.nav.numItems?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('s32');
      if Node<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=-1;
    end
  else
    Result:=-1;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Nav_NumItems -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=-1;
    end;
  end;
end;

function fsapi_Nav_Status(URL: String; PIN: String): Integer;
//Navigation status
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=-1;
      exit;
    end;

  //Get actual navigation status value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.nav.status?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          Result:=StrToInt(String(Node.FirstChild.NodeValue));
        end
      else
        Result:=-1;
    end
  else
    Result:=-1;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Nav_Status -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=-1;
    end;
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// System
//------------------------------------------------------------------------------
function fsapi_Sys_State(URL: String; PIN: String): Integer;
//System state
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=-1;
      exit;
    end;


  //Get actual system state value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.state?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          Result:=StrToInt(String(Node.FirstChild.NodeValue));
        end
      else
        Result:=-1;
    end
  else
    Result:=-1;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Sys_State -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=-1;
    end;
  end;
end;

function fsapi_Sys_SetSleepTimer(URL: String; PIN: String; Value: Integer): Boolean;
//Set sleeptimer time
var
  Buffer:     String;

begin
  try
  //check for valid time value (<0 defined as error)
  if Value<0 then
    begin
      Result:=false;
      exit;
    end;

  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send sleep command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.sys.sleep?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Sys_SetSleepTimer -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Sys_GetSleepTimer(URL: String; PIN: String): Integer;
//Get sleeptimer time
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=-1;
      exit;
    end;

  //Get sleeptimer time from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.sleep?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u32');
      if Node.FirstChild<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=-1;
    end
  else
    Result:=-1;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Sys_GetSleepTimer -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=-1;
    end;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Equalizer Presets
//------------------------------------------------------------------------------
function fsapi_Equalizer_Presets_List(URL: String; PIN: String): TStringList;
//List available equalizer presets
const
  STEP:       Integer = 20;
  MAXITEMS:   Integer = 255;

var
  XMLBuffer:    String;
  Buffer:       TStringStream;
  Buffer2:      String;
  EqPresetList: TStringList;
  XML:          TXMLDocument;
  Node:         TDOMNode;
  Node2:        TDOMNode;
  Node3:        TDOMNode;
  KeyIndex:     Integer;
  Round:        Integer;

begin
  try
  EqPresetList:=TStringList.Create;
  EqPresetList.Clear;

  for Round:=0 to (MAXITEMS div STEP)+1 do
    begin
      //enable NAV
      if fsapi_Nav_State(URL,PIN,true)=false then
        begin
          Result:=EqPresetList;
          exit;
        end;
      //read presets list part
      XMLBuffer:=fsapi_LIST_GET_NEXT(URL,PIN,'netRemote.sys.caps.eqPresets/'+IntToStr((ROUND*STEP)-1),STEP);
      //disable NAV
      fsapi_Nav_State(URL,PIN,false);

      {$IFDEF FSAPI_DEBUG}{$IFNDEF LCL}
      writeln(STR_Info,'fsapi_LIST_GET_NEXT '+IntToStr(Round)+' -> XML BEGIN');
      writeln('--------------------------------------------------------------------------------');
      write(XMLBuffer);
      writeln('--------------------------------------------------------------------------------');
      writeln(STR_Info,'fsapi_LIST_GET_NEXT '+IntToStr(Round)+' -> XML END'+#13#10);
      {$ENDIF}{$ENDIF}
      if (fsapi_CheckStatus(XMLBuffer)='FS_OK') or (fsapi_CheckStatus(XMLBuffer)='FS_LIST_END') then
        begin
          Buffer:=TStringStream.Create(XMLBuffer);
          ReadXMLFile(XML, Buffer);
          Node:=XML.DocumentElement.FirstChild;
          while Assigned(Node) do
            begin
              if Node.NodeName='item' then
                begin
                  KeyIndex:=StrToInt(AnsiString(Node.Attributes.Item[0].NodeValue));
                  Node2:=Node.FirstChild;
                  Buffer2:='';
                  while Assigned(Node2) do
                    begin
                      if Node2.NodeName='field' then
                        begin
                          if Node2.Attributes.Item[0].NodeValue='label' then
                            begin
                              Node3:=Node2.FindNode('c8_array');
                              if Node3.FirstChild<>NIL then
                                Buffer2:=AnsiString(Node3.FirstChild.NodeValue);
                            end;
                        end;
                      Node2:=Node2.NextSibling;
                    end;
                  if Buffer2<>'' then
                    EqPresetList.Add(IntToStr(KeyIndex)+'|'+Buffer2);
                end;
              Node:=Node.NextSibling;
            end;
          if Pos('<listend/>',LowerCase(XMLBuffer))>0 then
            break;
        end
      else
        break;
    end;

  Result:=EqPresetList;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Equalizer_Presets_List -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=EqPresetList;
    end;
  end;
end;

function fsapi_Equalizer_Bands_List(URL: String; PIN: String): TStringList;
//List available equalizer bands
const
  STEP:       Integer = 20;
  MAXITEMS:   Integer = 255;

var
  XMLBuffer:    String;
  Buffer:       TStringStream;
  Buffer2:      String;
  Buffer3:      String;
  Buffer4:      String;
  EqPresetList: TStringList;
  XML:          TXMLDocument;
  Node:         TDOMNode;
  Node2:        TDOMNode;
  Node3:        TDOMNode;
  KeyIndex:     Integer;
  Round:        Integer;

begin
  try
  EqPresetList:=TStringList.Create;
  EqPresetList.Clear;

  for Round:=0 to (MAXITEMS div STEP)+1 do
    begin
      //enable NAV
      if fsapi_Nav_State(URL,PIN,true)=false then
        begin
          Result:=EqPresetList;
          exit;
        end;
      //read presets list part
      XMLBuffer:=fsapi_LIST_GET_NEXT(URL,PIN,'netRemote.sys.caps.eqBands/'+IntToStr((ROUND*STEP)-1),STEP);
      //disable NAV
      fsapi_Nav_State(URL,PIN,false);

      {$IFDEF FSAPI_DEBUG}{$IFNDEF LCL}
      writeln(STR_Info,'fsapi_LIST_GET_NEXT '+IntToStr(Round)+' -> XML BEGIN');
      writeln('--------------------------------------------------------------------------------');
      write(XMLBuffer);
      writeln('--------------------------------------------------------------------------------');
      writeln(STR_Info,'fsapi_LIST_GET_NEXT '+IntToStr(Round)+' -> XML END'+#13#10);
      {$ENDIF}{$ENDIF}
      if (fsapi_CheckStatus(XMLBuffer)='FS_OK') or (fsapi_CheckStatus(XMLBuffer)='FS_LIST_END') then
        begin
          Buffer:=TStringStream.Create(XMLBuffer);
          ReadXMLFile(XML, Buffer);
          Node:=XML.DocumentElement.FirstChild;
          while Assigned(Node) do
            begin
              if Node.NodeName='item' then
                begin
                  KeyIndex:=StrToInt(AnsiString(Node.Attributes.Item[0].NodeValue));
                  Node2:=Node.FirstChild;
                  Buffer2:='';
                  while Assigned(Node2) do
                    begin
                      if Node2.NodeName='field' then
                        begin
                          if Node2.Attributes.Item[0].NodeValue='label' then
                            begin
                              Node3:=Node2.FindNode('c8_array');
                              if Node3.FirstChild<>NIL then
                                Buffer2:=AnsiString(Node3.FirstChild.NodeValue);
                            end;
                          if Node2.Attributes.Item[0].NodeValue='min' then
                            begin
                              Node3:=Node2.FindNode('s16');
                              if Node3.FirstChild<>NIL then
                                Buffer3:=AnsiString(Node3.FirstChild.NodeValue);
                            end;
                          if Node2.Attributes.Item[0].NodeValue='max' then
                            begin
                              Node3:=Node2.FindNode('s16');
                              if Node3.FirstChild<>NIL then
                                Buffer4:=AnsiString(Node3.FirstChild.NodeValue);
                            end;
                        end;
                      Node2:=Node2.NextSibling;
                    end;
                  if (Buffer2<>'') and  (Buffer3<>'') and (Buffer4<>'') then
                    EqPresetList.Add(IntToStr(KeyIndex)+'|'+Buffer2+'|'+Buffer3+'|'+Buffer4);
                end;
              Node:=Node.NextSibling;
            end;
          if Pos('<listend/>',LowerCase(XMLBuffer))>0 then
            break;
        end
      else
        break;
    end;

  Result:=EqPresetList;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Equalizer_Bands_List -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=EqPresetList;
    end;
  end;
end;

function fsapi_Equalizer_Get(URL: String; PIN: String): Byte;
//Read actual set equalizer value
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=255;
      exit;
    end;

  //Get equalizer value from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.audio.eqPreset?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);
  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('u8');
      if Node<>NIL then
        begin
          Result:=StrToInt(AnsiString(Node.FirstChild.NodeValue));
        end
      else
        Result:=255;
    end
  else
    Result:=255;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Equalizer_Get -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=255;
    end;
  end;
end;

function fsapi_Equalizer_Set(URL: String; PIN: String; Value: Byte): Boolean;
//Set Equalizer value
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send volume command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.sys.audio.eqPreset?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Equalizer_Set -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Equalizer_CustomParam0_Set(URL: String; PIN: String; Value: Integer): Boolean;
//Set equalizer custom parameter 0
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send equalizer custom parameter value command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.sys.audio.eqCustom.param0?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Equalizer_CustomParam0_Set -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Equalizer_CustomParam0_Get(URL: String; PIN: String): Integer;
//Get equalizer custom parameter 0
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=255;
      exit;
    end;

  //Get equalizer custom parameter 0 from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.audio.eqCustom.param0?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('s16');
      if Node.FirstChild<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=255;
    end
  else
    Result:=255;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Equalizer_CustomParam0_Get -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=255;
    end;
  end;
end;

function fsapi_Equalizer_CustomParam1_Set(URL: String; PIN: String; Value: Integer): Boolean;
//Set equalizer custom parameter 1
var
  Buffer:     String;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=false;
      exit;
    end;

  //Send equalizer custom parameter value command
  Buffer:=fsapi_HTTP(URL+'/fsapi/SET/netRemote.sys.audio.eqCustom.param1?pin='+PIN+'&sid='+fsapi_SessionID+'&value='+IntToStr(Value));
  if fsapi_CheckStatus(Buffer)='FS_OK' then
    Result:=true
  else
    Result:=false;
  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Equalizer_CustomParam1_Set -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=false;
    end;
  end;
end;

function fsapi_Equalizer_CustomParam1_Get(URL: String; PIN: String): Integer;
//Get equalizer custom parameter 1
var
  XML:        TXMLDocument;
  Node:       TDOMNode;
  Buffer:     String;
  Buffer2:    TStringStream;

begin
  try
  //Get session ID
  fsapi_SessionID:=fsapi_CreateSession(URL, PIN);
  if fsapi_SessionID='' then
    begin
      Result:=255;
      exit;
    end;

  //Get equalizer custom parameter 1 from device
  Buffer:=fsapi_HTTP(URL+'/fsapi/GET/netRemote.sys.audio.eqCustom.param1?pin='+PIN+'&sid='+fsapi_SessionID);
  Buffer2:=TStringStream.Create(Buffer);

  ReadXMLFile(XML, Buffer2);
  Node:=XML.DocumentElement.FindNode('value');
  if Node<>NIL then
    begin
      Node:=Node.FindNode('s16');
      if Node.FirstChild<>NIL then
        Result:=StrToInt(String(Node.FirstChild.NodeValue))
      else
        Result:=255;
    end
  else
    Result:=255;

  except
  on E:Exception do
    begin
      {$IFDEF FSAPI_DEBUG}E.Message:=STR_Error+'fsapi_Equalizer_CustomParam1_Get -> '+E.Message; DebugPrint(E.Message);{$ENDIF}
      Result:=255;
    end;
  end;
end;

//------------------------------------------------------------------------------

end.


