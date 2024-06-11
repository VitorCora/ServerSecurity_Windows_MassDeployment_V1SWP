# V1S-WP_Migration_Project

# Parameters
param (
    [string]$urlagent,
    [string]$urlscuta1,
    [string]$urlscutds
)

if (-not $urlagent) {
    Write-Host "Please provide the URL for the download of the Basecamp Agent."
    Write-Host "Exiting the migration process."
    exit
} else {
    Write-Host "URL for Trend Micro Basecamp found, proceeding to the next test."
}

if (-not $urlscuta1) {
    Write-Host "Trend Micro SCUT A1 URL not provided; if Trend Micro ApexOne or OfficeScan is password protected, it will not be uninstalled."
} else {
    Write-Host "Trend Micro SCUT A1 URL found, proceeding to the next test."
}

if (-not $urlscutds) {
    Write-Host "Trend Micro SCUT DS/WS URL not provided; if Trend Micro ApexOne or OfficeScan is password protected, it will not be uninstalled."
} else {
    Write-Host "Trend Micro SCUT A1 URL found, proceeding to the next test."
}

# This code needs to be run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an Administrator."
    Write-Host "Exiting the Script Now, try again later as Administrator"
    exit
} else {
    Write-Host "Running Script as Administrator."
}

# Define variables
$downloadPathAgent = "$env:TEMP\TMStandardAgent_Windows.zip"
$downloadPathSCUTA1 = "$env:TEMP\SCUTA1.zip"
$e = 0

# Force PowerShell to use TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Create Folder to save logs from the Migration tool
$folderPath = "C:\ProgramData\Trend Micro\V1MigrationTool"
if (-not (Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
    Write-Host "Folder created successfully at $folderPath"
} else {
    Write-Host "Folder already exists at $folderPath"
}

# Create the log file
$logfileName = "v1migrationtool"
$timestamp = Get-Date -Format "yyMMdd_HHmmss"
$logfile = Join-Path -Path $folderPath -ChildPath ($logfileName + "_" + $timestamp + ".txt")
Add-Content -Path $logfile -Value "INFO: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') message: Log file created successfully."
Add-Content -Path $logfile -Value "INFO: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') message: Migration process started at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')."

if (Test-Path $logfile) {
    Write-Host "Log File created successfully at $logfile"
} else {
    Write-Host "Failed to create the log file."
}

# Define Sub functions
function AppendToLogFile {
    param (
        [string]$logfile,
        [string]$message,
        [string]$type
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logentry = "$type: $timestamp message: $message"
    $retryCount = 0

    while ($retryCount -lt 10) {
        try {
            Add-Content -Path $logfile -Value $logentry -ErrorAction Stop
            Write-Host "Log entry appended successfully to $logfile"
            return
        } catch {
            $retryCount++
            Write-Host "Attempt $retryCount: Failed to append log entry to $logfile. Error: $_"
            Start-Sleep -Seconds 5
        }
    }
    Write-Host "Exceeded maximum retry attempts. Failed to append log entry to $logfile."
}

# Main program

# Check if Apex One is installed
$apexOne = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Trend Micro Apex One Security Agent*" }

$message = "Looking for Trend Micro Apex One Security Agent."
$type = "INFO"
Write-Host $message
AppendToLogFile -logfile $logfile -Message $message -Type $type

if ($apexOne) {
    $message = "Trend Micro Apex One Agent found."
    $type = "INFO"
    Write-Host $message
    AppendToLogFile -logfile $logfile -Message $message -Type $type

    $uninstallString = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -like "*Trend Micro Apex One Security Agent*" } | Select-Object -ExpandProperty UninstallString
    if ($uninstallString) {
        $message = "Uninstalling Trend Micro Apex One Security Agent using command line..."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type

        Start-Process -FilePath $uninstallString -Wait
        $message = "Verifying if the Trend Micro OfficeScan Agent has been uninstalled correctly."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type

        $apexOne = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Trend Micro Apex One Security Agent*" }
        if (-not $apexOne) {
            $message = "Trend Micro Apex One Security Agent has been uninstalled."
            $type = "INFO"
            Write-Host $message
            AppendToLogFile -logfile $logfile -Message $message -Type $type
        }
    } elseif (-not $urlscuta1) {
        $message = "Trend Micro Apex One SCUT tool link not provided."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type
        $message = "Trend Micro Apex One Security Agent will not be uninstalled."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type
        $message = "Finishing Trend Micro Apex One discovery and uninstallation process."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type
    } else {
        $message = "Failed to find uninstall string for Trend Micro Apex One Security Agent."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type
        $message = "Initiating the uninstallation process of the Apex One, using the SCUT tool A1"
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type

        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($urlscuta1, $downloadPathSCUTA1)
        $message = "Initiating the download of the SCUT tool A1"
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type

        if (Test-Path $downloadPathSCUTA1) {
            $message = "Program SCUT for Apex One downloaded successfully."
            $type = "INFO"
            Write-Host $message
            AppendToLogFile -logfile $logfile -Message $message -Type $type
            $message = "Running the program SCUT for Apex One ..."
            $type = "INFO"
            Write-Host $message
            AppendToLogFile -logfile $logfile -Message $message -Type $type

            $shell = New-Object -ComObject Shell.Application
            $destinationFolderPathSCUTA1 = "$env:TEMP\SCUTA1"

            $message = "Checking if SCUTA1 folder already exists"
            $type = "INFO"
            Write-Host $message
            AppendToLogFile -logfile $logfile -Message $message -Type $type
            if (-not (Test-Path $destinationFolderPathSCUTA1)) {
                New-Item -ItemType Directory -Path $destinationFolderPathSCUTA1 | Out-Null
                $message = "Creating SCUTA1 folder"
                $type = "INFO"
                Write-Host $message
                AppendToLogFile -logfile $logfile -Message $message -Type $type
            } else {
                $message = "Found SCUTA1 folder"
                $type = "INFO"
                Write-Host $message
                AppendToLogFile -logfile $logfile -Message $message -Type $type
            }

            $zipFolder = $shell.NameSpace($downloadPathSCUTA1)
            $destinationFolderSCUTA1 = $shell.NameSpace($destinationFolderPathSCUTA1)
            if ($destinationFolderSCUTA1) {
                $destinationFolderSCUTA1.CopyHere($zipFolder.Items(), 16)
                $programPathSCUTA1 = "$env:TEMP\SCUTA1\A1\SCUT.exe"
                $command = "$programPath

SCUTA1 -p 1 -O"

                $message = "Running SCUT.exe..."
                $type = "INFO"
                Write-Host $message
                AppendToLogFile -logfile $logfile -Message $message -Type $type

                Start-Process -FilePath $command -Wait

                $message = "SCUT.exe completed."
                $type = "INFO"
                Write-Host $message
                AppendToLogFile -logfile $logfile -Message $message -Type $type

                $apexOne = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Trend Micro Apex One Security Agent*" }
                if (-not $apexOne) {
                    $message = "Trend Micro Apex One Security Agent has been uninstalled."
                    $type = "INFO"
                    Write-Host $message
                    AppendToLogFile -logfile $logfile -Message $message -Type $type
                }
            }
        } else {
            $message = "Program SCUT for Apex One was not downloaded. Try to download again."
            $type = "INFO"
            Write-Host $message
            AppendToLogFile -logfile $logfile -Message $message -Type $type
        }
    }
} else {
    $message = "Trend Micro Apex One Security Agent not found."
    $type = "INFO"
    Write-Host $message
    AppendToLogFile -logfile $logfile -Message $message -Type $type
}

# Check if OfficeScan Agent is installed
$officescan = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Trend Micro OfficeScan Agent*" }

$message = "Looking for Trend Micro OfficeScan Agent."
$type = "INFO"
Write-Host $message
AppendToLogFile -logfile $logfile -Message $message -Type $type

if ($officescan) {
    $message = "Trend Micro OfficeScan Agent found."
    $type = "INFO"
    Write-Host $message
    AppendToLogFile -logfile $logfile -Message $message -Type $type

    $uninstallString = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object { $_.DisplayName -like "*Trend Micro OfficeScan Agent*" } | Select-Object -ExpandProperty UninstallString
    if ($uninstallString) {
        $message = "Uninstalling Trend Micro OfficeScan Agent using command line..."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type

        Start-Process -FilePath $uninstallString -Wait
        $message = "Verifying if the Trend Micro OfficeScan Agent has been uninstalled correctly."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type

        $officescan = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Trend Micro OfficeScan Agent*" }
        if (-not $officescan) {
            $message = "Trend Micro OfficeScan Agent has been uninstalled."
            $type = "INFO"
            Write-Host $message
            AppendToLogFile -logfile $logfile -Message $message -Type $type
        }
    } elseif (-not $urlscuta1) {
        $message = "Trend Micro OfficeScan SCUT tool link not provided."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type
        $message = "Trend Micro OfficeScan Agent will not be uninstalled."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type
        $message = "Finishing Trend Micro OfficeScan discovery and uninstallation process."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type
    } else {
        $message = "Failed to find uninstall string for Trend Micro OfficeScan Agent."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type
        $message = "Initiating the uninstallation process of the OfficeScan, using the SCUT tool A1"
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type

        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($urlscuta1, $downloadPathSCUTA1)
        $message = "Initiating the download of the SCUT tool A1"
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type

        if (Test-Path $downloadPathSCUTA1) {
            $message = "Program SCUT for OfficeScan downloaded successfully."
            $type = "INFO"
            Write-Host $message
            AppendToLogFile -logfile $logfile -Message $message -Type $type
            $message = "Running the program SCUT for OfficeScan ..."
            $type = "INFO"
            Write-Host $message
            AppendToLogFile -logfile $logfile -Message $message -Type $type

            $shell = New-Object -ComObject Shell.Application
            $destinationFolderPathSCUTA1 = "$env:TEMP\SCUTA1"

            $message = "Checking if SCUTA1 folder already exists"
            $type = "INFO"
            Write-Host $message
            AppendToLogFile -logfile $logfile -Message $message -Type $type
            if (-not (Test-Path $destinationFolderPathSCUTA1)) {
                New-Item -ItemType Directory -Path $destinationFolderPathSCUTA1 | Out-Null
                $message = "Creating SCUTA1 folder"
                $type = "INFO"
                Write-Host $message
                AppendToLogFile -logfile $logfile -Message $message -Type $type
            } else {
                $message = "Found SCUTA1 folder"
                $type = "INFO"
                Write-Host $message
                AppendToLogFile -logfile $logfile -Message $message -Type $type
            }

            $zipFolder = $shell.NameSpace($downloadPathSCUTA1)
            $destinationFolderSCUTA1 = $shell.NameSpace($destinationFolderPathSCUTA1)
            if ($destinationFolderSCUTA1) {
                $destinationFolderSCUTA1.CopyHere($zipFolder.Items(), 16)
                $programPathSCUTA1 = "$env:TEMP\SCUTA1\A1\SCUT.exe"
                $command = "$programPathSCUTA1 -p 1 -O"

                $message = "Running SCUT.exe..."
                $type = "INFO"
                Write-Host $message
                AppendToLogFile -logfile $logfile -Message $message -Type $type

                Start-Process -FilePath $command -Wait

                $message = "SCUT.exe completed."
                $type = "INFO"
                Write-Host $message
                AppendToLogFile -logfile $logfile -Message $message -Type $type

                $officescan = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Trend Micro OfficeScan Agent*" }
                if (-not $officescan) {
                    $message = "Trend Micro OfficeScan Agent has been uninstalled."
                    $type = "INFO"
                    Write-Host $message
                    AppendToLogFile -logfile $logfile -Message $message -Type $type
                }
            }
        } else {
            $message = "Program SCUT for OfficeScan was not downloaded. Try to download again."
            $type = "INFO"
            Write-Host $message
            AppendToLogFile -logfile $logfile -Message $message -Type $type
        }
    }
} else {
    $message = "Trend Micro OfficeScan Agent not found."
    $type = "INFO"
    Write-Host $message
    AppendToLogFile -logfile $logfile -Message $message -Type $type
}

# Install new Basecamp Agent
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($urlagent, $downloadPathAgent)
$message = "Downloading the new agent."
$type = "INFO"
Write-Host $message
AppendToLogFile -logfile $logfile -Message $message -Type $type

if (Test-Path $downloadPathAgent) {
    $message = "Trend Micro Agent downloaded successfully."
    $type = "INFO"
    Write-Host $message
    AppendToLogFile -logfile $logfile -Message $message -Type $type

    $shell = New-Object -ComObject Shell.Application
    $destinationFolderPathAgent = "$env:TEMP\TMStandardAgent"

    $message = "Checking if TMStandardAgent folder already exists"
    $type = "INFO"
    Write-Host $message
    AppendToLogFile -logfile $logfile -Message $message -Type $type
    if (-not (Test-Path $destinationFolderPath

Agent)) {
        New-Item -ItemType Directory -Path $destinationFolderPathAgent | Out-Null
        $message = "Creating TMStandardAgent folder"
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type
    } else {
        $message = "Found TMStandardAgent folder"
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type
    }

    $zipFolder = $shell.NameSpace($downloadPathAgent)
    $destinationFolderAgent = $shell.NameSpace($destinationFolderPathAgent)
    if ($destinationFolderAgent) {
        $destinationFolderAgent.CopyHere($zipFolder.Items(), 16)
        $programPathAgent = "$env:TEMP\TMStandardAgent\setup.exe"
        $command = "$programPathAgent -s"

        $message = "Running setup.exe..."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type

        Start-Process -FilePath $command -Wait

        $message = "Trend Micro Agent installation completed."
        $type = "INFO"
        Write-Host $message
        AppendToLogFile -logfile $logfile -Message $message -Type $type
    }
} else {
    $message = "Trend Micro Agent was not downloaded. Try to download again."
    $type = "INFO"
    Write-Host $message
    AppendToLogFile -logfile $logfile -Message $message -Type $type
}
