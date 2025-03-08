# Starfield Creation Kit Version Control Support – WIP

## Current Status:
CK loads without error, version control menus are enabled, but cannot open plugins (starfield.esm version conflict, delocalization warnings, failed attempt to "lock" starfield.esm via REST service.)

## Summary

Reverse and inverse-engineered after following the Skyrim Version Control guide here: https://ck.uesp.net/w/index.php?title=Version_control&mobileaction=toggle_view_desktop

A ton of time spent staring blankly at `CreationKit.exe` in https://github.com/NationalSecurityAgency/ghidra and https://mh-nexus.de/en/hxd/.


Throwing Noodles at the wall to get Starfield Creation Kit's Perforce Version Control integration working.
Starfield's CK no longer supports network fileshare based versioning, however much of the plumbing is still there. This complicates the process of determining which settings / internal code blocks are effectively dead. Many Crimson Herrings.

On startup of the release build of CK, `EditorWarnings.txt` will contain the following lines:
```
EDITOR: Network request failed. Url=https://assetmgr.bgs.local/config/Genesis Reason=(3) Host assetmgr.bgs.local not found
EDITOR: Query operation failed. Name=Opening Database, Reason= QMYSQL: Unable to connect
```

These two calls are but the tip of the iceberg that is the Asset Manager Service, the ID Service and the AssetMetaDB.

## Version Control INI Settings

| Section   | Name         | Default | Notes                          |
|-----------|-------------|---------|--------------------------------|
| [General] | bUseVersionControl  | 0    | Main switch for VCS |
| [General] | bUsePerforceFormVersioning  | ?    | Must set to 1 to enable Perforce |
| [General] | bUseNetworkFormVersioning  | 1    | Must be set to 0, or else CK pukes |
| [General] | sIdServer  | https://assetmgr.bgs.local | ID Service REST Endpoint (TODO: link to section) See Err #1 |
| [General] | sAssetMetaServiceHostName  | https://assetmgr.bgs.local    | Asset Metadata REST Endpoint - called for config/Genesis service (CK Crashes on 200 response) |
| [General] | sAssetMetaHostName  | localhost    | AssetMetaDB MySQL Hostname |
| [General] | sAssetMetaDatabaseName  | unconnected    | AssetMetaDB MySQL Database Name |
| [General] | iAssetMetaDatabasePort  | 3306    | AssetMetaDB MySQL Port |
| [General] | sAssetMetaUsername  | ODBC    | AssetMetaDB MySQL Username |
| [General] | sAssetMetaPassword  |     | AssetMetaDB MySQL Password |
| [General] | sAssetMetaProject  | true    | Must be supplied to use DB - Added to sAssetMetaServiceHostName config call, see err #2 |
| [General] | sAssetMetaConfig  | true    | Added to sAssetMetaServiceHostName config call |
| [General] | bVerbosePerforceLogging  | 0    | Log more Perforce activity |
| [General] | sPerforceRelativeDataPath  |     | (Data\ ? Build\PC\Data\?) |
| [General] | sPerforceRelativeSourcePath  | Build/Source/    | (Might be for Papyrus source? TODO: test if needs scripts folder) |
| [General] | sLocalBackupPath  | Data\CheckInBackup    |  |
| [General] | sNetwork Path  |     | Required for versioning without perforce (\\localhost\Merging\ in Skyrim Tutorial) |
| [General] | sNewVersionBackupPath  |     | (\\localhost\Merging\VersionBackup\ in Skyrim Tutorial) |
| [General] | sNetworkMasterPath  |     | (\\localhost\Merging\Data\ in Skyrim Tutorial) |
| [General] | SLocalSavePath  | Saves\    | (From Skyrim Tutorial) |
| [General] | SLocalMasterPath  |     | (Data\ in Skyrim Tutorial) |
| [General] | bIgnoreVCFormVersionDifference  |     | TODO: TEST THIS -- may help with Starfied.esm checkout issues |
| [Flowchart] | sPerforceFolder  | //Fallout4Data/current/Source/DialogueViews/    | TODO: Determine correct value |
| [MMS] | sUserSource       | mms       | mms is the Masterfile Management System; 'network' doesn't seem to work anymore; Requires confirmation |
| [MMS] | sESMUpdaterExe       | Tools/ESMUpdater/ESMUpdater       | **PROBABLE SHOWSTOPPER**: This tool is missing. TODO: Followup with BGS |
| [MMS] | sSubmitGuardName       | SubmitGuardProdGenesisData       |  |
| [MMS] | sSubmitGuardMessageLabel       |        |  |
| [MMS] | uForceESMUpdaterChangelist       |        |  |
| [Papyrus]   | sScriptSourceFolder | /Source/Scripts/     | IMPORTANT: Change to "Data/Scripts/Source" if not already |
| [Papyrus]   | bPerforceEnabled | ?     | Set to 1 to enable Versioning for Papyrus Scripts (may be required for perforce in general) |
| [Perforce]   | sServerAndPort | ?     | Server and port of the Helix Core Perforce server. Rec: localhost:1666 |
| [Perforce]   | sPapyrusRelativePath | Build/Source/Scripts/     |  |
| [Perforce]   | sDataRelativePath | Build/PC/Data/     |  |
| [Perforce]   | sSourceTextureRelativePath | Build/Source/TGATextures/     |  |
| [Perforce]   | sMaterialIconRelativePath | Build/PC/Data/EditorFiles/GeneratedIcons/Materials/....png     |  |
| [Perforce]   | sLayeredMaterialRelativePath | Build/PC/Data/Materials/     |  |
| [Perforce]   | sTerrainRelativePath | Build/PC/Data/Terrain/     |  |
| [Perforce]   | sTerrainTextureRelativePath | Build/Source/TGATextures/Terrain/OverlayMasks/     |  |
| [Perforce]   | sObjectPalettesRelativePath | Build/pc/OPAL/     |  |
| [Perforce]   | sSceneAnimationsRelativePath | Build/PC/Data/Meshes/Actors/Human/Animations/Scenes/     |  |
| [Perforce]   | sNoLIPGenPerforceFolder | \\GenesisData\Current\Source\Sound\Voice\English\2NoLIPGen     |  |
| [Perforce]   | sAFFilesPerforceFolder | \\GenesisData\Current\Build\PC\Data\Meshes\Actors\Human\Animations\Scenes     |  |
| [Perforce]   | sAFFilesLocalFolder | Data\Meshes\Actors\Human\Animations\Scenes     |  |
| [Perforce]   | sParticlesRelativePath | Build/PC/Data/Particles/     |  |
| [Perforce]   | sBundlesRelativePath | Build/PC/Data/EditorFiles/Bundles/     |  |
| [Perforce]   | sBundlesRuleTemplatesRelativePath | Build/PC/Data/EditorFiles/RuleTemplates/Bundles/     |  |
| [Perforce]   | sParticlesLODPresetsRelativePath | Build/PC/Data/EditorFiles/Particles/     |  |
| [Perforce]   | sVoiceFilesPerforceFolder | Build/PC/Source/Sound/Voice/     |  |
| [Perforce]   | bEnablePerforceForDataFiles | ?     | (TODO) |
| [Perforce]   | sWorkspace | Papyrus     | Rec: "Starfield" |
| [Perforce]   | sUsername |      | Should set this to match the created Perforce user |
| [SpellCheck]   | sUserLexiconPerforcePath | //genesisdata/current/overrides/DeployOverrides/PC/lex/User/internal.tlx     | This file may be required for CK to launch with VCS enabled |
| [Perforce]   | sParticlesRelativePath | ?     | (TODO) |
| [Perforce]   | sParticlesRelativePath | ?     | (TODO) |


## Preliminary example INI settings

CreationKitCustom.ini
```

[General]
bUseVersionControl=1
sIdServer=http://127.0.0.1:15243
bUsePerforceFormVersioning=1
bUseNetworkFormVersioning=0
bVerbosePerforceLogging=1
sPerforceRelativeDataPath=Data\
sPerforceRelativeSourcePath=Source\
sLocalMasterPath=Data\
# No default
# sPerforceVersionBackupPath=TODO

# From Skyrim Guide -- based on netwrok share, may not be required?


# SNetwork Path=\\localhost\Merging\
# SNewVersionBackupPath=\\localhost\Merging\VersionBackup\
# SNetworkMasterPath=\\localhost\Merging\Data\


# AssetMetaDB config
sAssetMetaHostName=localhost
sAssetMetaDatabaseName=AssetMetaDB
iAssetMetaDatabasePort=3306
sAssetMetaUsername=ckuser
sAssetMetaPassword=ckpassword
sAssetMetaProject=ONEK
sAssetMetaConfig=default

[Flowchart]
# Default is FO4...
sPerforceFolder=\\GenesisData\Current\Source\DialogueViews

[Papyrus]
sScriptSourceFolder="Data/Scripts/Source"
bPerforceEnabled=1

[Perforce]
sServerAndPort=localhost:1666
sWorkspace=Starfield
sUsername=ckuser

[SpellCheck]
# Just copy userDic.tlx to internal.tlx and remove all the words -- leave the header
# Default is //genesisdata/current/overrides/DeployOverrides/PC/lex/User/internal.tlx - could create it there as well
sUserLexiconPerforcePath=\\GenesisData\Current\Build\PC\lex\User\internal.tlx

# Perforce Notes:
# create folder Data\CheckInBackup for SLocalBackupPath
# Create folder Data\DialogueViews for sPerforceFolder:Flowchart
# create folder Data\Forms\g

```

## Perforce depot(s) and required / default workspace layout

PRELIMINARY:
* create Build, Data, Source, GenesisData depos in P4Admin
  - \\GenesisData\Current\Build\PC roughly maps to Starfield Exe root
  - To add files to a Perforce Workspace, they must be present within that workspace
  - depots are represented as (and required for) folders within a workspace root
  - Not sure if mappings are correct AT ALL
* Create Starfield Workspace in P4V, point the workspace to the starfield exe root (not the data folder)
  WARNING: Not sure this is the correct / best / even working approach
* TODO
* create folder Data\CheckInBackup for SLocalBackupPath
* Create folder for DialogueViews in sPerforceFolder:Flowchart sPerforceFolder
* create folder Data\Forms\g (TODO: harcoded or based on other param?)

TODO: Folder structure

## AssetMetaDB MySQL database

On startup CK attempts to connect to a MySQL database on localhost, and fails. The default values are basically meaningless -- all params should be supplied. The purpose of the database remains a mystery, but CreationKit.exe contains enough SQL statements to infer a preliminary schema that -- at the very least allows CK to startup without errors.

There is a string referencing the path "/Data/EditorFiles/AssetMetaDB/" within CreationKit.exe, and an empty folder of the same same under Data.

```
USE AssetMetaDB;

-- Table: Asset
CREATE TABLE IF NOT EXISTS Asset (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  FullPath VARCHAR(1024) NOT NULL,
  UNIQUE KEY (FullPath)
);

-- Table: Tag
CREATE TABLE IF NOT EXISTS Tag (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  UNIQUE KEY (Name)
);

-- Table: User
CREATE TABLE IF NOT EXISTS User (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  UNIQUE KEY (Name)
);

-- Table: AssetTagLink
CREATE TABLE IF NOT EXISTS AssetTagLink (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  AssetId INT NOT NULL,
  TagId INT NOT NULL,
  Operation VARCHAR(255),
  UserId INT NOT NULL,
  UpdateDate DATETIME,
  -- Potential foreign keys
  FOREIGN KEY (AssetId) REFERENCES Asset(Id),
  FOREIGN KEY (TagId) REFERENCES Tag(Id),
  FOREIGN KEY (UserId) REFERENCES User(Id)
);

-- Table: AssetGroup
CREATE TABLE IF NOT EXISTS AssetGroup (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  UserId INT NOT NULL,
  Name VARCHAR(255) NOT NULL,
  FOREIGN KEY (UserId) REFERENCES User(Id)
);

-- Table: AssetGroupLink
CREATE TABLE IF NOT EXISTS AssetGroupLink (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  GroupId INT NOT NULL,
  Operation VARCHAR(255),
  UpdateDate DATETIME,
  FOREIGN KEY (GroupId) REFERENCES AssetGroup(Id)
);

-- Table: AssetPinLink
CREATE TABLE IF NOT EXISTS AssetPinLink (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  GroupId INT NOT NULL,
  AssetId INT NOT NULL,
  Operation VARCHAR(255),
  UpdateDate DATETIME,
  FOREIGN KEY (GroupId) REFERENCES AssetGroup(Id),
  FOREIGN KEY (AssetId) REFERENCES Asset(Id)
);
```



### Notable Error messages within CreationKit.exe

1. "Perforce form versioning is enabled but no ID server is selected. Select a valid server in the sIdServer INI setting"
2. "AssetMetaDB cannot resolve without a project name. Set [General] sAssetMetaProject to a non empty string in CreationKitCustom.ini"


## TODO
* Move examples into files
* Add Python local REST service
