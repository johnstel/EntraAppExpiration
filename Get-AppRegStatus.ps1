# Install and Import Microsoft Graph PowerShell modules if not already installed
#
# Install-Module -Name Microsoft.Graph -Force -AllowClobber
# Install-Module -Name Microsoft.Graph.Beta -Force -AllowClobber
# Import-Module -Name Microsoft.Graph
# Import-Module -Name Microsoft.Graph.Beta

# Variables for file retention
$DaysToKeepCsv = 30 # Number of days to keep CSV reports
$MaxLogFiles = 30   # Maximum number of log files to keep

# Function to write logs to both console and file with timestamp
function Write-Log {
    Param ([string]$Message)

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp $Message"

    # Write to Console
    Write-Host $logMessage

    # Write to Log File
    Add-Content -Path $LogFilePath -Value $logMessage
}

# Setting up the log file directory and name
$LogDir = Split-Path $MyInvocation.MyCommand.Path
$LogFileName = "Log_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".log"
$LogFilePath = Join-Path $LogDir $LogFileName

# Retain only the latest X log files
$ExistingLogs = Get-ChildItem $LogDir -Filter "Log_*.log" | Sort-Object LastWriteTime -Descending
foreach ($file in $ExistingLogs | Select-Object -Skip $MaxLogFiles) {
    Remove-Item $file.FullName
}

# Retain CSV reports for specified number of days
$ExistingCsvs = Get-ChildItem $LogDir -Filter "*.csv" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$DaysToKeepCsv) }
foreach ($file in $ExistingCsvs) {
    Remove-Item $file.FullName
}

# CSV file path to export, set to the same directory as the script with a unique name
$CsvFileName = "AppRegistrationsReport_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".csv"
$CsvPath = Join-Path $LogDir $CsvFileName
Write-Log "CSV file path set to $CsvPath"

# Connect to MgGraph with necessary scopes
Connect-MgGraph "Directory.Read.All", "Application.Read.All"
Write-Log "Connected to MgGraph"

# Create an array
$Results = @()
Write-Log "Initialized results array"

# Get Applications
$Apps = Get-MgApplication -All -Property AppId, DisplayName, PasswordCredentials, KeyCredentials, Id, SignInAudience, CreatedDateTime
$totalCount = $Apps.Count
$currentCount = 0
Write-Log "Retrieved applications, total count: $totalCount"

foreach ($App in $Apps) {
    $currentCount++
    Write-Log "Processing application [$currentCount/$totalCount]: $($App.DisplayName)"

    # Get Owner information
    $Owner = Get-MgApplicationOwner -All -ApplicationId $App.Id
    $Username = if ($Owner) { $Owner.AdditionalProperties.userPrincipalName -join ';' } else { "N/A" }
    $OwnerID = if ($Owner) { $Owner.Id -join ';' } else { "N/A" }

    # Check application for client secret
    if ($null -ne $App.PasswordCredentials) {
        Write-Log "Checking client secrets for application: $($App.DisplayName)"

        foreach ($Creds in $App.PasswordCredentials) {
            $DaysLeft = ($Creds.EndDateTime - (Get-Date)).Days
            $Properties = [PSCustomObject]@{
                ApplicationName = $App.DisplayName
                CredentialName  = $Creds.DisplayName
                SignInType      = $App.SignInAudience
                CreatedDateTime = $App.CreatedDateTime
                StartDateTime   = $Creds.StartDateTime
                EndDateTime     = $Creds.EndDateTime
                ExpireStatus    = if ($Creds.EndDateTime -lt (Get-Date)) { "Expired" } else { "Not expired" }
                AuthType        = "Client_Secret"
                DaysLeft        = $DaysLeft
                Owner           = $Username
                OwnerID         = $OwnerID
            }
            $Results += $Properties
        }
    }

    # Check application for certificate
    if ($null -ne $App.KeyCredentials) {
        Write-Log "Checking certificates for application: $($App.DisplayName)"

        foreach ($Cert in $App.KeyCredentials) {
            $DaysLeft = ($Cert.EndDateTime - (Get-Date)).Days
            $Properties = [PSCustomObject]@{
                ApplicationName = $App.DisplayName
                CredentialName  = $Cert.DisplayName
                SignInType      = $App.SignInAudience
                CreatedDateTime = $App.CreatedDateTime
                StartDateTime   = $Cert.StartDateTime
                EndDateTime     = $Cert.EndDateTime
                ExpireStatus    = if ($Cert.EndDateTime -lt (Get-Date)) { "Expired" } else { "Not expired" }
                AuthType        = "Certificate"
                DaysLeft        = $DaysLeft
                Owner           = $Username
                OwnerID         = $OwnerID
            }
            $Results += $Properties
        }
    }
}

# Custom sorting: First sort by DaysLeft, then within each DaysLeft group, sort by ApplicationName
$sortedResults = $Results | Sort-Object DaysLeft, ApplicationName

# Export to CSV file
$sortedResults | Export-Csv $CsvPath -Encoding utf8 -NoTypeInformation
Write-Log "Exported results to CSV at $CsvPath"

# Out-GridView
$sortedResults | Out-GridView -Title "Microsoft Entra ID app registrations report"
