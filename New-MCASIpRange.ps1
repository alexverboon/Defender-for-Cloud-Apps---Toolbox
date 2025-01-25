function New-MCASIpRange {
    <#
    .SYNOPSIS
        Creates IP Ranges in Microsoft Cloud App Security based on the data in a CSV file.
    .DESCRIPTION
        This function reads the data from a CSV file containing IP Ranges and creates corresponding IP Ranges in Microsoft Cloud App Security.
    .PARAMETER CsvFilePath
        The path to the CSV file containing the IP Range data.
    .PARAMETER McasPortalAPI
        The URL of the MCAS Portal API.
    .PARAMETER Token
        The access token for authentication.
    .EXAMPLE    
        New-MCASIpRange -CsvFilePath "C:\data\ipranges.csv" -McasPortalAPI "https://mymtplab.eu2.portal.cloudappsecurity.com" -Token $token
        Creates IP Ranges in Microsoft Cloud App Security based on the data in the specified CSV file.
        
    #>
        [CmdletBinding(SupportsShouldProcess)]
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
            # Transform each row into the desired format
            $body = @{
                "name"        = $row.name
                "category"    = [int]$row.category
                "organization"= $row.organization
                "subnets"     = $row.subnets -split ";" # Split subnets into an array
                "tags"        = $row.tags -split ";"    # Split tags into an array
            } | ConvertTo-Json -Depth 10
            
            # Display action and perform operation only if approved
            if ($PSCmdlet.ShouldProcess("$($row.name)", "Create IP Range")) {
                Write-Host "Creating rule for $($row.name)"
                $endpoint = "$McasPortalAPI/api/v1/subnet/create_rule/"
                $headers = @{ 'Authorization' = "Bearer $Token" }
                Try{
                $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Post -Body $body
                }
                catch {
                    Write-Host "Failed to fetch data from API. Error: $_"
                    return
                }
                # Log the response for each entry
                Write-Host "Response: $($response | ConvertTo-Json -Depth 2 -Compress)"
            } else {
                Write-Host "Skipped rule creation for $($row.name) due to WhatIf mode."
            }
        }
    }