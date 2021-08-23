; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "__Decenomy__ Core"
#define MyAppPublisher "2021 DECENOMY Core Developers"
#define MyAppURL "https://__decenomy__.com"
#define MyAppExeName "__decenomy__-qt.exe"
#define MyAppExtraData "https://explorer.decenomy.net/bootstraps/BIR/bootstrap.zip"
#define MyAppVersion GetVersionNumbersString(".\package\" + MyAppExeName)

#include ReadReg(HKLM, 'Software\WOW6432Node\Mitrich Software\Inno Download Plugin', 'InstallDir') + '\idp.iss'

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{67A6CA9B-71C3-4FE2-AA2E-D0DF3D53C4EB}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
VersionInfoVersion={#MyAppVersion}
VersionInfoProductVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\__Decenomy__
DisableProgramGroupPage=no
; The [Icons] "quicklaunchicon" entry uses {userappdata} but its [Tasks] entry has a proper IsAdminInstallMode Check.
UsedUserAreasWarning=no
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=.\output
OutputBaseFilename=__Decenomy__Setup
SetupIconFile=.\bitcoin.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
DisableStartupPrompt=False
DisableWelcomePage=False
DefaultGroupName=__Decenomy__ Core
WizardSmallImageFile=.\logo-small.bmp
WizardImageFile=.\logo.bmp
InternalCompressLevel=ultra64

[Types]
Name: "compact"; Description: "Compact installation"
Name: "full"; Description: "Full installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: app;  Description: "{#MyAppName} {#MyAppVersion}";  Types: full compact custom; Flags: fixed
Name: bootstrap; Description: "Bootstrap blockchain files";  Types: full; ExtraDiskSpaceRequired: 7368332846;

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode

[Files]
Source: ".\package\__decenomy__-qt.exe"; DestDir: "{app}"; Flags: ignoreversion; Components: app
Source: ".\package\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: app
Source: ".\7za.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall; Components: bootstrap

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[InstallDelete]
Type: filesandordirs; Name: {code:GetDataDir}\blocks; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\chainstate; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\database; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\sporks; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\zerocoin; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\.lock; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\banlist.dat; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\budget.dat; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\fee_estimates.dat; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\mncache.dat; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\mnpayments.dat; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\peers.dat; Components: bootstrap
Type: filesandordirs; Name: {code:GetDataDir}\db.log; Components: bootstrap

[Run]
Filename: "{tmp}\7za.exe"; Parameters: "x ""{tmp}\bootstrap.zip"" -o""{code:GetDataDir}\"" * -r -aoa"; Flags: runhidden runascurrentuser waituntilterminated; Components: bootstrap
Filename: "{app}\{#MyAppExeName}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"

[Registry]
Root: "HKCU"; Subkey: "Software\__Decenomy__\__Decenomy__-Qt"; ValueType: string; ValueName: "strDataDir"; ValueData: "{code:GetDataDir}\"

[Code]
var
  DataDirPage: TInputDirWizardPage;

procedure InitializeWizard;
begin
  // Create the page

  DataDirPage := CreateInputDirPage(wpSelectDir,
    'Select Data Directory', 'Where should data files be installed?',
    'Select the folder in which Setup should install data files, then click Next.',
    False, '');
  DataDirPage.Add('');

  DataDirPage.Values[0] := GetPreviousData('DataDir', '');

  idpAddFileComp('{#MyAppExtraData}', ExpandConstant('{tmp}\bootstrap.zip'),  'bootstrap')
  idpDownloadAfter(wpReady)
 end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  // Store the selected folder for further reinstall/upgrade
  SetPreviousData(PreviousDataKey, 'DataDir', DataDirPage.Values[0]);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  // Set default folder if empty
  if DataDirPage.Values[0] = '' then
     DataDirPage.Values[0] := ExpandConstant('{reg:HKCU\Software\__Decenomy__\__Decenomy__-Qt,strDataDir|{userappdata}\__Decenomy__\}');
  Result := True;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
begin
  
  Result := ''

  if MemoUserInfoInfo <> '' then begin
      Result := MemoUserInfoInfo + Newline + NewLine;
  end;
  if MemoDirInfo <> '' then begin
      Result := Result + MemoDirInfo + Newline + NewLine;
  end;
  if MemoTypeInfo <> '' then begin
      Result := Result + MemoTypeInfo + Newline + NewLine;
  end;
  if MemoComponentsInfo <> '' then begin
      Result := Result + MemoComponentsInfo + Newline + NewLine;
  end;
  if MemoGroupInfo <> '' then begin
      Result := Result + MemoGroupInfo + Newline + NewLine;
  end;
  if MemoTasksInfo <> '' then begin
      Result := Result + MemoTasksInfo + Newline + NewLine;
  end;
 
  // Fill the 'Ready Memo' with the normal settings and the custom settings
  Result := Result + 'Data directory path:' + NewLine;
  Result := Result + Space + DataDirPage.Values[0] + NewLine;
end;

function GetDataDir(Param: String): String;
begin
  { Return the selected DataDir }
  Result := DataDirPage.Values[0];
end;

