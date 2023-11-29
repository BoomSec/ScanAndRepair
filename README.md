# Scan And Repair
The "Scan And Repair" PowerShell script is a script designed for system analysis, maintenance, and reporting. The script leverages various built-in and custom PowerShell functions to automate common troubleshooting and diagnostic tasks. The following is a breakdown of the key features and details about the latest version of the script:

## Features
- **Hardware Scan & Reporting**: Generates a report of the machine's battery status and exports it to a viewable HTML file.
- **Operating System Analysis**: Executes SFC Scan, DISM Scan, and collects relevant logs for further analysis.
- **Storage Management**: Retrieves a list of connected disks, performs disk cleanup, and calculates the amount of space cleaned.
- **Network Diagnostics**: Captures network configurations, performs ARP, and initiates ping requests to diagnose network connectivity issues.

### Latest Version Additions
- **18/10/23**: Ran comprehensive tests in Windows Sandbox, made multiple fixes and optimizations to the code, and merged differences between forks of the code.
- **13/10/23**: Modularized each section of the script into callable script blocks, added extensive documentation, and made various fixes and updates.
- **12/10/23**: Optimized the script, removed redundant variables, and addressed specific fixes.

## Usage
The script is structured to be run as a whole, and it automates multiple tasks across different aspects of system analysis and maintenance. To use the script:
1. Download the script file to a local directory.
2. Open PowerShell with administrative privileges.
3. Navigate to the directory where the script is located using the `cd` command.
4. Run the script by entering its filename (e.g., `.\ScanAndRepair.ps1`) and press Enter.

## Future Enhancements
The script shares heavy inspirations from TronScript and aims to incorporate additional functionality such as running TronScript as a "final clean," executing ClamAV scans, exporting reliability reports and battery scans, gathering system specifications, and compiling comprehensive reports.

Tronscript can be found below:

https://github.com/bmrf/tron

## Disclaimer
The script is provided "as-is" and is intended for educational and learning purposes. It is crucial to thoroughly understand the code and its implications before running it on production systems. Always exercise caution and ensure that you have a backup of important data before using the script.

