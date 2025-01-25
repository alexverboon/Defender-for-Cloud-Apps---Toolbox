function Update-MCASIPRange {
    <#
    .SYNOPSIS
        Updates IP Ranges in Microsoft Cloud App Security based on the data in a CSV file.
    .DESCRIPTION    
        This function reads the data from a CSV file containing IP Ranges and Updates corresponding IP Ranges in Microsoft Cloud App Security.  
    .PARAMETER CsvFilePath
        The path to the CSV file containing the IP Ranges to be updated.
    .PARAMETER McasPortalAPI
        The URL of the MCAS Portal API. 
    .PARAMETER Token
        The access token for authentication.
    .EXAMPLE    
        Update-MCASIPRange -CsvFilePath "C:\data\ipranges.csv" -McasPortalAPI "https://mymtplab.eu2.portal.cloudappsecurity.com" -Token $token
        Update IP Ranges in Microsoft Cloud App Security based on the data in the specified CSV file.
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param (
        # Path to the CSV file containing the IP Ranges to be updated
        [Parameter(Mandatory = $true)]
        [string]$CsvFilePath,
        #   The URL of the MCAS Portal API
        [Parameter(Mandatory = $true)]
        [string]$McasPortalAPI,
        #   The access token for authentication
        [Parameter(Mandatory = $true)]
        [string]$Token
    )
    
     # Import the CSV file content
     $csvData = Import-Csv -Path $CsvFilePath -Delimiter ","
    
     # Iterate through each row in the CSV file
     foreach ($row in $csvData) {
        $body = @{
            "name"        = $row.name
            "category"    = $row.category
            "organization"= $row.organization
            "subnets"     = $row.subnets -split ";" # Split subnets into an array
            "tags"        = $row.tags -split ";"    # Split tags into an array
        } | ConvertTo-Json -Depth 10
    
         if ($PSCmdlet.ShouldProcess("$($row.name) - $($row.id)", "Update IP Range")) {
            Write-Host "Updating IP Range for $($row.name)"
            $RuleID = $($row.id)
            $endpoint = "$McasPortalAPI/api/v1/subnet/$RuleID/update_rule/"
            $headers = @{ 'Authorization' = "Bearer $Token" }
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Post -Body $body
            Write-Host "Response: $($response | ConvertTo-Json -Depth 2 -Compress)"
        } else {
            Write-Host "Skipped Updating for $($row.name) due to WhatIf mode."
        }
        }
    }
    