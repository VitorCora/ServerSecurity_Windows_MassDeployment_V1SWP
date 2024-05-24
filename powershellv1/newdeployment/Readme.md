# Migration Script

This script was created to handle Apex One, OfficeScan and Deep Security migrations to Vision One Server & Workload Protection on Windows servers.

## Prerequisites and Important Information

  - Instances and/or Servers running Windows Server 2008 R2, 2012, 2016, 2019 and 2022+
  - Host the Vision One Basecamp agent **(Server & Workload Protection)**
  - **[Important]** Do not acquire the Vision One Standard Endpoint Protection, this Basecamp agent installer will deploy Trend Miro Endpoint protection (previously named Apex One) and not Trend Micro Server protection (previously named Workload Security)
  - This script will not work on Linux machines running Powershell, as the commands used on it favor Windows folder structure and architecture, for the linux project look for:
    - https://github.com/VitorCora/ServerSecurity_Linux_MassDeployment_V1SWP  
  - This script was created using tools that can run on Powershell version 1 only
  - Due to being created based on Powershell version 1 it should run in any Windows Server runnning Powershell as they are retrocompatible
  - Vision One Server & Workload Protection is compatible with Windows Server 2003, but Endpoint sensor and Basecamp are not, so avoid running this script on it
  - You will need to download and host the ApexOne SCUT tool and/or the Deep Security CUT tool and pass them as parameters when you run the Powershell script
  - This script will not move your actual policy from Deep Security/Workload Security

## Migration Script logic

  - Script will look for the **Mandatory** input (URL hosting the Trend Micro Basecamp Agent for Windows Server)
    - If **NOT** Present - Script will Inform the operator and **EXIT** the migration
    - If Present - Script will Inform the operator and continue the migration process
      
  - Script will look for the **Optional** input (URL hosting the Apex One/OfficeScan SCUT tool and URL hosting the Deep Security/Workload Security CUT tool)
    - If **NOT** Present - Script will Inform Operator that the force uninstall will not be attempted
  
  - Script verify if Powershell is running in Privileged Mode
    - If **NOT** - Script will Inform the operator and **EXIT** the migration
    - If so - Script will Inform the operator and continue the migration process
    
  - Script will create a Logfile on the following path c:\%ProgramData%\Trend Micro\V1MigrationTool
    - File will be named:   v1migrationtool_$timestamp.txt
    
  - Check if Apex One process is running on the host
    - If **NOT** - Script will Inform the operator and continue the migration process
    - If Present - Script will Inform the operator and try to uninstall Apex One
      - If Apex One is **NOT** Password Protected it will be removed and script will continue the migration process
      - If Apex One is Password Protected it will be try to used the SCUT tool if provided
        - If **NOT** provided - Script will continue the migration process, but Trend Micro Basecamp will not be installed  
        - If So - Script will download and run the SCUT tool to remove Apex One - After removal Script will inform the operator and continue the migration process

  - Check if OfficeScan process is running on the host
    - If **NOT** - Script will Inform the operator and continue the migration process
    - If Present - Script will Inform the operator and try to uninstall OfficeScan
      - If Apex One is **NOT** Password Protected it will be removed and script will continue the migration process
      - If Apex One is Password Protected it will be try to used the SCUT tool if provided
        - If **NOT** provided - Script will continue the migration process, but Trend Micro Basecamp will not be installed  
        - If So - Script will download and run the SCUT tool to remove Apex One - After removal Script will inform the operator and continue the migration process

    - Check if Deep Security or Workload Security processes are running on the host
    - If **NOT** - Script will Inform the operator and continue the migration process
    - If Present - Script will Inform the operator and try to uninstall Deep Security or Workload Security
      - If Apex One is **NOT** Password Protected it will be removed and script will continue the migration process
      - If Apex One is Password Protected it will be try to used the CUT tool if provided **This process is not yet fully developed as Powershell version 1 doesn`t have a viable way to run extract protected ZIP file**
        - If **NOT** provided - Script will continue the migration process, but Trend Micro Basecamp will not be installed  
        - If So - Script will download and run the SCUT tool to remove Apex One - After removal Script will inform the operator and continue the migration process
  
  - Check if Apex One or OfficeScan or Deep Security or Workload Security processes are running on the host
    - If **NOT** - Script will Inform the operator, download the Agent and run it
    - If still Present - Script will Inform the operator and Exit the migration process

## Migration Logical Diagram

![Whiteboard](https://github.com/VitorCora/ServerSecurity_Windows_MassDeployment_V1SWP/assets/59590152/0261c3b2-84e1-4a5f-8b6e-14869153e1cc)


## How to run the script

To run the script you will need to download the script and run it with the following parameters:

### Command

```
.\migration.ps1 -urlagent "URL_for_agent" -urlscuta1 "URL_for_SCUT_A1" -urlscutws "URL_for_SCUT_WS"
```
  - Example

```
.\migrate_V1SWP_Win.ps1 -urlagent "https://packagedist.s3.amazonaws.com/TMServerAgent_Windows.zip" -urlscuta1 "https://packagedist.s3.amazonaws.com/SCUT_A1.zip" -urlscutws "https://packagedist.s3.amazonaws.com/SCUT_WS.zip"
```

### Parameters

  - **[Mandatory]** migration.ps1 is the name of the Powershell script
  - **[Mandatory]** -urlagent "URL_for_agent" is the hosting URL for Vision One Basecamp Agent for Windows Server
  - **[Optional]** -urlscuta1 "URL_for_SCUT_A1" is the hosting URL for the Apex One/OfficeScan Secure Common Uninstall Tool (SCUT)
    - It is used to fore remove password protected Apex One/OfficeScan deployments
  - **[Optional]** -urlscutws "URL_for_SCUT_WS" is the hosting URL for the Deep Security/Workload Security Common Uninstall Tool (CUT)
    - It is used to fore remove password protected Deep Security/Workload Security deployments
















