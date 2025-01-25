function Remove-MCASIPRange {
    <#
    .SYNOPSIS
        Removes IP Ranges in Microsoft Cloud App Security based on the data in a CSV file.
    .DESCRIPTION    
        This function reads the data from a CSV file containing IP Ranges and removes corresponding IP Ranges in Microsoft Cloud App Security.  
    .PARAMETER CsvFilePath
        The path to the CSV file containing the IP Ranges to be removed.
    .PARAMETER McasPortalAPI
        The URL of the MCAS Portal API. 
    .PARAMETER Token
        The access token for authentication.
    .EXAMPLE    
        Remove-MCASIPRange -CsvFilePath "C:\data\ipranges.csv" -McasPortalAPI "https://mymtplab.eu2.portal.cloudappsecurity.com" -Token $token
        Removes IP Ranges in Microsoft Cloud App Security based on the data in the specified CSV file.
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string]$CsvFilePath,
        
        [Parameter(Mandatory = $true)]
        [string]$McasPortalAPI,
        
        [Parameter(Mandatory = $true)]
        [string]$Token
    )
    
     # Import the CSV file content
     $csvData = Import-Csv -Path $CsvFilePath
    
     # Iterate through each row in the CSV file
     foreach ($row in $csvData) {
         if ($PSCmdlet.ShouldProcess("$($row.name) - $($row.id)", "Remove IP Range")) {
            Write-Host "Removing IP Range for $($row.name)"
            $RuleID = $row.id
            $endpoint = "$McasPortalAPI/api/v1/subnet/$RuleID/"
            $headers = @{ 'Authorization' = "Bearer $Token" }
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method delete 
            Write-Host "Response: $($response | ConvertTo-Json -Depth 2 -Compress)"
        } else {
            Write-Host "Skipped Removal for $($row.name) due to WhatIf mode."
        }
        }
    }