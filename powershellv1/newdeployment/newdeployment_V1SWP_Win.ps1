# V1S-WP_Migration_Project

# Parameters

param (
    [string]$urlagent,
    [string]$token,
    [string]$tenantid
)

if ($urlagent -eq $null) {
    Write-Host "Please provide the url for the download of the Basecamp Agent."; 
    Write-Host "Exiting the migration process."; 
    exit 
} else {
    Write-Host "URL for Trend Micro Basecamp found, proceeding to the next test."
}

if ($token -eq $null -or $tenantid -eq $null) {
    Write-Host "Trend Micro Vision One token or tenantid have not been provided, proceeding with the migration."; 
} else {
    Write-Host "Trend Micro Vision One tenant and token have been provided, proceeding to the next test."
}


## This code needs to be ran as Administrator, I will include a fail safe to break the code in the case of it starting with less privileges 

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Write-Host "Please run this script as an Administrator."; 
    Write-Host "Exiting the Script Now, try again later as Administrator"
    exit 
} else {
    Write-Host "Running Script as Administrator."
}

# Define variables

# Define the path where the program will be downloaded
$downloadPathAgent = "$env:TEMP\TMStandardAgent_Windows.zip"

$downloadPathSCUTA1 = "$env:TEMP\SCUTA1.zip"

$downloadPathSCUTWS = "$env:TEMP\SCUTWS.zip"

# Error variable
$e=0

# Force PowerShell to use TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Create Folder to save logs from the Migration tool

# Specify the folder path
$folderPath = "C:\ProgramData\Trend Micro\V1MigrationTool"

# Check if the folder already exists
if (-not (Test-Path $folderPath)) {
    # If the folder doesn't exist, create it
    [System.IO.Directory]::CreateDirectory($folderPath)
    Write-Host "Folder created successfully at $folderPath"
} else {
    Write-Host "Folder already exists at $folderPath"
}

#Log File

# Create the log file

# Specify the file path
$logfileName = "v1migrationtool"
$timestamp = Get-Date -Format "yyMMdd_HHmmss"

# Construct the full file path
$logfile = Join-Path -Path $folderPath -ChildPath ($logfileName + "_" + $timestamp +".txt")

# Create a StreamWriter object to write to the file
$streamWriter = New-Object System.IO.StreamWriter($logfile)

#Acquire timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Write content to the file
$streamWriter.WriteLine("INFO: $timestamp message:Log file create successfully.")

#Acquire timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Append text to the file
$streamWriter.WriteLine("INFO: $timestamp message:Migration process started at $timestamp.")

# Close the StreamWriter object to release resources
$streamWriter.Close()

# Verify if the file has been created
if (Test-Path $logfile) {
    Write-Host "Log File created successfully at $logfile"
} else {
    Write-Host "Failed to create the log file."
}

# Define Sub functions

function AppendToLogFile {
    	param(
        	[string]$logfile,
        	[string]$message,
        	[string]$type
    	)
	# Get the current timestamp
	$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

	# Construct the log entry
	 $logentry = "{0}: {1} message: {2}" -f $type, $timestamp, $message

	$retryCount = 0

	while ($retryCount -lt 10) {
		try {
			# Append the log entry to the log file
	            	Add-Content -Path $logfile -Value $logentry -ErrorAction Stop
	            	Write-Host "Log entry appended successfully to $logfile"
	            	return  # Exit the function if successful
	        	}
	        catch {
	        	$retryCount++
	            	Write-Host "Attempt $retryCount : Failed to append log entry to $logfile. Error: $_"
	            	Start-Sleep -Seconds 5  # Wait for 5 seconds before retrying
	        }
	}
	
	# If execution reaches this point, it means all retries failed
	Write-Host "Exceeded maximum retry attempts. Failed to append log entry to $logfile."
}

# Check if Trend Micro Deep Security service is installed
function Check-DeepSecurityInstalled {
    try {
        $deepSecurity = Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Name -like "*Trend Micro Deep Security Agent*" }
        if ($deepSecurity -ne $null) {
            $message = "Info: Trend Micro Deep Security is installed."
            $type = "INFO"
        } else {
            $message = "Error: Trend Micro Deep Security is not installed."
            $type = "ERROR"
        }
    }
    catch {
        $message = "Error: An error occurred while checking Deep Security installation - $_"
        $type = "ERROR"
    }

    Write-Output $message
    # Assuming AppendToLogFile is defined elsewhere in your script
    AppendToLogFile -logfile $logfile -Message $message -Type $type

    if ($type -eq "INFO") {
        return $true
    } else {
        return $false
    }
}

# Main program

# Start Check if Apex One is installed

# Search for Trend Micro Apex One Security Agent
$apexOne = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Trend Micro Apex One Security Agent*" }

$message = "Looking for Trend Micro Apex One Security Agent."
$type = "INFO"
Write-Host $message
AppendToLogFile -logfile $logfile -Message $message -Type $type

if ($apexOne -ne $null) {
	$message = "Trend Micro Apex one Agent found."
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
  $message = "Please utilize the Migration script and it`s specific requirements."
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
 	$message = "Exiting the Vision One Basecamp installation process."
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
  exit
} else {
	$message = "Trend Micro Apex One Security Agent is not installed."
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
}
   
# End Check if Apex One is installed

# Start Check if OfficeScan is installed

$officeScan = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Trend Micro OfficeScan Agent*" }
$message = "Looking for Trend Micro OfficeScan Agent."
$type = "INFO"
Write-Host $message
AppendToLogFile -logfile $logfile -Message $message -Type $type

if ($officeScan -ne $null) {
	$message = "Trend Micro OfficeScan Agent found."
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
  $message = "Please utilize the Migration script and it`s specific requirements."
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
 	$message = "Exiting the Vision One Basecamp installation process."
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
} else {
	$message = "Trend Micro OfficeScan Agent is not installed."
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
}
   
# End Check if OfficeScan is installed

# Start Check if Workload Security is installed

# Search for Trend Micro Deep Security Agent
$deepSecurity = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Trend Micro Deep Security Agent*" }
$message = "Looking for Trend Micro Deep Security Agent."
$type = "INFO"
Write-Host $message
AppendToLogFile -logfile $logfile -Message $message -Type $type

if ($deepSecurity -ne $null) {
	$message = "Trend Micro Deep Security/Workload Security Agent found."
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
  $message = "Please utilize the Migration script and it`s specific requirements."
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
 	$message = "Exiting the Vision One Basecamp installation process."
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
} else {
	$message = "Trend Micro Deep Security/Workload Security Agent is not installed."
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
}
# End Check if Workload Security is installed


$message = "Finished looking for older versions installed on the host."
$type = "INFO"
Write-Host $message
AppendToLogFile -logfile $logfile -Message $message -Type $type

# Logic to Install Basecamp agent

if ($deepSecurity -eq $null -and $apexOne -eq $null -and $officeScan -eq $null) {
	$message = "Starting Installation process of the Trend Micro Basecamp Agent"
	$type = "INFO"
	Write-Host $message
	AppendToLogFile -logfile $logfile -Message $message -Type $type
 	# Create a WebClient object
	$webClient = New-Object System.Net.WebClient
	    
	# Download the program using the DownloadFile method (compatible with PowerShell v1)
	$webClient.DownloadFile($urlagent, $downloadPathAgent)
	    
	# Check if the file was downloaded successfully
	if (Test-Path $downloadPathAgent) {
	  	$message = "Trend Micro Basecamp Agent downloaded successfully."
		$type = "INFO"
		Write-Host $message
		AppendToLogFile -logfile $logfile -Message $message -Type $type
	 	$message = "Running the Trend Micro Basecamp Agent..."
		$type = "INFO"
		Write-Host $message
		AppendToLogFile -logfile $logfile -Message $message -Type $type
    
	        # Extract the downloaded file using Shell.Application (compatible with PowerShell v1)
	        $shell = New-Object -ComObject Shell.Application
        
	        # Define the destination folder path
	        $destinationFolderPath = "$env:TEMP\TMServerAgent"
        
	        # Create the destination folder if it doesn't exist
	        if (-not (Test-Path $destinationFolderPath)) {
	            New-Item -ItemType Directory -Path $destinationFolderPath | Out-Null
	        }
        
	        # Get the zip folder and destination folder objects
	        $zipFolder = $shell.NameSpace($downloadPathAgent)
	        $destinationFolder = $shell.NameSpace($destinationFolderPath)
        
	        # Check if the destination folder object is not null
	        if ($destinationFolder -ne $null) {
	        	# Copy the items from the zip folder to the destination folder
	        	$destinationFolder.CopyHere($zipFolder.Items(), 16)
    
		        # Replace 'EndpointBasecamp.exe' with the actual name of the executable you want to run from the extracted files
		        $programPath = "$env:TEMP\TMServerAgent\EndpointBasecamp.exe"
		            
		        # Check if the program exists in the destination folder
		        if (Test-Path $programPath) {
		  		$message = "Running the program located at: $programPath"
			    	$type = "INFO"
			    	Write-Host $message
			    	AppendToLogFile -logfile $logfile -Message $message -Type $type
		                $process = Start-Process -FilePath $programPath -Wait
		  		$deepSecurity = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Trend Micro Deep Security Agent*" }
      				$message = "Trend Micro Basecamp Agent installed successfully"
			    	$type = "INFO"
			    	Write-Host $message
			    	AppendToLogFile -logfile $logfile -Message $message -Type $type
		        } else {
		  	      	$message = "Error: Program not found at $programPath"
			    	$type = "ERROR"
			    	Write-Host $message
			    	AppendToLogFile -logfile $logfile -Message $message -Type $type
            		}
        	} else {
	      	  	$message = "Error: Destination folder not accessible."
		    	$type = "ERROR"
		    	Write-Host $message
		    	AppendToLogFile -logfile $logfile -Message $message -Type $type
        	}
	} else {
	  	$message = "Error: Failed to download Trend Micro Basecamp the program from $urlagent"
	    	$type = "ERROR"
	    	Write-Host $message
	    	AppendToLogFile -logfile $logfile -Message $message -Type $type
    	}
} else {
 	$message = "Error: Failed to Install Basecamp because Workload Security or Apex One are installed on the target machine"
    	$type = "ERROR"
    	Write-Host $message
    	AppendToLogFile -logfile $logfile -Message $message -Type $type
}

# Set timeout to 15 minutes
$timeout = (Get-Date).AddMinutes(15)

# Set a numerical variable
$n = 0
$t = 30
$wstime = 30

# Loop until Deep Security is installed or timeout is reached
while ((-not (Check-DeepSecurityInstalled)) -and (Get-Date) -lt $timeout) {
	$n=$n+1
	$wstime = $t*$n
	$message = "Info: Waiting for Trend Micro Deep Security to be installed for $wstime ..."
    	$type = "INFO"
    	Write-Host $message
    	AppendToLogFile -logfile $logfile -Message $message -Type $type
    	Start-Sleep -Seconds 30  # Wait for 30 seconds before checking again
}

if ((Get-Date) -ge $timeout) {
     	$message = "Error: Timed out waiting for Trend Micro Deep Security to be installed."
    	$type = "ERROR"
    	Write-Host $message
    	AppendToLogFile -logfile $logfile -Message $message -Type $type
} else {
    	# Change directory to C:\Program Files\Trend Micro\Deep Security
	Set-Location "C:\Program Files\Trend Micro\Deep Security Agent"

	# Reset the manager
 	$message = "Info: Reseting the manager"
    	$type = "INFO"
    	Write-Host $message
    	AppendToLogFile -logfile $logfile -Message $message -Type $type
    	& .\dsa_control -r
    
    	# Activate to the manager
 	$message = "Info: Activating Vision One Server & Workload Protection"
    	$type = "INFO"
    	Write-Host $message
    	AppendToLogFile -logfile $logfile -Message $message -Type $type
    	& .\dsa_control -a dsm://agents.deepsecurity.trendmicro.com:443/ "tenantID:$tenantid" "token:$token"
}
