# ServerSecurity_Windows_MassDeployment_V1SWP

Thanks for the visit!

## Overview

This Project is a comprehensive tool designed to facilitate the deployment of Trend Micro End Point Protection (Basecamp) that comprehends Trend Vision One Server & Workload Protection for advanced endpoint protection and Trend Endpoint Sensor to ensure advanced telemetry and Detection and Response capabilities across multiple Windows servers. 
This tool streamlines the process of  deploying from scratch (New Deployment) and migration from previous Trend Micro security services like Trend Micro Apex One or Trend Micro OfficeScan for Servers, removing previous softwares, installing essential packages and ensuring that all your Windows servers adhere to your organization's security standards.

## Features

  - Bulk Deployment: Deploy security agents to multiple servers simultaneously.
  - Configuration: Use the pre-defined or customize the script for consistent security settings.
  - Security Policies: Implement and enforce Trend Vision One Endpoint Protection security policies across all servers.
  - Logging and Reporting: Detailed logs and reports of deployment status and results.
  - Scalability: Designed to handle large-scale deployments efficiently.

## Requirements

  - Windows Server 2008 R2 or later
  - PowerShell 1.0 or later
  - Administrative privileges on target servers
  - Network access to target servers

# Guidance

This Repo was created to encompass the vast majority of Windows Servers, so in order to attain this, it was built using PowerShell version 1. 

To set up your environment please follow the steps described on the following link:

https://github.com/VitorCora/ServerSecurity_Windows_MassDeployment_V1SWP/tree/main/powershellv1

The **New deployment Script** will be on the following prefix:

https://github.com/VitorCora/ServerSecurity_Windows_MassDeployment_V1SWP/tree/main/powershellv1/newdeployment

Direct link to the Script:
https://github.com/VitorCora/ServerSecurity_Windows_MassDeployment_V1SWP/blob/main/powershellv1/newdeployment/newdeployment_V1SWP_Win.ps1

**[Important]** Please follow the instruction on the Readme.
  

The **Migration Script** will be on the following prefix:

https://github.com/VitorCora/ServerSecurity_Windows_MassDeployment_V1SWP/tree/main/powershellv1/migration

Direct link to the Script:
https://github.com/VitorCora/ServerSecurity_Windows_MassDeployment_V1SWP/blob/main/powershellv1/migration/migrate_V1SWP_Win.ps1

**[Important]** Please follow the instruction on the Readme.

The PowerShell version 4 is going to be following, so stay tuned!
