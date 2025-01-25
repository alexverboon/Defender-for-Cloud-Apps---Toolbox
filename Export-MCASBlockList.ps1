Function Export-MCASBlocklist {
    <#
.SYNOPSIS
    Gerate Block List from Microsoft Cloud App Security
.DESCRIPTION
    This function fetches the list of Block List from Microsoft Cloud App Security using the MCAS Portal API
.LINK
     https://learn.microsoft.com/en-us/defender-cloud-apps/api-discovery-script
#>
    [CmdletBinding()]
    param (
        # MCAS Portal API URL
        [Parameter(Mandatory = $true)]
        [string]$McasPortalAPI,
        # Access token for authentication
        [Parameter(Mandatory = $true)]
        [string]$Token,
        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'BlueCoat ProxySG (102)', 
            'Cisco ASA (104)', 
            'Fortinet FortiGate (108)', 
            'Juniper SRX (129)', 
            'Palo Alto (112)', 
            'Websense (135)', 
            'Zscaler (120)'
        )]
        [string]$Appliance
    )

    # Mapping of appliances to their formats
    $applianceFormats = @{
        'BlueCoat ProxySG (102)'   = 102
        'Cisco ASA (104)'          = 104
        'Fortinet FortiGate (108)' = 108
        'Juniper SRX (129)'        = 129
        'Palo Alto (112)'          = 112
        'Websense (135)'           = 135
        'Zscaler (120)'            = 120
    }
    $selectedFormat = $applianceFormats[$Appliance]

    $endpoint = "$mcasportalAPI/api/discovery_block_scripts/?format=$selectedFormat&type=banned"
    $headers = @{ 'Authorization' = "Bearer $token" }
    $BlockList = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Get 
    return $BlockList
}