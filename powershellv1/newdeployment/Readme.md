# New Deployment Script

This script was created to handle the installation of Vision One Server & Workload Protection on Windows servers.

## Prerequisites and Important Information

  - Instances and/or Servers running Windows Server 2008 R2, 2012, 2016, 2019 and 2022+
  - Host the Vision One Basecamp agent **(Server & Workload Protection)**
  - **[Important]** Do not acquire the Vision One Standard Endpoint Protection, if so this script will deploy Trend Micro Endpoint protection (previously named Apex One) and not Trend Micro Server protection (previously named Workload Security)
  - This script will not work on Linux machines running Powershell, as the commands used on it favor Windows folder structure and architecture, for the linux project look for:
    - https://github.com/VitorCora/ServerSecurity_Linux_MassDeployment_V1SWP  
  - This script was created using tools that can run on Powershell version 1 only
  - Due to being created based on Powershell version 1 it should run in any Windows Server runnning Powershell as they are retrocompatible
  - **[Important]** Vision One Server & Workload Protection is compatible with Windows Server 2003, but Endpoint sensor and Basecamp are not, so avoid running this script on it
  - **[Important]** Please verify with your Trend Micro representative about compatibility as this it may change in accordance to Trend Micro's will
  - This script will not migrate any of the older Trend Micro products to Vision One Server & Workload Protection

## Migration Script logic

  - Script will look for the **Mandatory** input (URL hosting the Trend Micro Basecamp Agent for Windows Server)
    - If **NOT** Present - Script will Inform the operator and **EXIT** the migration
    - If Present - Script will Inform the operator and continue the migration process    
  
  - Script verify if Powershell is running in Privileged Mode
    - If **NOT** - Script will Inform the operator and **EXIT** the migration
    - If so - Script will Inform the operator and continue the migration process
    
  - Script will create a Logfile on the following path c:\%ProgramData%\Trend Micro\V1IOnstallationTool
    - File will be named:   v1migrationtool_$timestamp.txt
    
  - Check if Apex One process is running on the host
    - If **NOT** - Script will Inform the operator and continue the miginstallation process
    - If Present - Script will Inform the operator and exit the installation process

  - Check if OfficeScan process is running on the host
    - If **NOT** - Script will Inform the operator and continue the miginstallation process
    - If Present - Script will Inform the operator and exit the installation process

    - Check if Deep Security or Workload Security processes are running on the host
    - If **NOT** - Script will Inform the operator and continue the miginstallation process
    - If Present - Script will Inform the operator and exit the installation process
  
  - Check if Apex One or OfficeScan or Deep Security or Workload Security processes are running on the host
    - If **NOT** - Script will Inform the operator, download the Basecamp Agent and run it
    - If still Present - Script will Inform the operator and Exit the minstallation process

## Migration Logical Diagram

![Whiteboard](https://github.com/VitorCora/ServerSecurity_Windows_MassDeployment_V1SWP/assets/59590152/0261c3b2-84e1-4a5f-8b6e-14869153e1cc)


## How to run the script

To run the script you will need to download the script and run it with the following parameters:

### Command

```
.\migration.ps1 -urlagent "URL_for_agent"
```
  - Example

```
.\migrate_V1SWP_Win.ps1 -urlagent "https://packagedist.s3.amazonaws.com/TMServerAgent_Windows.zip"

```

### Parameters

  - **[Mandatory]** migration.ps1 is the name of the Powershell script
  - **[Mandatory]** -urlagent "URL_for_agent" is the hosting URL for Vision One Basecamp Agent for Windows Server
















