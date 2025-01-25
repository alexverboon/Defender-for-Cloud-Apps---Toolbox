# Defender-for-Cloud-Apps - Toolbox

A collection of PowerShell functions designed to simplify and automate the management of Microsoft Cloud App Security (MCAS)

## Features

- **Export MCAS Blocklist:** Export and manage blocklists from MCAS.
- **Export MCAS IP Ranges:** Export all IP ranges from MCAS in a structured format (CSV).
- **Get MCAS IP Ranges:** Retrieve and list all existing IP ranges configured in MCAS.
- **Create New MCAS IP Ranges:** Add new IP ranges to your MCAS configuration.
- **Update Existing MCAS IP Ranges:** Modify existing IP ranges in your MCAS setup.
- **Remove MCAS IP Ranges:** Delete IP ranges from MCAS.

## Functions

### 1. `Export-MCASBlockList.ps1`

Exports the current blocklist from MCAS

### 2. `Export-MCASIpRange.ps1`

Exports all IP ranges configured in MCAS, including metadata such as names, categories, and tags, into a CSV file.

### 3. `Get-MCASIPRanges.ps1`

Lists all IP ranges configured in MCAS with their details, including subnets, tags, and IDs.

### 4. `New-MCASIpRange.ps1`

Adds new IP ranges to MCAS with specified names, categories, tags, and subnets.

### 5. `Remove-MCASIPRange.ps1`

Deletes IP ranges from MCAS

### 6. `Update-MCASIPRange.ps1`

Updates details for existing IP ranges in MCAS, including renaming, adding subnets, or updating tags.

## Requirements

- **PowerShell 5.1 or later** (Windows) or **PowerShell 7.x** (cross-platform).
- Entra ID App Registration with the following API Permissions.
  - Discovery.manage
  - Settings.read
  - Settings.manage
- Network access to the MCAS API endpoint.

For more details see [Access Microsoft Defender for Cloud Apps with application context](https://learn.microsoft.com/en-us/defender-cloud-apps/api-authentication-application)

## Installation

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/alexverboon/Defender-for-Cloud-Apps-Toolbox.git
   ```

2. Import the required functions into your PowerShell session:

   ```powershell
   Import-Module .\Export-MCASBlockList.ps1
   Import-Module .\Export-MCASIpRange.ps1
   Import-Module .\Get-MCASIPRanges.ps1
   Import-Module .\New-MCASIpRange.ps1
   Import-Module .\Remove-MCASIPRange.ps1
   Import-Module .\Update-MCASIPRange.ps1
   ```

## Usage

Set variables and get a token

```powershell
$tenantId = '' ### Paste your tenant ID here
$appId = '' ### Paste your Application ID here
$appSecret = '' ### Paste your Application key here
$resourceAppIdUri = '05a65629-4c1b-48c1-a78b-804c4abdd4af' #Microsoft Cloud App Security
$mcasportalAPI = "" ### Your MCAS Portal API, like https://securecorp.eu2.portal.cloudappsecurity.com

# Get the access token
$oAuthUri = "https://login.microsoftonline.com/$TenantId/oauth2/token"
$authBody = [Ordered] @{
    resource = "$resourceAppIdUri"
    client_id = "$appId"
    client_secret = "$appSecret"
    grant_type = 'client_credentials'
}
$authResponse = Invoke-RestMethod -Method Post -Uri $oAuthUri -Body $authBody -ErrorAction Stop
$token = $authResponse.access_token
```

### Example: Export All IP Ranges

```powershell
.\Export-MCASIpRange.ps1 -McasPortalAPI "https://yourmcasapi.com" -Token "your_token" -OutputCsvFilePath "c:\Sampledata\mcas_export.csv"
```

### Example: Add a New IP Range

```powershell
  New-MCASIpRange -CsvFilePath "c:\sampledata\mcasip_new.csv" -McasPortalAPI "https://mymtplab.eu2.portal.cloudappsecurity.com" -Token $token
```

### Example: Remove an IP Range

```powershell
Remove-MCASIPRange -CsvFilePath "C:\sampledata\mcasip_remove.csv" -McasPortalAPI "https://mymtplab.eu2.portal.cloudappsecurity.com" -Token $token
```

For more details, see the [MCAS Tool boxDemo Script](MCASToolBoxDemo.ps1) script

## Contributing

Contributions are welcome! If you’d like to contribute, please:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed explanation of your changes.
