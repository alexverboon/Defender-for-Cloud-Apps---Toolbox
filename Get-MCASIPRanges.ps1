
Function Get-MCASIPRanges {
    <#  
    .SYNOPSIS
        Retrieves the list of IP Ranges from Microsoft Cloud App Security.  
    .DESCRIPTION
        This function fetches the list of IP Ranges from Microsoft Cloud App Security using the MCAS Portal API.        
    .PARAMETER McasPortalAPI
        The URL of the MCAS Portal API.
    .PARAMETER Token
        The access token for authentication.    
    .EXAMPLE    
        Get-MCASIPRanges -McasPortalAPI "https://mymtplab.eu2.portal.cloudappsecurity.com" -Token $token
        Retrieves the list of IP Ranges from Microsoft Cloud App Security.
    #>
    [cmdletbinding()]
    param (
        # The URL of the MCAS Portal API
        [Parameter(Mandatory = $true)]
        [string]$McasPortalAPI,
        # The access token for authentication
        [Parameter(Mandatory = $true)]
        [string]$Token
    )
    $endpoint = "$McasPortalAPI/api/v1/subnet/" 
    $headers = @{ 'Authorization' = "Bearer $token" }
    
    try {
        $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Post 
        $response.data
    }
    catch {
        Write-Host "Failed to fetch data from API. Error: $_"
        return
    }
    return $response.data
    }