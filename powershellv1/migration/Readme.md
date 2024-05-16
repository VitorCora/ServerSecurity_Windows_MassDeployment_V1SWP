# Migration Script

This script was created to handle Apex One, OfficeScan and Deep Security migrations to Vision One Server & Workload Protection on Windows servers.

## Prerequisites and Important Information

  - Instances and/or Servers running Windows Server 2008 R2, 2012, 2016, 2019 and 2022+
  - This script will not work on Linux machines running Powershell, as the commands used on it favor Windows folder structure and architecture, for the linux project look for:
    - https://github.com/VitorCora/ServerSecurity_Linux_MassDeployment_V1SWP  
  - This script was created using tools that can run on Powershell version 1 only
  - Due to being created based on Powershell version 1 it should run in any Windows Server runnning Powershell as they are retrocompatible
  - Vision One Server & Workload Protection is compatible with Windows Server 2003, but Endpoint sensor and Basecamp are not, so avoid running this script on it
  - You will need to download and host the ApexOne SCUT tool and/or the Deep Security CUT tool and pass them as parameters when you run the Powershell script

## How to run the script

To run the script you will need to download the script and run it with the following parameters:

```
.\migration.ps1 -urlscutws "URL_for_SCUT_WS" -urlscuta1 "URL_for_SCUT_A1" -urlagent "URL_for_agent" -token "your_token" -tenantid "your_tenant_id"
```
