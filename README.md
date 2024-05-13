# Entra ID App Registrations Toolkit

This repository contains two PowerShell scripts designed to manage Entra ID/Azure Active Directory (Azure AD) app registrations. The first script, `Get-AppRegStatus.ps1`, generates reports on the status of app registrations, including credential expiration. The second script, `CreateAADApps.ps1`, creates random app registrations in Azure AD for testing purposes.

## Prerequisites

Before using these scripts, ensure you have the following:
- PowerShell 5.1 or higher.
- Appropriate permissions in Azure AD to create and manage app registrations.
- Install-Module -Name Microsoft.Graph -Force -AllowClobber
- Install-Module -Name Microsoft.Graph.Beta -Force -AllowClobber
- Import-Module -Name Microsoft.Graph
- Import-Module -Name Microsoft.Graph.Beta
- Microsoft Graph PowerShell SDK for `Get-AppRegStatus.ps1`.
- AzureAD PowerShell Module for `CreateAADApps.ps1`.

## Installation

1. Clone this repository or download the scripts to your local machine.
2. Open PowerShell as an Administrator.
3. Navigate to the directory where the scripts are saved.

## Scripts

### 1. Get-AppRegStatus.ps1

This script generates a CSV report detailing each Azure AD application's information, including credential expiration.

#### Configuration

- Adjust variables such as `$DaysToKeepCsv` and `$MaxLogFiles` as needed to fit your retention policies.

#### Usage

- Run `.\Get-AppRegStatus.ps1` in PowerShell.
- The script will install and import necessary Microsoft Graph PowerShell modules, connect to Microsoft Graph, and generate the report.

### 2. CreateAADApps.ps1

This script creates random Azure AD app registrations, useful for testing environments.

#### Setup

- Update the `$yourFQDN` variable in the script with your domain.
- The script will install the AzureAD PowerShell Module if it's not already installed.

#### Running the Script

- Execute `.\CreateAADApps.ps1` in PowerShell.
- The script will create app registrations with random names and log the details.

## Features

- **Log and CSV Management**: `Get-AppRegStatus.ps1` manages log and CSV files based on specified retention policies.
- **Random App Registrations**: `CreateAADApps.ps1` generates random app registrations with unique names and client secrets.
- **Detailed Reporting**: `Get-AppRegStatus.ps1` provides detailed reports on app registration statuses, including expirations.

## Contributing

Contributions are welcome! If you have suggestions for improvements or bug fixes, please fork the repository and submit a pull request.

## License

This project is licensed under the GNU General Public License (GPL). See the [LICENSE](LICENSE) or [COPYING](COPYING) file in the repository for the full license text.
