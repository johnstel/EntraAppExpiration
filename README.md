# Microsoft Entra ID App Registrations Report Generator

This PowerShell script is designed to automate the generation of reports for Microsoft Entra ID app registrations. It utilizes Microsoft Graph PowerShell modules to fetch applications, their credentials, and owners, then generates a CSV report detailing each application's information including credential expiration. Additionally, the script manages log and CSV files by retaining only the most recent ones based on specified criteria.

## Prerequisites

Before running this script, ensure you have the following:
- PowerShell 5.1 or higher.
- Microsoft Graph PowerShell SDK. The script will attempt to install these modules if they are not present:
  - `Microsoft.Graph`
  - `Microsoft.Graph.Beta`

## Installation

1. Clone this repository or download the script to your local machine.
2. Open PowerShell as an Administrator.
3. Navigate to the directory where the script is saved.
4. If it's the first time running the script or if you haven't installed the Microsoft Graph PowerShell modules, the script will attempt to install them for you.

## Configuration

Before running the script, you might want to adjust the following variables within the script to suit your environment:
- `$DaysToKeepCsv`: The number of days to keep CSV reports (default is 30).
- `$MaxLogFiles`: The maximum number of log files to retain (default is 30).

## Usage

To run the script:
1. Open PowerShell.
2. Navigate to the script's directory.
3. Execute the script by typing `.\[ScriptName].ps1` (replace `[ScriptName]` with the actual script filename).
4. The script will connect to Microsoft Graph, fetch applications, and generate a CSV report in the same directory.

## Features

- **Log Management**: Automatically generates log files for each script execution and retains only the most recent logs as specified.
- **CSV Report Generation**: Creates a detailed CSV report of app registrations, including application names, credential names, types (Client Secret or Certificate), expiration status, and owner information.
- **Automatic Cleanup**: Removes old CSV reports and log files based on specified retention policies.

## Contributing

We welcome contributions! If you have suggestions for improvements or bug fixes, please feel free to fork the repository and submit a pull request.

## License

This project is licensed under the GNU General Public License (GPL). See the [LICENSE](LICENSE) or [COPYING](COPYING) file in the repository for the full license text.

