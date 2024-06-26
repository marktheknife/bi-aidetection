; #######################################################################################
; # This Inno Setup script was generated by Visual & Installer for MS Visual Studio     #
; # Visual & Installer (c) 2012 - 2021 unSigned, s. r. o. All Rights Reserved.          #
; # Visit http://www.visual-installer.com/ for more details.                            #
; #######################################################################################

; This script is perhaps one of the simplest Inno Setup installer you can make. 
; All of the optional settings are left to their default settings. 

; See the Inno Setup documentation at http://www.jrsoftware.org/ for details on creating script files!    

;--------------------------------
; Get the App Version from Main Program
; This Is Full App Version Major.Minor.Build.Revision
; Store First 3 Parts of Version in ShortAppVersion to be used for SBS Assembly Installation Major.Minor.Build
#dim Version[4]
#expr ParseVersion("..\UI\bin\Debug\net8.0-windows10.0.19041.0\AITOOL.exe", Version[0], Version[1], Version[2], Version[3])
#define AppVersion Str(Version[0]) + "." + Str(Version[1]) + "." + Str(Version[2]) + "." + Str(Version[3])
#define ShortAppVersion Str(Version[0]) + "." + Str(Version[1]) + "." + Str(Version[2])
#define ShorterAppVersion Str(Version[0]) + "." + Str(Version[1])
[Setup]
AppName=AITOOL
AppVerName=AITOOL {#ShorterAppVersion}
AppPublisher=VorlonCD
AppVersion={#ShorterAppVersion}
VersionInfoVersion={#ShortAppVersion}
DefaultDirName={code:GetInstallationPath}
UsePreviousAppDir=yes
DefaultGroupName=AITOOL
UninstallDisplayIcon={app}\AITool.exe
SetupIconFile=logo.ico
Compression=lzma2
SolidCompression=yes
OutputDir=..\UI\Installer
OutputBaseFilename=AIToolSetup.{#ShortAppVersion}
PrivilegesRequired=admin
DirExistsWarning=no
DisableWelcomePage=yes
DisableDirPage=no
WizardStyle=modern
Uninstallable=WizardIsComponentSelected('full')
[Types]
Name: "full"; Description: "Full Installation"
Name: "portable"; Description: "Just Extract/Update Files"

[Components]
Name: "full"; Description: "full"; Types: full
Name: "portable"; Description: "Portable Installation"; Types: portable

[Tasks]
Name: "desktopicon"; Description: "Create a Desktop shortcut"; Components: full; Flags: unchecked
Name: "startmenu"; Description: "Create a Start Menu entry"; Components: full
[Run]
Filename: "{app}\AITOOL.exe"; Flags: nowait postinstall skipifsilent

[Files]
//Source: "Script.iss"; DestDir: "{app}"
Source: "..\UI\bin\Debug\net8.0-windows10.0.19041.0\*"; DestDir: "{app}";Flags: recursesubdirs ignoreversion;Excludes: "AIToolSetup*,_Settings"
[Icons]
Name: "{group}\AITOOL"; Filename: "{app}\AITOOL.exe" ; Components: full; Tasks: startmenu
Name: "{userdesktop}\AITOOL"; Filename: "{app}\AITOOL.exe" ; Components: full; Tasks: desktopicon

[Code]

// Place your code here...   

function GetInstallationPath(Param: string): string;
var
  Value: string;
begin
  if RegQueryStringValue(
       HKEY_CURRENT_USER, 'SOFTWARE\AITool\AITool\{#ShorterAppVersion}',
       'LastRunPath', Value) then
    begin
        Result := Value;
    end
  else
    begin
        Result := 'C:\AITOOL'
    end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := False;

  if PageID = wpSelectProgramGroup then
  begin
    Result := WizardIsComponentSelected('portable');
  end;
end;

function IsDotNetInstalled(DotNetName: string): Boolean;
var
  Cmd, Args: string;
  FileName: string;
  Output: AnsiString;
  Command: string;
  ResultCode: Integer;
begin
  FileName := ExpandConstant('{tmp}\dotnet.txt');
  Cmd := ExpandConstant('{cmd}');
  Command := 'dotnet --list-runtimes';
  Args := '/C ' + Command + ' > "' + FileName + '" 2>&1';
  if Exec(Cmd, Args, '', SW_HIDE, ewWaitUntilTerminated, ResultCode) and
     (ResultCode = 0) then
  begin
    if LoadStringFromFile(FileName, Output) then
    begin
      if Pos(DotNetName, Output) > 0 then
      begin
        Log('"' + DotNetName + '" found in output of "' + Command + '"');
        Result := True;
      end
        else
      begin
        Log('"' + DotNetName + '" not found in output of "' + Command + '"');
        Result := False;
      end;
    end
      else
    begin
      Log('Failed to read output of "' + Command + '"');
    end;
  end
    else
  begin
    Log('Failed to execute "' + Command + '"');
    Result := False;
  end;
  DeleteFile(FileName);
end;

function InitializeSetup(): Boolean;
var
  ErrorCode: Integer;
begin
    if not IsDotNetInstalled('Microsoft.NETCore.App 8.0.') then begin
        MsgBox('AITOOL requires Microsoft .NET 8.0'#13#13
            'https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-8.0.4-windows-x64-installer,'#13
            '...and then re-run the MyApp setup program.', mbInformation, MB_OK);
		Exec('explorer', 'https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-8.0.4-windows-x64-installer', '', SW_SHOW, ewNoWait, ErrorCode);
        result := false;
    end else
        result := true;
end;
